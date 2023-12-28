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

        fillBackground()
        drawTopLine()
    }

    fileprivate func fillBackground() {

        guard let backgroundColor = self.backgroundColor else { return }

        backgroundColor.setFill()
        bounds.fill()
    }

    fileprivate func drawTopLine() {

        guard let borderColor = self.borderColor else { return }

        let line = NSBezierPath()
        line.move(to: NSPoint(x: 0, y: bounds.height))
        line.line(to: NSPoint(x: bounds.width, y: bounds.height))
        line.lineWidth = 1
        borderColor.setStroke()
        line.stroke()
    }
}
