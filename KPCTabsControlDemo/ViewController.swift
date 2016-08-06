//
//  ViewController.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Cocoa
import KPCTabsControl

class ViewController: NSViewController {
    @IBOutlet var topPane: PaneViewController?
    @IBOutlet var bottomPane: PaneViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topPane?.title = "pane1"
        self.topPane?.titles = ["Tab 1", "Tab 2", "Tab 3", "Tab 4", "Tab 5"]
//        self.topPane?.tabsBar?.highlight(true)
        
        let tab2Menu = NSMenu()
        tab2Menu.addItemWithTitle("Action 1", action: nil, keyEquivalent: "")
        tab2Menu.addItemWithTitle("Action 2", action: nil, keyEquivalent: "")
        self.topPane?.menus = ["Tab 2": tab2Menu]
        
        self.bottomPane?.title = "pane2"
        self.bottomPane?.titles = ["Tab a", "Tab b", "Tab c", "Tab d"]
        self.bottomPane?.tabsBar?.maxTabWidth = 130.0;
        self.bottomPane?.tabsBar?.minTabWidth = 100.0;
        
        self.topPane?.tabsBar?.reloadTabs()
        self.bottomPane?.tabsBar?.reloadTabs()
    }
}