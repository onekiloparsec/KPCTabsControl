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
    public let unselectableTabButtonTheme: TabButtonTheme = UnselectableTabButtonTheme(base: DefaultTabButtonTheme())
    public let tabsControlTheme: TabsControlTheme = DefaultTabsControlTheme()

    fileprivate static var sharedBorderColor: NSColor { return NSColor.lightGray }
    fileprivate static var sharedBackgroundColor: NSColor { return NSColor(calibratedWhite: 0.95, alpha: 1.0) }

    fileprivate struct DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        var backgroundColor: NSColor { return DefaultTheme.sharedBackgroundColor }
        var borderColor: NSColor { return DefaultTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.darkGray }
        var titleFont: NSFont { return NSFont.systemFont(ofSize: 13) }
    }

    fileprivate struct SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        let base: DefaultTabButtonTheme
        let blueColor = NSColor(calibratedRed: 205.0/255.0, green: 222.0/255.0, blue: 244.0/255.0, alpha: 1.0)

        var backgroundColor: NSColor { return blueColor }
        var borderColor: NSColor { return blueColor.darkerColor() }
        var titleColor: NSColor { return NSColor(calibratedRed: 85.0/255.0, green: 102.0/255.0, blue: 124.0/255.0, alpha: 1.0) }
        var titleFont: NSFont { return NSFont.boldSystemFont(ofSize: 13) }
    }

    fileprivate struct UnselectableTabButtonTheme: KPCTabsControl.TabButtonTheme {
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor { return base.backgroundColor }
        var borderColor: NSColor { return base.borderColor }
        var titleColor: NSColor { return NSColor.lightGray }
        var titleFont: NSFont { return base.titleFont }
    }
    
    fileprivate struct DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {
        var backgroundColor: NSColor { return DefaultTheme.sharedBackgroundColor }
        var borderColor: NSColor { return DefaultTheme.sharedBorderColor }
    }
}

extension NSColor {
    func darkerColor() -> NSColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return NSColor(calibratedHue: h, saturation: s, brightness: max(b - 0.2, 0.0), alpha: a)
    }
}
