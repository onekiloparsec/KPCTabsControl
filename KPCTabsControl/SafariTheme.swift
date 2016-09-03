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
    
    private static var sharedBackgroundColor: NSColor { return NSColor(white: 0.72, alpha: 1.0) }
    private static var sharedBorderColor: NSColor { return NSColor(white: 0.61, alpha: 1.0) }
    
    private struct DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        
        var backgroundColor: NSColor { return SafariTheme.sharedBackgroundColor }
        var borderColor: NSColor { return SafariTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor(white: 0.38, alpha: 1.0) }
        var titleFont: NSFont { return NSFont.systemFontOfSize(NSFont.systemFontSize()) }
    }
    
    private struct SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        
        var backgroundColor: NSColor { return NSColor(white: 0.79, alpha: 1.0) }
        var borderColor: NSColor { return NSColor(white: 0.64, alpha: 1.0) }
        var titleColor: NSColor { return NSColor(white: 0.08, alpha: 1.0) }
        var titleFont: NSFont { return NSFont.systemFontOfSize(NSFont.systemFontSize()) }
    }
    
    private struct DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {
        
        var backgroundColor: NSColor { return SafariTheme.sharedBackgroundColor }
        var borderColor: NSColor { return SafariTheme.sharedBorderColor }
    }
}