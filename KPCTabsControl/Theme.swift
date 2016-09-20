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
    var unselectableTabButtonTheme: TabButtonTheme { get }
    var tabsControlTheme: TabsControlTheme { get }
}

public extension Theme {
    /**
     Convenience function that select the theme corresponding to the right selection state.
     
     - parameter selectionState: The tab selection state
     
     - returns: The theme crresponding to the selection state.
     */
    public func tabButtonTheme(fromSelectionState selectionState : TabSelectionState) -> TabButtonTheme {
        switch selectionState {
        case .normal: return self.tabButtonTheme
        case .selected: return self.selectedTabButtonTheme
        case .unselectable: return self.unselectableTabButtonTheme
        }
    }
}
