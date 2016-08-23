//
//  Style.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public enum TabButtonWidth {
    case Full
    case Flexible(min: CGFloat, max: CGFloat)
}

func ==(t1: TabButtonWidth, t2: TabButtonWidth) -> Bool {
    return String(t1) == String(t2)
}

public typealias IconFrames = (iconFrame: NSRect, alternativeTitleIconFrame: NSRect)

public typealias TitleEditorSettings = (textColor: NSColor, font: NSFont, alignment: NSTextAlignment)

public protocol Style {
    var tabButtonWidth: TabButtonWidth { get }
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
