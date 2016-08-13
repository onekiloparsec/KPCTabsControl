//
//  ChromeStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 13/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Cocoa

public struct ChromeStyle: Style {

    /// Exposes the color used by selected tabs to style the view below in a matching way.
    public static var panelBackgroundColor: NSColor {
        return Colors.tabBackgroundSelected
    }

    enum Colors {
        static let tabControlBackground = NSColor(calibratedWhite: 216/256.0, alpha: 1.0)

        static let border = NSColor(calibratedWhite: 152/256.0, alpha: 1.0)

        static let tabBackgroundUnselected = Colors.tabControlBackground
        static let tabBackgroundSelected = NSColor(calibratedWhite: 245/256.0, alpha: 1.0)

        static func tabBackground(isSelected: Bool) -> NSColor {

            if isSelected { return tabBackgroundSelected }

            return tabBackgroundUnselected
        }
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
        let xOffset = CGFloat(35)
        return rect
            .offsetBy(dx: xOffset, dy: 4)
            .shrinkBy(dx: xOffset, dy: 4)
    }

    public func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString {

        return NSAttributedString(string: content)
    }

    public func drawTabBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool) {

        let height: CGFloat = {
            let paddedHeight = frame.height * 0.7

            // Chrome tabs have lots of whitespace to the top; if that's 
            // too cramped, don't try to achieve that effect.
            guard paddedHeight > 30 else { return frame.height - 2 }

            return paddedHeight
        }()
        let xOffset = height / 2 // 45˚ angle
        let lowerLeft = frame.origin + Offset(x: 0, y: frame.height)
        let upperLeft = lowerLeft + Offset(x: xOffset, y: -height)
        let lowerRight = lowerLeft + Offset(x: frame.width, y: 0)
        let upperRight = lowerRight + Offset(x: -xOffset, y: -height)

        let path = NSBezierPath()
        path.moveToPoint(lowerLeft)
        path.lineToPoint(upperLeft)
        path.lineToPoint(upperRight)
        path.lineToPoint(lowerRight)
        path.lineWidth = 1

        Colors.tabBackground(isSelected).setFill()
        path.fill()

        Colors.border.setStroke()
        path.stroke()

        if !isSelected {
            drawBottomBorder(frame: frame)
        }
    }

    public func drawTabControlBezel(frame frame: NSRect) {
        Colors.tabControlBackground.setFill()
        NSRectFill(frame)

        drawBottomBorder(frame: frame)
    }

    private func drawBottomBorder(frame frame: NSRect) {
        let bottomBorder = NSRect(
            origin: frame.origin + Offset(x: 0, y: frame.height - 1),
            size: NSSize(width: frame.width, height: 1))
        Colors.border.setFill()
        NSRectFill(bottomBorder)
    }
}

typealias Offset = NSPoint

func +(lhs:     NSPoint, rhs: Offset) -> NSPoint {
    return NSPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
