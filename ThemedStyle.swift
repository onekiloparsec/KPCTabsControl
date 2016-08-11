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

    public func drawTabButton(rect dirtyRect: NSRect, scale: CGFloat = 1.0) {

        // nothing done for this style
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
}

public protocol TabBarStyle {
    var backgroundColor: NSColor { get }
    var borderColor: NSColor { get }
}
