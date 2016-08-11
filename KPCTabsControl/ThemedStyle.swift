//
//  ThemedStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public struct ThemedStyle: Style {
    public let theme: Theme
    public let tabWidth: FlexibleWidth

    public init(theme: Theme, tabWidth: FlexibleWidth = FlexibleWidth(min: 50, max: 150)) {

        self.theme = theme
        self.tabWidth = tabWidth
    }

    public func iconFrames(tabRect rect: NSRect) -> IconFrames {

        let verticalPadding: CGFloat = 2.0
        let paddedHeight = CGRectGetHeight(rect) - 2*verticalPadding
        let x = CGRectGetWidth(rect) / 2.0 - paddedHeight / 2.0

        return (
            NSMakeRect(10.0, verticalPadding, paddedHeight, paddedHeight),
            NSMakeRect(x, verticalPadding, paddedHeight, paddedHeight)
        )
    }

    public func maxIconHeight(tabRect rect: NSRect, scale: CGFloat = 1.0) -> CGFloat {

        let verticalPadding: CGFloat = 2.0
        let paddedHeight = CGRectGetHeight(rect) - 2 * verticalPadding

        return 1.2 * paddedHeight * scale
    }

    public func drawTabBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool) {

        let activeStyle = isSelected ? theme.selectedTabStyle : theme.tabStyle

        let color = activeStyle.backgroundColor
        color.setFill()
        NSRectFill(frame)

        let borderMask: BorderDrawing.Mask = {
            switch position {
            case .first: return [.left, .bottom]
            case .middle: return .bottom
            case .last: return [.right, .bottom]
            }
        }()
        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: borderMask)

        drawBorder(borderDrawing, color: activeStyle.borderColor)
    }

    public func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect {

        let titleSize = title.size()
        let fullWidthRect = NSMakeRect(NSMinX(rect), NSMidY(rect) - titleSize.height/2.0, NSWidth(rect), titleSize.height)

        return paddedRectForIcon(fullWidthRect, showingIcon: showingIcon)
    }

    private func paddedRectForIcon(rect: NSRect, showingIcon: Bool) -> NSRect {

        guard showingIcon else { return rect }

        let width = CGFloat(19) // TODO replace assumption about icon size with different mechanism (like handing down the `icon` to this cell, using `image` and code from commit `2f56dbdbfed4d15fa063b03301ed49d5e00cad6e`)
        let padding = CGFloat(8)
        let horizontalOffset = width + padding

        return rect.offsetBy(dx: horizontalOffset, dy: 0).shrinkBy(dx: horizontalOffset, dy: 0)
    }

    public func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString {

        let activeStyle = isSelected ? self.theme.selectedTabStyle : self.theme.tabStyle
        let titleColor = activeStyle.titleColor
        let font = activeStyle.titleFont

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center

        let attributes = [
            NSForegroundColorAttributeName : titleColor,
            NSFontAttributeName : font,
            NSParagraphStyleAttributeName : paragraphStyle
        ]

        return NSAttributedString(string: content, attributes: attributes)
    }

    public func drawTabControlBezel(frame frame: NSRect) {
        self.theme.tabBarStyle.backgroundColor.setFill()
        NSRectFill(frame)

        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: .top)
        drawBorder(borderDrawing, color: self.theme.tabBarStyle.borderColor)
    }

    private func drawBorder(border: BorderDrawing, color: NSColor) {

        guard case let .draw(borderRects: borderRects, rectCount: borderRectCount) = border
            else { return }

        color.setFill()
        color.setStroke()
        NSRectFillList(borderRects, borderRectCount)
    }
}

private enum BorderDrawing {
    case empty
    case draw(borderRects: [NSRect], rectCount: Int)

    static func fromMask(sourceRect: NSRect, borderMask: Mask) -> BorderDrawing {

        var outputCount: NSInteger = 0
        var remainderRect = NSZeroRect
        var borderRects: [NSRect] = [NSZeroRect, NSZeroRect, NSZeroRect, NSZeroRect]

        if borderMask.contains(.top) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 1, .MinY)
            outputCount += 1
        }
        if borderMask.contains(.left) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 1, .MinX)
            outputCount += 1
        }
        if borderMask.contains(.right) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 1, .MaxX)
            outputCount += 1
        }
        if borderMask.contains(.bottom) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 1, .MaxY)
            outputCount += 1
        }

        guard outputCount > 0 else { return .empty }

        return .draw(borderRects: borderRects, rectCount: outputCount)
    }

    struct Mask: OptionSetType {
        let rawValue: Int

        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let top = Mask(rawValue: 1 << 0)
        static let left = Mask(rawValue: 1 << 1)
        static let right = Mask(rawValue: 1 << 2)
        static let bottom = Mask(rawValue: 1 << 3)
    }
}

public protocol Theme {
    var tabStyle: TabStyle { get }
    var highlightedTabStyle: TabStyle { get }
    var selectedTabStyle: TabStyle { get }

    var tabBarStyle: TabBarStyle { get }
    var highlightedTabBarStyle: TabBarStyle { get }
}

public protocol TabStyle {
    var backgroundColor: NSColor { get }
    var borderColor: NSColor { get }
    var titleColor: NSColor { get }
    var titleFont: NSFont { get }
}

public protocol TabBarStyle {
    var backgroundColor: NSColor { get }
    var borderColor: NSColor { get }
}
