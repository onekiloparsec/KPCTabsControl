//
//  NSButton+KPCTabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation
import AppKit

extension NSButton {
    static func KPC_auxiliaryButton(withImageNamed imageName: String, target: AnyObject?, action: #selector) -> NSButton {
        
        let button = NSButton()
        
        let cell: KPCTabButtonCell = KPCTabButtonCell()
//        cell.borderMask |= KPCBorderMaskBottom;
        button.cell = cell
//        [button setCell:cell];
//        [button.cell sendActionOn:NSLeftMouseDownMask|NSPeriodicMask];
//        
//        [button setTarget:target];
//        [button setAction:action];
//        [button setEnabled:action != NULL];
//        [button setContinuous:YES];
//        
//        [button setImagePosition:NSImageOnly];
//        [button setImage:[NSImage imageNamed:imageName]];
//        
//        CGRect r = CGRectZero;
//        r.size = button.image.size;
//        r.size.width += 4.0;
//        button.frame = r;
        
        return button
    }
}
