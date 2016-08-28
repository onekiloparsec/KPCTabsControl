//
//  ViewController.swift
//  KPCTabsControlDemo
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa
import KPCTabsControl

// We need a class (rather than a struct or a tuple – which would be nice) because TabsControlDelegate has
// @optional methods. To have such optionaling, we need to mark the protocol as @objc. With such marking,
// we can't have pure-Swift 'Any' return object or argument. Buh...

class Item {
    var title: String = ""
    var icon: NSImage?
    var menu: NSMenu?
    var altIcon: NSImage?
    
    init(title: String, icon: NSImage?, menu: NSMenu?, altIcon: NSImage?) {
        self.title = title
        self.icon = icon
        self.menu = menu
        self.altIcon = altIcon
    }
}

extension Item: Equatable { }

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.title == rhs.title
}

class PaneViewController: NSViewController, TabsControlDataSource, TabsControlDelegate {

    @IBOutlet weak var tabsBar: TabsControl?
    @IBOutlet weak var useFullWidthTabsCheckButton: NSButton?
    @IBOutlet weak var tabWidthsLabel: NSTextField?

    var items: Array<Item> = []
    override var title: String? {
        didSet { self.tabWidthsLabel?.stringValue = self.title! }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabsBar?.dataSource = self
        self.tabsBar?.delegate = self
        self.tabsBar!.reloadTabs()
    }
        
    // MARK: TabsControlDataSource
    
    func tabsControlNumberOfTabs(control: TabsControl) -> Int {
        return self.items.count
    }
    
    func tabsControl(control: TabsControl, itemAtIndex index: Int) -> AnyObject {
        return self.items[index]
    }
    
    func tabsControl(control: TabsControl, titleForItem item: AnyObject) -> String {
        return (item as! Item).title
    }
    
    // MARK: TabsControlDataSource : Optionals
    
    func tabsControl(control: TabsControl, menuForItem item: AnyObject) -> NSMenu? {
        return (item as! Item).menu
    }
    
    func tabsControl(control: TabsControl, iconForItem item: AnyObject) -> NSImage? {
        return (item as! Item).icon
    }
    
    func tabsControl(control: TabsControl, titleAlternativeIconForItem item: AnyObject) -> NSImage? {
        return (item as! Item).altIcon
    }

    // MARK: TabsControlDelegate
    
    func tabsControl(control: TabsControl, canReorderItem item: AnyObject) -> Bool {
        return true
    }
    
    func tabsControl(control: TabsControl, didReorderItems items: [AnyObject]) {
        self.items = items.map { $0 as! Item }
    }
    
    func tabsControl(control: TabsControl, canEditTitleOfItem: AnyObject) -> Bool {
        return true
    }
    
    func tabsControl(control: TabsControl, setTitle newTitle: String, forItem item: AnyObject) {
        let typedItem = item as! Item
        let titles = self.items.map { $0.title }
        let index = titles.indexOf(typedItem.title)!

        let newItem = Item(title: newTitle, icon: typedItem.icon, menu: typedItem.menu, altIcon: typedItem.altIcon)
        let range = index..<index+1
        self.items.replaceRange(range, with: [newItem])
    }

    func tabsControl(control: TabsControl, canSelectItem item: AnyObject) -> Bool {

        return (item as! Item) != self.items.first
    }
}

