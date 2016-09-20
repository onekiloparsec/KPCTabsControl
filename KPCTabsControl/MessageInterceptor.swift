//
//  MessageInterceptor.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

internal class MessageInterceptor : NSObject {
    var receiver: NSObject?;
    var middleMan: NSObject?;
    
    override func forwardingTarget(for aSelector: Selector) -> Any? {
        if self.middleMan?.responds(to: aSelector) == true { return self.middleMan }
        if self.receiver?.responds(to: aSelector) == true { return self.receiver }
        return super.forwardingTarget(for: aSelector)
    }
    
    override func responds(to aSelector: Selector) -> Bool {
        if self.middleMan?.responds(to: aSelector) == true { return true }
        if self.receiver?.responds(to: aSelector) == true { return true }
        return super.responds(to: aSelector)
    }    
}
