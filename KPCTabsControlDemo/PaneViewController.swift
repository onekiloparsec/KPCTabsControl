//
//  ViewController.swift
//  KPCTabsControlDemo
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa
import KPCTabsControl

class PaneViewController: NSViewController, TabsControlDataSource, TabsControlDelegate {

    @IBOutlet weak var tabsBar: TabsControl?
    @IBOutlet weak var useFullWidthTabsCheckButton: NSButton?
    @IBOutlet weak var tabWidthsLabel: NSTextField?
    
    var titles: Array<String> = []
    var icons: [String: NSImage] = [:]
    var menus: [String: NSMenu] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabsBar?.dataSource = self
        self.tabsBar?.delegate = self
        
        let labelString = NSString(format:"min %.0f < %.0f < %.0f max", self.tabsBar!.minTabWidth, self.tabsBar!.currentTabWidth(), self.tabsBar!.maxTabWidth)

        self.tabWidthsLabel?.stringValue = labelString as String
        
        self.tabsBar!.preferFullWidthTabs = self.useFullWidthTabsCheckButton!.state == NSOnState
        self.tabsBar!.reloadTabs()
    }

    @IBAction func toggleFullWidthTabs(sender: AnyObject) {
        self.tabsBar!.preferFullWidthTabs = self.useFullWidthTabsCheckButton!.state == NSOnState
    }
    
    override func mouseDown(theEvent: NSEvent) {
    
        super.mouseDown(theEvent)
    
        let sendNotification = (self.tabsBar?.highlighted == false)
//        self.tabsBar?.highlight(true)
        
        if (sendNotification) {
    NSNotificationCenter.defaultCenter().postNotificationName("PaneSelectionDidChangeNotification", object: self)
        }
    }
    
    func updateUponPaneSelectionDidChange(notif: NSNotification) {
//        if notif.object != self {
//            self.tabsBar?.highlight(false)
//        }
    }
    
    func updateLabelsUponReframe(notif: NSNotification) {
    
        let labelString = NSString(format:"min %.0f < %.0f < %.0f max", self.tabsBar!.minTabWidth, self.tabsBar!.currentTabWidth(), self.tabsBar!.maxTabWidth)
    
        self.tabWidthsLabel?.stringValue = labelString as String
    }

    // MARK: TabsControlDataSource
    
    func tabsControlNumberOfTabs(control: TabsControl) -> Int {
        return self.titles.count
    }
    
    func tabsControl(control: TabsControl, itemAtIndex index: Int) -> AnyObject {
        return self.titles[index]
    }
    
    func tabsControl(control: TabsControl, titleForItem item: AnyObject) -> String {
        let index = self.titles.indexOf(item as! String)!
        return (index == NSNotFound) ? "?" : self.titles[index];

    }
    
    // MARK: TabsControlDataSource : Optionals
    
    func tabsControl(control: TabsControl, menuForItem item: AnyObject) -> NSMenu? {
        return self.menus[item as! String]
    }
    
    func tabsControl(control: TabsControl, iconForItem item: AnyObject) -> NSImage? {
        let titleItem = item as! String
        
        if self.title == "pane1" {
            if titleItem == self.titles[0] {
                return NSImage(named:"Star")
            }
            else if titleItem == self.titles[1] {
                return NSImage(named:"Oval")
            }
        }
        else {
            if titleItem == self.titles[0] {
                return NSImage(named:"Star")
            }
            else if titleItem == self.titles[1] {
                return NSImage(named:"Triangle")
            }
            else if titleItem == self.titles[2] {
                return NSImage(named:"Spiral")
            }
            else if titleItem == self.titles[3] {
                return NSImage(named:"Polygon")
            }
        }
        
        return nil
    }

    // MARK: TabsControlDelegate
    
    func tabsControl(control: TabsControl, canReorderItem item: AnyObject) -> Bool {
        return true
    }
    
    func tabsControl(control: TabsControl, didReorderItems items: [AnyObject]) {
        self.titles = items as! [String]
    }
    
    func tabsControl(control: TabsControl, canEditTitleOfItem: AnyObject) -> Bool {
        return true
    }
    
    func tabsControl(control: TabsControl, setTitle newTitle: String, forItem item: AnyObject) {
        let index = self.titles.indexOf(item as! String)!
        self.titles[index] = newTitle
    }
}

