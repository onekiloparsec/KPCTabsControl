//
//  ChromeTheme.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public class ChromeTheme: Theme {

    public init() { }

    public let tabButtonTheme: TabButtonTheme = DefaultTabButtonTheme()
    public let selectedTabButtonTheme: TabButtonTheme = SelectedTabButtonTheme()
    public let unselectableTabButtonTheme: TabButtonTheme = UnselectableTabButtonTheme()
    public let tabsControlTheme: TabsControlTheme = DefaultTabsControlTheme()
    
    fileprivate static var sharedBorderColor: NSColor { return NSColor(calibratedWhite: 152/256.0, alpha: 1.0) }
    fileprivate static var sharedBackgroundColor: NSColor { return NSColor(calibratedWhite: 216/256.0, alpha: 1.0) }

    fileprivate class DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        public init() { }
        
        var backgroundColor: NSColor { return ChromeTheme.sharedBackgroundColor }
        var borderColor: NSColor { return ChromeTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.controlTextColor }
        var titleFont: NSFont { return NSFont.systemFont(ofSize: 14) }
    }
    
    fileprivate class SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        public init() {
            self.base = DefaultTabButtonTheme()
        }
        
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor { return NSColor(calibratedWhite: 245/256.0, alpha: 1.0) }
        var borderColor: NSColor { return base.borderColor }
        var titleColor: NSColor { return base.titleColor }
        var titleFont: NSFont { return base.titleFont }
    }
    
    fileprivate class UnselectableTabButtonTheme: KPCTabsControl.TabButtonTheme {
        public init() {
            self.base = DefaultTabButtonTheme()
        }
        
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor { return base.backgroundColor }
        var borderColor: NSColor { return base.borderColor }
        var titleColor: NSColor { return NSColor.lightGray }
        var titleFont: NSFont { return base.titleFont }
    }

    fileprivate class DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {
        public init() { }
        
        var borderColor: NSColor { return ChromeTheme.sharedBorderColor }
        var backgroundColor: NSColor { return ChromeTheme.sharedBackgroundColor }
    }
}
