//
//  Style.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public struct FlexibleWidth {
    public let min: CGFloat
    public let max: CGFloat

    public init(min: CGFloat, max: CGFloat) {

        self.min = min
        self.max = max
    }
}

public typealias IconFrames = (iconFrame: NSRect, alternativeTitleIconFrame: NSRect)

public typealias Offset = NSPoint

public protocol Style {

    var tabWidth: FlexibleWidth { get }

    func tabButtonOffset(position position: TabButtonPosition) -> Offset
    func maxIconHeight(tabRect rect: NSRect, scale: CGFloat) -> CGFloat
    func iconFrames(tabRect rect: NSRect) -> IconFrames
    func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect
    func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString

    func drawTabBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool)
    func drawTabControlBezel(frame frame: NSRect)
}
