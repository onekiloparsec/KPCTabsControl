//
//  NSButton+KPCTabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

internal extension NSButton {
    static internal func auxiliaryButton(withImageNamed imageName: String, target: AnyObject?, action: Selector?) -> NSButton {
        
        let cell = TabButtonCell(textCell: "")
        let mask = NSEvent.EventTypeMask.leftMouseDown.union(NSEvent.EventTypeMask.periodic)
        cell.sendAction(on: NSEvent.EventTypeMask(rawValue: UInt64(Int(mask.rawValue))))
        
        let button = NSButton()
        button.cell = cell

        button.target = target
        button.action = action
        button.isEnabled = (target != nil && action != nil)
        button.isContinuous = true
        button.imagePosition = .imageOnly
        button.image = NSImage(named: NSImage.Name(rawValue: imageName))

        if let img = button.image {
            var r: CGRect = CGRect.zero
            r.size = img.size
            r.size.width += 4.0
            button.frame = r
        }
        
        return button
    }    
}
