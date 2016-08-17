//
//  ChromeTheme.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public struct ChromeTheme: Theme {

    public init() { }

    public let tabButtonTheme: TabButtonTheme = DefaultTabButtonTheme()
    public let selectedTabButtonTheme: TabButtonTheme = SelectedTabButtonTheme(base: DefaultTabButtonTheme())
    public let tabsControlTheme: TabsControlTheme = DefaultTabsControlTheme()
    
    private static var sharedBorderColor: NSColor { return NSColor(calibratedWhite: 152/256.0, alpha: 1.0) }
    private static var sharedBackgroundColor: NSColor { return NSColor(calibratedWhite: 216/256.0, alpha: 1.0) }

    private struct DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        
        var backgroundColor: NSColor { return ChromeTheme.sharedBackgroundColor }
        var borderColor: NSColor { return ChromeTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.controlTextColor() }
        var titleFont: NSFont { return NSFont.systemFontOfSize(14) }
    }
    
    private struct SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor { return NSColor(calibratedWhite: 245/256.0, alpha: 1.0) }
        var borderColor: NSColor { return base.borderColor }
        var titleColor: NSColor { return base.titleColor }
        var titleFont: NSFont { return base.titleFont }
    }
    
    private struct DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {
        
        var borderColor: NSColor { return ChromeTheme.sharedBorderColor }
        var backgroundColor: NSColor { return ChromeTheme.sharedBackgroundColor }
    }
}
