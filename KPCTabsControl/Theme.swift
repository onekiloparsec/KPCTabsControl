//
//  Theme.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 13/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

/**
 *  The theme of a single Tab button
 */
public protocol TabButtonTheme {
    var backgroundColor: NSColor { get }
    var borderColor: NSColor { get }
    var titleColor: NSColor { get }
    var titleFont: NSFont { get }
}

/**
 *  The theme of the whole TabsControl bar
 */
public protocol TabsControlTheme {
    var backgroundColor: NSColor { get }
    var borderColor: NSColor { get }
}

/**
 *  The theme of a complete TabsControl
 */
public protocol Theme {
    var tabButtonTheme: TabButtonTheme { get }
    var selectedTabButtonTheme: TabButtonTheme { get }    
    var tabsControlTheme: TabsControlTheme { get }
}
