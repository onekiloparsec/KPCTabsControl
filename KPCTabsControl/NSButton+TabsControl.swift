//
//  NSButton+KPCTabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import AppKit

extension NSButton {
    static func KPC_auxiliaryButton(withImageNamed imageName: String, target: AnyObject?, action: Selector) -> NSButton {
        
        let button = NSButton()
        
        let cell = TabButtonCell(textCell: "")
//        cell.borderMask |= KPCBorderMaskBottom.rawValue
        button.cell = cell
//        button.cell?.sendActionOn(<#T##mask: Int##Int#>)
//        [button.cell sendActionOn:NSLeftMouseDownMask|NSPeriodicMask];
//        
        button.target = target
//        [button setAction:action];
//        [button setEnabled:action != NULL];
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
