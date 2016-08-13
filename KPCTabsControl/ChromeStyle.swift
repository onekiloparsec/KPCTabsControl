//
//  ChromeStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 13/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Cocoa

public struct ChromeStyle: Style {

    enum Colors {
        static let tabBackground = NSColor(calibratedWhite: 245/256.0, alpha: 1.0)
        static let tabControlBackground = NSColor(calibratedWhite: 216/256.0, alpha: 1.0)

        static let border = NSColor(calibratedWhite: 152/256.0, alpha: 1.0)
    }

    public let tabWidth: FlexibleWidth = FlexibleWidth(min: 80, max: 180)

    public init() { }

    public func maxIconHeight(tabRect rect: NSRect, scale: CGFloat) -> CGFloat {

        let verticalPadding: CGFloat = 2.0
        let paddedHeight = CGRectGetHeight(rect) - 2 * verticalPadding

        return 1.2 * paddedHeight * scale
    }

    public func iconFrames(tabRect rect: NSRect) -> IconFrames {

        let verticalPadding: CGFloat = 2.0
        let paddedHeight = CGRectGetHeight(rect) - 2*verticalPadding
        let x = CGRectGetWidth(rect) / 2.0 - paddedHeight / 2.0

        return (
            NSMakeRect(10.0, verticalPadding, paddedHeight, paddedHeight),
            NSMakeRect(x, verticalPadding, paddedHeight, paddedHeight)
        )
    }

    public func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect {

        return rect
    }

    public func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString {

        return NSAttributedString(string: content)
    }

    public func drawTabBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool) {

        let path = NSBezierPath()
        let height = frame.height * 0.7
        let xOffset = height / 2
        let lowerLeft = frame.origin + Offset(x: 0, y: frame.height)
        let upperLeft = lowerLeft + Offset(x: xOffset, y: -height)
        let lowerRight = lowerLeft + Offset(x: frame.width, y: 0)
        let upperRight = lowerRight + Offset(x: -xOffset, y: -height)
        path.moveToPoint(lowerLeft)
        path.lineToPoint(upperLeft)
        path.lineToPoint(upperRight)
        path.lineToPoint(lowerRight)
        path.lineWidth = 1

        Colors.tabBackground.setFill()
        path.fill()

        Colors.border.setStroke()
        path.stroke()
    }

    public func drawTabControlBezel(frame frame: NSRect) {

        Colors.tabControlBackground.setFill()
        NSRectFill(frame)
    }
}

typealias Offset = NSPoint

func +(lhs:     NSPoint, rhs: Offset) -> NSPoint {
    return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
