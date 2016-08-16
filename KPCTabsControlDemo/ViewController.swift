//
//  ViewController.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa
import KPCTabsControl

class ViewController: NSViewController {
    @IBOutlet var topPane: PaneViewController?
    @IBOutlet var bottomPane: PaneViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topPane?.title = "pane1"
        self.topPane?.tabsBar?.style = DefaultStyle()
        
        let tab2Menu = NSMenu()
        tab2Menu.addItemWithTitle("Action 1", action: nil, keyEquivalent: "")
        tab2Menu.addItemWithTitle("Action 2", action: nil, keyEquivalent: "")

        self.topPane?.items = [Item(title: "Tab 1", icon: NSImage(named: "Star"), menu: nil, altIcon: nil),
                               Item(title: "Tab 2", icon: NSImage(named: "Oval"), menu: tab2Menu, altIcon: nil),
                               Item(title: "Tab 3 Very Long Title", icon: nil, menu: nil, altIcon: NSImage(named: "Polygon")),
                               Item(title: "Tab 4", icon: nil, menu: nil, altIcon: nil),
                               Item(title: "Tab 5", icon: nil, menu: nil, altIcon: nil)]
                                    
        
        self.bottomPane?.title = "pane2"
        self.bottomPane?.tabsBar?.style = ChromeStyle()

        self.bottomPane?.items = [Item(title: "Tab a", icon: NSImage(named: "Star"), menu: nil, altIcon: nil),
                                  Item(title: "Tab b", icon: NSImage(named: "Triangle"), menu: nil, altIcon: nil),
                                  Item(title: "Tab c", icon: NSImage(named: "Spiral"), menu: nil, altIcon: nil),
                                  Item(title: "Tab d", icon: NSImage(named: "Polygon"), menu: nil, altIcon: nil)]
        
        (self.bottomPane?.view as? ColoredView)?.backgroundColor = (self.bottomPane?.tabsBar?.style as? Themed)?.theme.selectedTabButtonTheme.backgroundColor

        self.topPane?.tabsBar?.reloadTabs()
        self.bottomPane?.tabsBar?.reloadTabs()
    }
}

