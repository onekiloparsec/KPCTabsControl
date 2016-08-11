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

        var borderRects: Array<NSRect> = [NSZeroRect, NSZeroRect, NSZeroRect, NSZeroRect]
        var borderRectCount: NSInteger = 0
        let borderMask: TabsControlBorderMask = {
            switch position {
            case .first: return [.Left, .Bottom]
            case .middle: return .Bottom
            case .last: return [.Right, .Bottom]
            }
        }()

        if RectArrayWithBorderMask(frame, borderMask: borderMask, rectArray: &borderRects, rectCount: &borderRectCount) {

            let color = activeStyle.borderColor
            color.setFill()
            color.setStroke()
            NSRectFillList(borderRects, borderRectCount)
        }
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
}

@available(*, deprecated=1.0)
func RectArrayWithBorderMask(sourceRect: NSRect, borderMask: TabsControlBorderMask, inout rectArray: Array<NSRect>, inout rectCount: NSInteger) -> Bool
{
    var outputCount: NSInteger = 0
    var remainderRect: NSRect = NSZeroRect

    if borderMask.contains(.Top) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MinY)
        outputCount += 1
    }
    if borderMask.contains(.Left) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MinX)
        outputCount += 1
    }
    if borderMask.contains(.Right) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MaxX)
        outputCount += 1
    }
    if borderMask.contains(.Bottom) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MaxY)
        outputCount += 1
    }

    rectCount = outputCount

    return (outputCount > 0)
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
