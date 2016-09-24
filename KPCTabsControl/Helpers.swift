//
//  Helpers.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 03/09/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

/// Offset is a simple NSPoint typealias to increase readability.
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
 Addition operator for NSPoints and Offsets.
 
 - parameter lhs: lef-hand side point
 - parameter rhs: right-hand side offset to be added to the point.
 
 - returns: A new and offset NSPoint.
 */
public func +(lhs: NSPoint, rhs: Offset) -> NSPoint {
    return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

/**
 A convenience extension to easily shrink a NSRect
 */
public extension NSRect {
    
    /// Change width and height by `-dx` and `-dy`.
    
    func shrinkBy(dx: CGFloat, dy: CGFloat) -> NSRect {
        var result = self
        result.size = CGSize(width: result.size.width - dx, height: result.size.height - dy)
        return result
    }
}

/**
 Convenience function to easily compare tab widths.
 
 - parameter t1: The first tab width
 - parameter t2: The second tab width
 
 - returns: A boolean to indicate whether the tab widths are identical or not.
 */
func ==(t1: TabWidth, t2: TabWidth) -> Bool {
    return String(describing: t1) == String(describing: t2)
}


/// Helper functions to let compare optionals

func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
