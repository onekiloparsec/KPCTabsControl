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
public enum TabPosition {
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
public enum TabWidth {
    case full
    case flexible(min: CGFloat, max: CGFloat)
}

/**
 The tab selection state.
 
 - Normal:       The tab is not selected.
 - Selected:     The tab is selected.
 - Unselectable: The tab is not selectable.
 */
public enum TabSelectionState {
    case normal
    case selected
    case unselectable
}


/**
 *  Border mask option set, used in tab buttons and the tabs control itself.
 */
public struct BorderMask: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static func all() -> BorderMask {
        return BorderMask.top.union(BorderMask.left).union(BorderMask.right).union(BorderMask.bottom)
    }
    
    public static let top = BorderMask(rawValue: 1 << 0)
    public static let left = BorderMask(rawValue: 1 << 1)
    public static let right = BorderMask(rawValue: 1 << 2)
    public static let bottom = BorderMask(rawValue: 1 << 3)
}
