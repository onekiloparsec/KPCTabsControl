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
        self.topPane?.titles = ["Tab 1", "Tab 2", "Tab 3", "Tab 4", "Tab 5"]
        self.topPane?.tabsBar?.style = ThemedStyle(theme: DefaultTheme(), tabWidth: FlexibleWidth(min: 150, max: 180))

        let tab2Menu = NSMenu()
        tab2Menu.addItemWithTitle("Action 1", action: nil, keyEquivalent: "")
        tab2Menu.addItemWithTitle("Action 2", action: nil, keyEquivalent: "")
        self.topPane?.menus = ["Tab 2": tab2Menu]
        
        self.bottomPane?.title = "pane2"
        self.bottomPane?.titles = ["Tab a", "Tab b", "Tab c", "Tab d"]
        self.bottomPane?.tabsBar?.style = ChromeStyle()

        self.topPane?.tabsBar?.reloadTabs()
        self.bottomPane?.tabsBar?.reloadTabs()
    }
}