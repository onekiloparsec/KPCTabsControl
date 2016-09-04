//
//  Style.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public typealias IconFrames = (iconFrame: NSRect, alternativeTitleIconFrame: NSRect)

public typealias TitleEditorSettings = (textColor: NSColor, font: NSFont, alignment: NSTextAlignment)

public protocol Style {
    // Tab Buttons
    var tabButtonWidth: TabWidth { get }
    func tabButtonOffset(position position: TabPosition) -> Offset
    func tabButtonBorderMask(position: TabPosition) -> BorderMask?
    
    // Tab Button Titles
    func iconFrames(tabRect rect: NSRect) -> IconFrames
    func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect
    func titleEditorSettings() -> TitleEditorSettings
    func attributedTitle(content content: String, selectionState: TabSelectionState) -> NSAttributedString

    // Tabs Control
    var tabsControlRecommendedHeight: CGFloat { get }
    func tabsControlBorderMask() -> BorderMask?
    
    // Drawing
    func drawTabButtonBezel(frame frame: NSRect, position: TabPosition, isSelected: Bool)
    func drawTabsControlBezel(frame frame: NSRect)
}

public protocol ThemedStyle : Style {
    var theme: Theme { get }
}
