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

public typealias TitleEditorSettings = (textColor: NSColor, font: NSFont, alignment: NSTextAlignment)

public protocol Style {
    var tabButtonWidth: FlexibleTabWidth { get }
    func tabButtonOffset(position position: TabButtonPosition) -> Offset
    
    func iconFrames(tabRect rect: NSRect) -> IconFrames
    func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect
    func titleEditorSettings() -> TitleEditorSettings
    func attributedTitle(content content: String, isSelected: Bool) -> NSAttributedString

    func drawTabButtonBezel(frame frame: NSRect, position: TabButtonPosition, isSelected: Bool)
    func drawTabsControlBezel(frame frame: NSRect)

    var recommendedTabsControlHeight: CGFloat { get }
}

public protocol ThemedStyle : Style {
    var theme: Theme { get }
}
