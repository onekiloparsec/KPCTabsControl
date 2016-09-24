//
//  SafariTheme.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 27/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

public class SafariTheme: Theme {
    
    public init() { }
    
    public let tabButtonTheme: TabButtonTheme = DefaultTabButtonTheme()
    public let selectedTabButtonTheme: TabButtonTheme = SelectedTabButtonTheme()
    public let unselectableTabButtonTheme: TabButtonTheme = UnselectableTabButtonTheme()
    public let tabsControlTheme: TabsControlTheme = DefaultTabsControlTheme()
    
    fileprivate static var sharedBackgroundColor: NSColor { return NSColor(white: 0.72, alpha: 1.0) }
    fileprivate static var sharedBorderColor: NSColor { return NSColor(white: 0.61, alpha: 1.0) }
    
    fileprivate class DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        public init() { }
        
        var backgroundColor: NSColor { return SafariTheme.sharedBackgroundColor }
        var borderColor: NSColor { return SafariTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor(white: 0.38, alpha: 1.0) }
        var titleFont: NSFont { return NSFont.systemFont(ofSize: NSFont.systemFontSize()) }
    }
    
    fileprivate class SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        public init() { }
        
        var backgroundColor: NSColor { return NSColor(white: 0.79, alpha: 1.0) }
        var borderColor: NSColor { return NSColor(white: 0.64, alpha: 1.0) }
        var titleColor: NSColor { return NSColor(white: 0.08, alpha: 1.0) }
        var titleFont: NSFont { return NSFont.systemFont(ofSize: NSFont.systemFontSize()) }
    }

    fileprivate class UnselectableTabButtonTheme: KPCTabsControl.TabButtonTheme {
        public init() {
            self.base = DefaultTabButtonTheme()
        }
        
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor { return base.backgroundColor }
        var borderColor: NSColor { return base.borderColor }
        var titleColor: NSColor { return NSColor(white: 0.94, alpha: 1.0) }
        var titleFont: NSFont { return base.titleFont }
    }

    fileprivate class DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {
        public init() { }
        
        var backgroundColor: NSColor { return SafariTheme.sharedBackgroundColor }
        var borderColor: NSColor { return SafariTheme.sharedBorderColor }
    }
}
