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
    
    static func fromIndex(idx: Int, totalCount: Int) -> TabPosition {
        switch idx {
        case 0: return .first
        case totalCount-1: return .last
        default: return .middle
        }
    }
}

public enum TabWidth {
    case Full
    case Flexible(min: CGFloat, max: CGFloat)
}

func ==(t1: TabWidth, t2: TabWidth) -> Bool {
    return String(t1) == String(t2)
}

public enum TabSelectionState {
    case Normal
    case Selected
    case Unselectable
}


/**
 *  Border mask option set, used in tab buttons and the tabs control itself.
 */
public struct BorderMask: OptionSetType {
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
