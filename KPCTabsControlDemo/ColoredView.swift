//
//  ColoredView.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 13/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

@IBDesignable open class ColoredView: NSView {

    @IBInspectable open var borderColor: NSColor?
    @IBInspectable open var backgroundColor: NSColor? = NSColor.blue

    override open func draw(_ dirtyRect: NSRect) {

        super.draw(dirtyRect)

        fillBackground(dirtyRect)
        drawTopLine(dirtyRect)
    }

    fileprivate func fillBackground(_ dirtyRect: NSRect) {

        guard let backgroundColor = self.backgroundColor else { return }

        backgroundColor.setFill()
        dirtyRect.fill()
    }

    fileprivate func drawTopLine(_ dirtyRect: NSRect) {

        guard let borderColor = self.borderColor else { return }

        let line = NSBezierPath()
        line.move(to: NSMakePoint(0, dirtyRect.height))
        line.line(to: NSMakePoint(dirtyRect.width, dirtyRect.height))
        line.lineWidth = 1
        borderColor.setStroke()
        line.stroke()
    }
}
