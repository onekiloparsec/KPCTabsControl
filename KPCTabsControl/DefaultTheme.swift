//
//  DefaultTheme.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public struct DefaultTheme: Theme {

    public init() { }
    
    public let tabStyle: TabStyle = DefaultTabStyle()
    public let highlightedTabStyle: TabStyle = HighlightedTabStyle(base: DefaultTabStyle())
    public let selectedTabStyle: TabStyle = SelectedTabStyle(base: DefaultTabStyle())

    public let tabBarStyle: TabBarStyle = DefaultTabBarStyle()
    public let highlightedTabBarStyle: TabBarStyle = HighlightedTabBarStyle(base: DefaultTabBarStyle())

    private static var sharedBorderColor: NSColor { return NSColor.lightGrayColor() }
    private static var sharedBackgroundColor: NSColor { return NSColor(calibratedWhite: 0.95, alpha: 1.0) }
    private static var sharedHighlightedBackgroundColor: NSColor { return NSColor(calibratedWhite: 0.85, alpha: 1.0) }

    struct DefaultTabStyle: KPCTabsControl.TabStyle {

        var borderColor: NSColor { return DefaultTheme.sharedBorderColor }
        var backgroundColor: NSColor { return DefaultTheme.sharedBackgroundColor }
        var titleColor: NSColor { return NSColor.darkGrayColor() }
    }

    struct HighlightedTabStyle: KPCTabsControl.TabStyle {

        let base: DefaultTabStyle

        var borderColor: NSColor { return base.borderColor }
        var backgroundColor: NSColor { return DefaultTheme.sharedHighlightedBackgroundColor }
        var titleColor: NSColor { return base.titleColor }
    }

    struct SelectedTabStyle: KPCTabsControl.TabStyle {

        let base: DefaultTabStyle

        var borderColor: NSColor { return NSColor(calibratedRed: 185.0/255.0, green: 202.0/255.0, blue: 224.0/255.0, alpha: 1.0) }
        var backgroundColor: NSColor { return NSColor(calibratedRed: 205.0/255.0, green: 222.0/255.0, blue: 244.0/255.0, alpha: 1.0) }
        var titleColor: NSColor { return NSColor(calibratedRed: 85.0/255.0, green: 102.0/255.0, blue: 124.0/255.0, alpha: 1.0) }
    }

    struct DefaultTabBarStyle: KPCTabsControl.TabBarStyle {

        var borderColor: NSColor { return DefaultTheme.sharedBorderColor }
        var backgroundColor: NSColor { return DefaultTheme.sharedBackgroundColor }
    }

    struct HighlightedTabBarStyle: KPCTabsControl.TabBarStyle {

        let base: DefaultTabBarStyle

        var borderColor: NSColor { return base.borderColor }
        var backgroundColor: NSColor { return DefaultTheme.sharedHighlightedBackgroundColor }
    }
}