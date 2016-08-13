//
//  ChromeStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 13/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Cocoa

public struct ChromeStyle: Style {

    public let tabWidth: FlexibleWidth = FlexibleWidth(min: 80, max: 180)

    public init() { }

    public func maxIconHeight(tabRect rect: NSRect, scale: CGFloat) -> CGFloat {

        let verticalPadding: CGFloat = 2.0
        let paddedHeight = CGRectGetHeight(rect) - 2 * verticalPadding

        return 1.2 * paddedHeight * scale
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

    public func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect {

        return rect
    }

    public func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString {

        return NSAttributedString(string: content)
    }

    public func drawTabBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool) {

        NSColor.lightGrayColor().setFill()
        NSRectFill(frame)
    }

    public func drawTabControlBezel(frame frame: NSRect) {

        NSColor.darkGrayColor().setFill()
        NSRectFill(frame)
    }
}
