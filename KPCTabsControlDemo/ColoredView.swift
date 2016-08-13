//
//  ColoredView.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 13/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Cocoa

@IBDesignable public class ColoredView: NSView {

    @IBInspectable public var borderColor: NSColor?
    @IBInspectable public var backgroundColor: NSColor? = NSColor.blueColor()

    override public func drawRect(dirtyRect: NSRect) {

        super.drawRect(dirtyRect)

        fillBackground(dirtyRect)
        drawTopLine(dirtyRect)
    }

    private func fillBackground(dirtyRect: NSRect) {

        guard let backgroundColor = self.backgroundColor else { return }

        backgroundColor.setFill()
        NSRectFill(dirtyRect)
    }

    private func drawTopLine(dirtyRect: NSRect) {

        guard let borderColor = self.borderColor else { return }

        let line = NSBezierPath()
        line.moveToPoint(NSMakePoint(0, dirtyRect.height))
        line.lineToPoint(NSMakePoint(dirtyRect.width, dirtyRect.height))
        line.lineWidth = 1
        borderColor.setStroke()
        line.stroke()
    }
}
