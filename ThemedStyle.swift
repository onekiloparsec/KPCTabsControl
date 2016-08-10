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
