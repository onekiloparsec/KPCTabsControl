//
//  NSButton+KPCTabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

extension NSButton {
    static func KPC_auxiliaryButton(withImageNamed imageName: String, target: AnyObject?, action: Selector) -> NSButton {
        
        let cell = TabButtonCell(textCell: "")
        let mask = NSEventMask.LeftMouseDownMask.union(NSEventMask.PeriodicMask)
        cell.sendActionOn(Int(mask.rawValue))
        
        let button = NSButton()
        button.cell = cell

        button.target = target
        button.action = action
        button.enabled = (target != nil && action != nil)
        button.continuous = true
        button.imagePosition = .ImageOnly
        button.image = NSImage(named: imageName)

        if let img = button.image {
            var r: CGRect = CGRectZero
            r.size = img.size
            r.size.width += 4.0
            button.frame = r
        }
        
        return button
    }    
}
