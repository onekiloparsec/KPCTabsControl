//
//  Style.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

protocol Theme {
    var tabStyle: TabStyle { get }
    var highlightedTabStyle: TabStyle { get }
    var selectedTabStyle: TabStyle { get }

    var tabBarStyle: TabBarStyle { get }
    var highlightedTabBarStyle: TabBarStyle { get }
}

protocol TabStyle {
    var backgroundColor: NSColor { get }
    var borderColor: NSColor { get }
    var titleColor: NSColor { get }
}

protocol TabBarStyle {
    var backgroundColor: NSColor { get }
    var borderColor: NSColor { get }
}

@available(*, deprecated=1.0)
public enum TabsControlTabsStyle {
    case NumbersApp
    case ChromeBrowser
    case SafariBrowser
    case XcodeNavigators
}
