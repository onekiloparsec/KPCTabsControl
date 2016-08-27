//
//  SafariTheme.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 27/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

public struct SafariTheme: Theme {
    
    public init() { }
    
    public let tabButtonTheme: TabButtonTheme = DefaultTabButtonTheme()
    public let selectedTabButtonTheme: TabButtonTheme = SelectedTabButtonTheme()
    public let tabsControlTheme: TabsControlTheme = DefaultTabsControlTheme()
    
    private static var sharedBorderColor: NSColor { return NSColor.darkGrayColor() }
    
    private struct DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        
        var backgroundColor: NSColor { return NSColor.controlBackgroundColor() }
        var borderColor: NSColor { return SafariTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.controlTextColor() }
        var titleFont: NSFont { return NSFont.systemFontOfSize(NSFont.systemFontSize()) }
    }
    
    private struct SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        
        var backgroundColor: NSColor { return NSColor.selectedTextBackgroundColor() }
        var borderColor: NSColor { return SafariTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.selectedControlTextColor() }
        var titleFont: NSFont { return NSFont.systemFontOfSize(NSFont.systemFontSize()) }
    }
    
    private struct DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {
        
        var backgroundColor: NSColor { return NSColor.controlBackgroundColor() }
        var borderColor: NSColor { return SafariTheme.sharedBorderColor }
    }
}