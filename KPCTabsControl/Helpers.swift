//
//  Helpers.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 03/09/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

public typealias Offset = NSPoint

public extension Offset {
    
    public init(x: CGFloat) {
        self.x = x
        self.y = 0
    }
    
    public init(y: CGFloat) {
        self.x = 0
        self.y = y
    }
}

/**
 Addition operator to NSPoints and Offsets.
 
 - parameter lhs: lef-hand side point
 - parameter rhs: right-hand side offset to be added to the point.
 
 - returns: A new and offset NSPoint.
 */
public func +(lhs: NSPoint, rhs: Offset) -> NSPoint {
    return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
