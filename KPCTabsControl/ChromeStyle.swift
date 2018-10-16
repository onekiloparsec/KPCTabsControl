//
//  ChromeStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 13/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public struct ChromeStyle: ThemedStyle {
    public let theme: Theme
    public let tabButtonWidth: TabWidth
    public let tabsControlRecommendedHeight: CGFloat = 34.0
    
    public init(theme: Theme = ChromeTheme(), tabButtonWidth: TabWidth = .flexible(min: 80, max: 180)) {
        self.theme = theme
        self.tabButtonWidth = tabButtonWidth
    }

    public func iconFrames(tabRect rect: NSRect) -> IconFrames {
        
        let paddedHeight = PaddedHeight.fromFrame(rect)
        let topPadding = paddedHeight.topPadding
        let iconHeight = paddedHeight.iconHeight
        let x = rect.width / 2.0 - iconHeight / 2.0

        // Left border is angled at 45˚, so it grows proportionally wider
        let iconXOffset = paddedHeight.value / 2
        
        return (
            NSMakeRect(iconXOffset, topPadding, iconHeight, iconHeight),
            NSMakeRect(x, topPadding, iconHeight, iconHeight)
        )
    }

    public func titleRect(title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect {
        let paddedHeight = PaddedHeight.fromFrame(rect)
        // Left border is angled at 45˚, so it grows proportionally wider
        let iconOffset = showingIcon ? paddedHeight.iconHeight + 4 : 0.0
        let xOffset = paddedHeight.value / 2 + 0.5
        let yOffset = paddedHeight.topPadding - 2

        return rect
            .offsetBy(dx: xOffset + iconOffset, dy: yOffset)
            .shrinkBy(dx: 2 * xOffset + iconOffset, dy: yOffset + 2)
    }

    // TODO: Not sure what to decide about the visibility here? Same for PaddedHeight
    fileprivate enum Defaults {
        static let alignment = NSTextAlignment.left
    }

    public func titleEditorSettings() -> TitleEditorSettings {
        return (textColor: self.theme.tabButtonTheme.titleColor,
                font: self.theme.tabButtonTheme.titleFont,
                alignment: Defaults.alignment)
    }

    public func attributedTitle(content: String, selectionState: TabSelectionState) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = Defaults.alignment

        let activeTheme = self.theme.tabButtonTheme(fromSelectionState: selectionState)

        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.font: activeTheme.titleFont,
                          NSAttributedString.Key.foregroundColor: activeTheme.titleColor]

        return NSAttributedString(string: content, attributes: attributes)
    }

    fileprivate enum PaddedHeight {

        case unpadded(CGFloat, originalHeight: CGFloat)
        case padded(CGFloat, originalHeight: CGFloat)

        static func fromFrame(_ frame: NSRect) -> PaddedHeight {

            let paddedHeight = floor(frame.height * 0.7)

            // Chrome tabs have lots of whitespace to the top; if that's
            // too cramped, don't try to achieve that effect.
            guard paddedHeight > 20 else {
                return .unpadded(frame.height - 2, originalHeight: frame.height)
            }

            return .padded(paddedHeight, originalHeight: frame.height)
        }

        var value: CGFloat {
            switch self {
            case .unpadded(let height, _): return height
            case .padded(let height, _): return height
            }
        }

        var bottomPadding: CGFloat {
            return CGFloat(4)
        }

        var topPadding: CGFloat {
            switch self {
            case .unpadded: return bottomPadding + 2
            case let .padded(height, originalHeight):
                /// Visual distance to top TabsControl border.
                let tabMargin = originalHeight - height
                return tabMargin + bottomPadding
            }
        }

        var originalHeight: CGFloat {
            switch self {
            case .unpadded(_, let originalHeight): return originalHeight
            case .padded(_, let originalHeight): return originalHeight
            }
        }

        var iconHeight: CGFloat {
            return self.originalHeight - self.topPadding - self.bottomPadding
        }
    }

    public func drawTabButtonBezel(frame: NSRect, position: TabPosition, isSelected: Bool) {

        let height: CGFloat = PaddedHeight.fromFrame(frame).value
        let xOffset = height / 2.0
        let curve = CGFloat(4)
        
        let lowerLeft  = frame.origin + Offset(y: frame.height)
        let upperLeft  = lowerLeft + Offset(x: xOffset, y: -height - 0.5)
        let lowerRight = lowerLeft + Offset(x: frame.width - 1)
        let upperRight = lowerRight + Offset(x: -xOffset, y: -height - 0.5)

        // Let's build tab path
        let path = NSBezierPath()
        
        // Lower left point.
        path.move(to: lowerLeft)
        
        // Before aligning to the top, make a slight curve.
        let leftRisingFromPoint = lowerLeft + Offset(x: curve)
        let leftRisingToPoint = lowerLeft + Offset(x: curve, y: -curve)
        path.appendArc(from: leftRisingFromPoint, to: leftRisingToPoint, radius: curve)

        // Before reaching the top, stop at the point of the coming curve
        let leftToppingPoint = upperLeft + Offset(x: -curve, y: curve)
        path.line(to: leftToppingPoint)
        
        // Curve to the top!
        let leftToppingFromPoint = upperLeft + Offset(x: -curve)
        path.appendArc(from: leftToppingFromPoint, to: upperLeft, radius: curve)

        // Line to the upper right
        path.line(to: upperRight)
        
        // Before aligning to fall down, make a slight curve
        let rightFallingFromPoint = upperRight + Offset(x: curve)
        let rightFallingToPoint = upperRight + Offset(x: curve, y: curve)
        path.appendArc(from: rightFallingFromPoint, to: rightFallingToPoint, radius: curve)

        // Before reaching the bottom right, stop at the point of the coming curve
        let rightBottomingPoint = lowerRight + Offset(x: -curve, y: -curve)
        path.line(to: rightBottomingPoint)
        
        // Curve to the bottom
        let rightBottomingFromPoint = lowerRight + Offset(x: -curve)
        path.appendArc(from: rightBottomingFromPoint, to: lowerRight, radius: curve)

        path.lineWidth = 1

        let activeTheme = isSelected ? self.theme.selectedTabButtonTheme : self.theme.tabButtonTheme
        activeTheme.backgroundColor.setFill()
        path.fill()

        activeTheme.borderColor.setStroke()
        path.stroke()

        if !isSelected {
            self.drawBottomBorder(frame: frame)
        }
    }

    public func drawTabsControlBezel(frame: NSRect) {
        self.theme.tabsControlTheme.backgroundColor.setFill()
        frame.fill()
        self.drawBottomBorder(frame: frame)
    }

    fileprivate func drawBottomBorder(frame: NSRect) {
        let bottomBorder = NSRect(origin: frame.origin + Offset(y: frame.height - 1),
                                  size: NSSize(width: frame.width, height: 1))
        
        self.theme.tabsControlTheme.borderColor.setFill()
        bottomBorder.fill()
    }

    public func tabButtonOffset(position: TabPosition) -> Offset {
        switch position {
        case .first: return NSPoint()
        case .middle, .last: return NSPoint(x: -10, y: 0)
        }
    }
}
