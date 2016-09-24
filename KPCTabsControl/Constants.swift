//
//  Constants.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

/// The name of the notification upon the selection of a new tab.
public let TabsControlSelectionDidChangeNotification = "TabsControlSelectionDidChangeNotification"

/**
 The position of a tab button inside the control. Used in the Style.
 
 - first:  The most left-hand tab button.
 - middle: Any middle tab button between first and last.
 - last:   The most right-hand tab button
 */
@objc public enum TabPosition: Int {
    case first
    case middle
    case last
    
    /**
     Convenience function to get TabPosition from a given index compared to a given total count.
     
     - parameter idx:        The index for which one wants the position
     - parameter totalCount: The total count of tabs
     
     - returns: The tab position
     */
    static func fromIndex(_ idx: Int, totalCount: Int) -> TabPosition {
        switch idx {
        case 0: return .first
        case totalCount-1: return .last
        default: return .middle
        }
    }
}

/**
 The tab width modes.
 
 - Full:     The tab widths will be equally distributed accross the tabs control width.
 - Flexible: The tab widths will be adjusted between min and max, depending on the tabs control width.
 */
@objc public enum TabWidth: Int {
    case full
    case flexible
}

/**
 The tab selection state.
 
 - Normal:       The tab is not selected.
 - Selected:     The tab is selected.
 - Unselectable: The tab is not selectable.
 */
@objc public enum TabSelectionState: Int {
    case normal
    case selected
    case unselectable
}
