//
//  MessageInterceptor.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

class MessageInterceptor : NSObject {
    var receiver: NSObject?;
    var middleMan: NSObject?;
    
    override func forwardingTargetForSelector(aSelector: Selector) -> AnyObject? {
        if self.middleMan?.respondsToSelector(aSelector) == true { return self.middleMan }
        if self.receiver?.respondsToSelector(aSelector) == true { return self.receiver }
        return super.forwardingTargetForSelector(aSelector)
    }
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        if self.middleMan?.respondsToSelector(aSelector) == true { return true }
        if self.receiver?.respondsToSelector(aSelector) == true { return true }
        return super.respondsToSelector(aSelector)
    }    
}
