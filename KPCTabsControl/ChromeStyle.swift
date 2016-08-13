//
//  ChromeStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 13/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Cocoa

public struct ChromeStyle: Style {

    /// Exposes the color used by selected tabs to style the view below in a matching way.
    public static var panelBackgroundColor: NSColor {
        return Colors.tabBackgroundSelected
    }

    public static var recommendedTabsControlHeight: CGFloat {
        return 34
    }

    enum Colors {
        static let tabControlBackground = NSColor(calibratedWhite: 216/256.0, alpha: 1.0)

        static let border = NSColor(calibratedWhite: 152/256.0, alpha: 1.0)

        static let tabBackgroundUnselected = Colors.tabControlBackground
        static let tabBackgroundSelected = NSColor(calibratedWhite: 245/256.0, alpha: 1.0)

        static func tabBackground(isSelected: Bool) -> NSColor {

            if isSelected { return tabBackgroundSelected }

            return tabBackgroundUnselected
        }
    }

    public let tabWidth: FlexibleTabWidth = FlexibleTabWidth(min: 80, max: 180)

    public init() { }

    public func maxIconHeight(tabRect rect: NSRect, scale: CGFloat) -> CGFloat {

        let verticalPadding: CGFloat = 4.0
        let paddedHeight = rect.height - 2 * verticalPadding

        return 1.2 * paddedHeight * scale
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

    public func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect {
        let paddedHeight = PaddedHeight.fromFrame(rect)
        // Left border is angled at 45˚, so it grows proportionally wider
        let iconOffset = showingIcon ? paddedHeight.iconHeight + 4 : 0.0
        let xOffset = paddedHeight.value / 2 + iconOffset
        let yOffset = paddedHeight.topPadding - 2

        return rect
            .offsetBy(dx: xOffset, dy: yOffset)
            .shrinkBy(dx: xOffset, dy: yOffset)
    }

    public func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString {
        let attributes = [
            NSFontAttributeName: NSFont.systemFontOfSize(14)
        ]
        return NSAttributedString(string: content, attributes: attributes)
    }

    enum PaddedHeight {

        case unpadded(CGFloat, originalHeight: CGFloat)
        case padded(CGFloat, originalHeight: CGFloat)

        static func fromFrame(frame: NSRect) -> PaddedHeight {

            let paddedHeight = frame.height * 0.7

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
            return originalHeight - topPadding - bottomPadding
        }
    }

    public func drawTabBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool) {

        let height: CGFloat = PaddedHeight.fromFrame(frame).value
        let xOffset = height / 2.0
        
        let lowerLeft  = frame.origin + Offset(x: 0, y: frame.height)
        let upperLeft  = lowerLeft + Offset(x: xOffset, y: -height)
        let lowerRight = lowerLeft + Offset(x: frame.width, y: 0)
        let upperRight = lowerRight + Offset(x: -xOffset, y: -height)

        let path = NSBezierPath()

        // TODO: Remove these awful hardcoded values...
        // Remember that Origin start in upper left corner.
        
        // Lower left point.
        path.moveToPoint(lowerLeft)
        
        // Before aligning to the top, make a slight curve.
        let leftRisingFromPoint = CGPointMake(lowerLeft.x+5.0, lowerLeft.y);
        let leftRisingToPoint = CGPointMake(lowerLeft.x+5.0, lowerLeft.y-5.0);
        path.appendBezierPathWithArcFromPoint(leftRisingFromPoint, toPoint:leftRisingToPoint, radius:5.0)

        // Before reaching the top, stop at the point of the coming curve
        let leftToppingPoint = CGPointMake(upperLeft.x-5.0, upperLeft.y+5.0);
        path.lineToPoint(leftToppingPoint)
        
        // Curve to the top!
        let leftToppingFromPoint = CGPointMake(upperLeft.x-5.0, upperLeft.y);
        path.appendBezierPathWithArcFromPoint(leftToppingFromPoint, toPoint:upperLeft, radius:5.0)

        // Line to the upper right
        path.lineToPoint(upperRight)
        
        // Before aligning to fall down, make a slight curve
        let rightFallingFromPoint = CGPointMake(upperRight.x+5.0, upperRight.y);
        let rightFallingToPoint = CGPointMake(upperRight.x+5.0, upperRight.y+5.0);
        path.appendBezierPathWithArcFromPoint(rightFallingFromPoint, toPoint:rightFallingToPoint, radius:5.0)

        // Before reaching the bottom right, stop at the point of the coming curve
        let rightBottomingPoint = CGPointMake(lowerRight.x-5.0, lowerRight.y-5.0);
        path.lineToPoint(rightBottomingPoint)
        
        // Curve to the bottom
        let rightBottomingFromPoint = CGPointMake(lowerRight.x-5.0, lowerRight.y);
        path.appendBezierPathWithArcFromPoint(rightBottomingFromPoint, toPoint:lowerRight, radius:5.0)

        path.lineWidth = 1

        Colors.tabBackground(isSelected).setFill()
        path.fill()

        Colors.border.setStroke()
        path.stroke()

        if !isSelected {
            drawBottomBorder(frame: frame)
        }
    }

    public func drawTabControlBezel(frame frame: NSRect) {
        Colors.tabControlBackground.setFill()
        NSRectFill(frame)
        self.drawBottomBorder(frame: frame)
    }

    private func drawBottomBorder(frame frame: NSRect) {
        let bottomBorder = NSRect(
            origin: frame.origin + Offset(x: 0, y: frame.height - 1),
            size: NSSize(width: frame.width, height: 1))
        Colors.border.setFill()
        NSRectFill(bottomBorder)
    }

    public func tabButtonOffset(position position: TabButtonPosition) -> Offset {
        switch position {
        case .first: return NSPoint()
        case .middle, .last: return NSPoint(x: -10, y: 0)
        }
    }
}

func +(lhs: NSPoint, rhs: Offset) -> NSPoint {
    return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}