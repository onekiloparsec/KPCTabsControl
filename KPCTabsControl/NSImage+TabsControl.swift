//
//  NSImage+KPCTabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

extension NSImage {
    internal func imageWithTint(_ tint: NSColor) -> NSImage {
        var imageRect = NSRect.zero
        imageRect.size = self.size

        let highlightImage = NSImage(size: imageRect.size)

        highlightImage.lockFocus()

        self.draw(in: imageRect, from: NSRect.zero, operation: .sourceOver, fraction: 1.0)

        tint.set()
        imageRect.fill(using: .sourceAtop)

        highlightImage.unlockFocus()

        return highlightImage
    }
}
