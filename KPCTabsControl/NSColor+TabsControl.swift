//
//  NSColor+KPCTabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import AppKit

public extension NSColor {
    /**
     *  The color of the border of the tabs control.
     */
    static func KPC_defaultControlBorderColor() -> NSColor {
        return NSColor.lightGrayColor()
    }
    
    /**
     *  The color of the tab control background in normal state (unhighlighted);
     */
    static func KPC_defaultControlBackgroundColor() -> NSColor {
        return NSColor(calibratedWhite: 0.95, alpha: 1.0)
    }
    
    /**
     *  The color of the tab control background in highlighted state;
     */
    static func KPC_defaultControlHighlightedBackgroundColor() -> NSColor {
        return NSColor(calibratedWhite: 0.85, alpha: 1.0)
    }
    
    
    
    /**
     *  The color of the border of an individual tab button.
     */
    static func KPC_defaultTabBorderColor() -> NSColor {
        return NSColor.KPC_defaultControlBorderColor()
    }
    
    /**
     *  The color of the title of an individual tab button, when the button is not selected.
     */
    static func KPC_defaultTabTitleColor() -> NSColor {
        return NSColor.darkGrayColor()
    }
    
    /**
     *  The color of the background of an individual tab button, when the button is not selected,
     *  and the control is in normal state (unhighlighted)
     */
    static func KPC_defaultTabBackgroundColor() -> NSColor {
        return NSColor.KPC_defaultControlBackgroundColor()
    }
    
    /**
     *  The color of the background of an individual tab button, when the button is not selected,
     *  and the control is in highlighted state
     */
    static func KPC_defaultTabHighlightedBackgroundColor() -> NSColor {
        return NSColor.KPC_defaultControlHighlightedBackgroundColor()
    }
    
    
    
    // There is no customization of the colors for the selected tab following the highlight state of the control.
    // It is done automatically.
    
    
    /**
     *  The color of the border of an individual tab when it is selected.
     */
    static func KPC_defaultTabSelectedBorderColor() -> NSColor {
        return NSColor(calibratedRed: 185.0/255.0, green: 202.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    }
    
    /**
     *  The color of the title an individual tab when it is selected.
     */
    static func KPC_defaultTabSelectedTitleColor() -> NSColor {
        return NSColor(calibratedRed: 185.0/255.0, green: 202.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    }
    
    /**
     *  The color of the background an individual tab when it is selected.
     */
    static func KPC_defaultTabSelectedBackgroundColor() -> NSColor {
        return NSColor(calibratedRed: 205.0/255.0, green: 222.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    
    
}