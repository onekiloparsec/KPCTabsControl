//
//  TabsControlProtocols.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

@objc public protocol TabsControlDataSource: NSObjectProtocol {
    
}

@objc public protocol TabsControlDelegate: NSControlTextEditingDelegate {
    optional func tabsControl(control: TabsControl, canSelectItem: AnyObject)
    
}