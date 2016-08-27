//
//  DefaultTheme.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

/**
 *  The default TabsControl theme. Used with the DefaultStyle, it provides an experience similar to Apple's Numbers.app.
 */
public struct DefaultTheme: Theme {

    public init() { }
    
    public let tabButtonTheme: TabButtonTheme = DefaultTabButtonTheme()
    public let selectedTabButtonTheme: TabButtonTheme = SelectedTabButtonTheme(base: DefaultTabButtonTheme())
    public let tabsControlTheme: TabsControlTheme = DefaultTabsControlTheme()

    private static var sharedBorderColor: NSColor { return NSColor.lightGrayColor() }
    private static var sharedBackgroundColor: NSColor { return NSColor(calibratedWhite: 0.95, alpha: 1.0) }

    private struct DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        
        var backgroundColor: NSColor { return DefaultTheme.sharedBackgroundColor }
        var borderColor: NSColor { return DefaultTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.darkGrayColor() }
        var titleFont: NSFont { return NSFont.systemFontOfSize(13) }
    }

    private struct SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {

        let base: DefaultTabButtonTheme

        var backgroundColor: NSColor { return NSColor(calibratedRed: 205.0/255.0, green: 222.0/255.0, blue: 244.0/255.0, alpha: 1.0) }
        var borderColor: NSColor { return NSColor(calibratedRed: 185.0/255.0, green: 202.0/255.0, blue: 224.0/255.0, alpha: 1.0) }
        var titleColor: NSColor { return NSColor(calibratedRed: 85.0/255.0, green: 102.0/255.0, blue: 124.0/255.0, alpha: 1.0) }
        var titleFont: NSFont { return NSFont.boldSystemFontOfSize(13) }
    }

    private struct DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {

        var backgroundColor: NSColor { return DefaultTheme.sharedBackgroundColor }
        var borderColor: NSColor { return DefaultTheme.sharedBorderColor }
    }
}