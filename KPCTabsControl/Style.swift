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

/**
 *  The Style protocol defines all the necessary things to let KPCTabsControl draw itself with tabs.
 */
public protocol Style {
    // Tab Buttons
    var tabButtonWidth: TabWidth { get }
    func tabButtonOffset(position: TabPosition) -> Offset
    func tabButtonBorderMask(_ position: TabPosition) -> BorderMask?
    
    // Tab Button Titles
    func iconFrames(tabRect rect: NSRect) -> IconFrames
    func titleRect(title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect
    func titleEditorSettings() -> TitleEditorSettings
    func attributedTitle(content: String, selectionState: TabSelectionState) -> NSAttributedString

    // Tabs Control
    var tabsControlRecommendedHeight: CGFloat { get }
    func tabsControlBorderMask() -> BorderMask?
    
    // Drawing
    func drawTabButtonBezel(frame: NSRect, position: TabPosition, isSelected: Bool)
    func drawTabsControlBezel(frame: NSRect)
}

/**
 *  The default Style protocol doesn't necessary have a theme associated with it, for custom styles.
 *  However, provided styles (Numbers.app-like, Safari and Chrome) have an associated theme.
 */
public protocol ThemedStyle : Style {
    var theme: Theme { get }
}
