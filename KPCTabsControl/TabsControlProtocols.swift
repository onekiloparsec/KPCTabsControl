//
//  TabsControlProtocols.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

@objc public protocol TabsControlDataSource: NSObjectProtocol {
    /**
     Returns the number of tabs
     
     - parameter control: The instance of the tabs control.
     
     - returns: A unsigned integer indicating the number of tabs to display.
     */
    func tabsControlNumberOfTabs(control: TabsControl) -> UInt
    
    /**
     Return the item for the tab at the given index, similarly to a "representedObject" in a cell view.
     
     - parameter control: The instance of the tabs control.
     - parameter index:   The index of the given item.
     
     - returns: An instance of an object representing the tab.
     */
    func tabsControl(control: TabsControl, itemAtIndex index: UInt) -> AnyObject
    
    /**
     Return the title for the tab of the given item
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns: A string to be used as title of the tab.
     */
    func tabsControl(control: TabsControl, titleForItem item: AnyObject) -> String
    
    /**
     If any, returns a menu for the tab, to be place to the right side of it. It is your responsability to fully
     configure its targets and actions before returning it to the tabs control.
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns: A menu instance.
     */
    optional func tabsControl(control: TabsControl, menuForItem item:AnyObject) -> NSMenu?
    
    /**
     If any, returns an icon for the tab, to be placed to the left side of it.
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns: An image instance for the icon.
     */
    optional func tabsControl(control: TabsControl, iconForItem item:AnyObject) -> NSImage?

    /**
     If the width of the tab is not large enough to draw the title, it is possible to provide here an alternate
     icon to replace it. The threshold at which one switch between the title and the icon is computed individually
     for each title.
     
     - parameter control: The instance of the tabs control.
     - parameter item:    The item representing the given tab.
     
     - returns:  An image instance for the alternate icon.
     */
    optional func tabsControl(control: TabsControl, titleAlternativeIconForItem item:AnyObject) -> NSImage?
}

@objc public protocol TabsControlDelegate: NSControlTextEditingDelegate {
    optional func tabsControl(control: TabsControl, canSelectItem item: AnyObject) -> Bool

    optional func tabsControlDidChangeSelection(control: TabsControl)

    optional func tabsControl(control: TabsControl, canReorderItem item: AnyObject) -> Bool

    optional func tabsControl(control: TabsControl, didReorderItems items: [AnyObject])

    optional func tabsControl(control: TabsControl, canEditTitleOfItem: AnyObject) -> Bool

    optional func tabsControl(control: TabsControl, setTitle newTitle: String, forItem item: AnyObject)

}