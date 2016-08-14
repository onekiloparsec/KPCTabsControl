//
//  Style.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public struct FlexibleTabWidth {
    public let min: CGFloat
    public let max: CGFloat

    public init(min: CGFloat, max: CGFloat) {

        self.min = min
        self.max = max
    }
}

public typealias IconFrames = (iconFrame: NSRect, alternativeTitleIconFrame: NSRect)

public typealias Offset = NSPoint

extension Offset {

    init(x: CGFloat) {

        self.x = x
        self.y = 0
    }

    init(y: CGFloat) {

        self.x = 0
        self.y = y
    }
}

public protocol Style {

    var tabWidth: FlexibleTabWidth { get }

    func tabButtonOffset(position position: TabButtonPosition) -> Offset
    func maxIconHeight(tabRect rect: NSRect, scale: CGFloat) -> CGFloat
    func iconFrames(tabRect rect: NSRect) -> IconFrames
    func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect
    func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString

    func drawTabBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool)
    func drawTabControlBezel(frame frame: NSRect)
}
