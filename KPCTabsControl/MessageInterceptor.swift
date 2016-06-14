//
//  MessageInterceptor.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

class MessageInterceptor : NSObject {
    var receiver: NSObject?;
    var middleMan: NSObject?;
    
    func forwardingTargetForSelector(aSelector: Selector) -> AnyObject? {
        if let self.middleMan?.respondsToSelector(aSelector) { return self.middleMan }
        if let self.receiver?.respondsToSelector(aSelector) { return self.receiver }
        return super.forwardingTargetForSelector(aSelector)
    }
    
    func respondsToSelector(aSelector: Selector) -> Bool {
        if let self.middleMan?.respondsToSelector(aSelector) { return true }
        if let self.receiver?.respondsToSelector(aSelector) { return true }
        return super.respondsToSelector(aSelector)
    }    
}