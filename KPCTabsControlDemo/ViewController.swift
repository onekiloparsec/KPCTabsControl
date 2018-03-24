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
    @IBOutlet var paneDefault: PaneViewController?
    @IBOutlet var paneChrome: PaneViewController?
    @IBOutlet var paneSafari: PaneViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paneDefault?.title = "Default (~Numbers.app)"
        self.paneDefault?.tabsBar?.style = DefaultStyle()
        
        let tab2Menu = NSMenu()
        tab2Menu.addItem(withTitle: "Action 1: AddTabItem", action: #selector(ViewController.addTabItem), keyEquivalent: "")
        tab2Menu.addItem(withTitle: "Action 2: nil", action: nil, keyEquivalent: "")

        self.paneDefault?.items = [Item(title: "Default 1", icon: NSImage(named: NSImage.Name(rawValue: "Star")), menu: nil, altIcon: nil, selectable: false),
                                   Item(title: "Default 2", icon: NSImage(named: NSImage.Name(rawValue: "Oval")), menu: tab2Menu, altIcon: nil),
                                   Item(title: "Default 3 Long Title", icon: nil, menu: nil, altIcon: NSImage(named: NSImage.Name(rawValue: "ArrowTemplate"))),
                                   Item(title: "Default 4 Longish Title", icon: nil, menu: nil, altIcon: nil),
                                   Item(title: "Default 5", icon: nil, menu: nil, altIcon: nil)]

        self.paneDefault?.tabsBar?.reloadTabs()

        self.paneChrome?.title = "Chrome"
        self.paneChrome?.tabsBar?.style = ChromeStyle()

        self.paneChrome?.items = [Item(title: "Chrome 1", icon: NSImage(named: NSImage.Name(rawValue: "Star")), menu: nil, altIcon: nil, selectable: false),
                                  Item(title: "Chrome 2", icon: NSImage(named: NSImage.Name(rawValue: "Triangle")), menu: nil, altIcon: nil),
                                  Item(title: "Chrome 3", icon: NSImage(named: NSImage.Name(rawValue: "Spiral")), menu: nil, altIcon: nil),
                                  Item(title: "Chrome 4", icon: NSImage(named: NSImage.Name(rawValue: "Polygon")), menu: nil, altIcon: nil)]

        let style = self.paneChrome?.tabsBar?.style as! ThemedStyle
        (self.paneChrome?.view as? ColoredView)?.backgroundColor = style.theme.selectedTabButtonTheme.backgroundColor
        
        self.paneChrome?.tabsBar?.reloadTabs()
        self.paneChrome?.tabsBar?.selectItemAtIndex(3)

        self.paneSafari?.title = "Safari"
        self.paneSafari?.tabsBar?.style = SafariStyle()

        self.paneSafari?.items = [Item(title: "Safari 1", icon: NSImage(named: NSImage.Name(rawValue: "Star")), menu: nil, altIcon: nil),
                                  Item(title: "Safari 2", icon: NSImage(named: NSImage.Name(rawValue: "Triangle")), menu: nil, altIcon: nil),
                                  Item(title: "Safari 3", icon: NSImage(named: NSImage.Name(rawValue: "Spiral")), menu: nil, altIcon: nil)]

        self.paneSafari?.tabsBar?.reloadTabs()
        self.paneSafari?.tabsBar?.selectItemAtIndex(1)
    }
    
    @objc func addTabItem() {
        let title = "New Tab #\(paneDefault!.items.count + 1)"
        print("add tab item \(title)...")
        paneDefault?.items.append(Item(title: title, icon: nil, menu: nil, altIcon: nil))
        paneDefault?.tabsBar?.reloadTabs()
    }
}

