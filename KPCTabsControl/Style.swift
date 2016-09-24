//
//  Style.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

@objc public class IconFrames: NSObject {
    init(_ iconFrame: NSRect, alternativeTitleIconFrame: NSRect)
    {
        self.iconFrame = iconFrame
        self.alternativeTitleIconFrame = alternativeTitleIconFrame
    }
    
    var iconFrame: NSRect
    var alternativeTitleIconFrame: NSRect
}


@objc public class TitleEditorSettings: NSObject {
    init(_ textColor: NSColor, font: NSFont, alignment: NSTextAlignment)
    {
        self.textColor = textColor
        self.font = font
        self.alignment = alignment
    }
    
    var textColor: NSColor
    var font: NSFont
    var alignment: NSTextAlignment
}

/**
 *  The Style protocol defines all the necessary things to let KPCTabsControl draw itself with tabs.
 */
@objc public protocol Style {
    // Tab Buttons
    var tabButtonWidth: TabWidth { get }
    var tabButtonFlexibleMinWidth: CGFloat { get }
    var tabButtonFlexibleMaxWidth: CGFloat { get }
    func tabButtonOffset(position: TabPosition) -> Offset
    func tabButtonBorderMask(_ position: TabPosition) -> BorderMask
    
    // Tab Button Titles
    func iconFrames(tabRect rect: NSRect) -> IconFrames
    func titleRect(title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect
    func titleEditorSettings() -> TitleEditorSettings
    func attributedTitle(content: String, selectionState: TabSelectionState) -> NSAttributedString

    // Tabs Control
    var tabsControlRecommendedHeight: CGFloat { get }
    func tabsControlBorderMask() -> BorderMask
    
    // Drawing
    func drawTabButtonBezel(frame: NSRect, position: TabPosition, isSelected: Bool)
    func drawTabsControlBezel(frame: NSRect)
}

/**
 *  The default Style protocol doesn't necessary have a theme associated with it, for custom styles.
 *  However, provided styles (Numbers.app-like, Safari and Chrome) have an associated theme.
 */

@objc public class ThemedStyle : NSObject, Style {
    public var theme: Theme
    
    public var tabsControlRecommendedHeight: CGFloat
    
    public var tabButtonFlexibleMaxWidth: CGFloat
    
    public var tabButtonFlexibleMinWidth: CGFloat
    
    public var tabButtonWidth: TabWidth
    
    init(_ theme: Theme) {
        self.theme = theme
        tabsControlRecommendedHeight = 0
        tabButtonFlexibleMaxWidth = 0
        tabButtonFlexibleMinWidth = 0
        tabButtonWidth = .full
    }
    // MARK: - Tab Buttons
    
    public func tabButtonOffset(position: TabPosition) -> Offset {
        return NSPoint()
    }
    
    public func tabButtonBorderMask(_ position: TabPosition) -> BorderMask {
        return BorderMask.bottom.union(BorderMask.top).union(BorderMask.left).union(BorderMask.right)
    }
    
    // MARK: - Tab Button Titles
    
    public func iconFrames(tabRect rect: NSRect) -> IconFrames {
        
        let verticalPadding: CGFloat = 4.0
        let paddedHeight = rect.height - 2*verticalPadding
        let x = rect.width / 2.0 - paddedHeight / 2.0
        
        return IconFrames(NSMakeRect(10.0, verticalPadding, paddedHeight, paddedHeight),
                          alternativeTitleIconFrame: NSMakeRect(x, verticalPadding, paddedHeight, paddedHeight))
    }
    
    public func titleRect(title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect {
        
        let titleSize = title.size()
        let fullWidthRect = NSRect(x: NSMinX(rect),
                                   y: NSMidY(rect) - titleSize.height/2.0 - 0.5,
                                   width: NSWidth(rect),
                                   height: titleSize.height)
        
        return self.paddedRectForIcon(fullWidthRect, showingIcon: showingIcon)
    }
    
    fileprivate func paddedRectForIcon(_ rect: NSRect, showingIcon: Bool) -> NSRect {
        
        guard showingIcon else {
            return rect
        }
        
        let iconRect = self.iconFrames(tabRect: rect).iconFrame
        let pad = NSMaxX(iconRect)+titleMargin
        return rect.offsetBy(dx: pad, dy: 0.0).shrinkBy(dx: pad, dy: 0.0)
    }
    
    public func titleEditorSettings() -> TitleEditorSettings {
        return TitleEditorSettings(NSColor(calibratedWhite: 1.0/6, alpha: 1.0),
                                   font: self.theme.tabButtonTheme.titleFont,
                                   alignment: TitleDefaults.alignment)
    }
    
    public func attributedTitle(content: String, selectionState: TabSelectionState) -> NSAttributedString {
        
        let activeTheme = self.theme.tabButtonTheme(fromSelectionState: selectionState)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = TitleDefaults.alignment
        paragraphStyle.lineBreakMode = TitleDefaults.lineBreakMode
        
        let attributes = [NSForegroundColorAttributeName : activeTheme.titleColor,
                          NSFontAttributeName : activeTheme.titleFont,
                          NSParagraphStyleAttributeName : paragraphStyle]
        
        return NSAttributedString(string: content, attributes: attributes)
    }
    
    // MARK: - Tabs Control
    
    public func tabsControlBorderMask() -> BorderMask {
        return BorderMask.top.union(BorderMask.bottom)
    }
    
    // MARK: - Drawing
    
    public func drawTabsControlBezel(frame: NSRect) {
        self.theme.tabsControlTheme.backgroundColor.setFill()
        NSRectFill(frame)
        
        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: self.tabsControlBorderMask())
        self.drawBorder(borderDrawing, color: self.theme.tabsControlTheme.borderColor)
    }
    
    public func drawTabButtonBezel(frame: NSRect, position: TabPosition, isSelected: Bool) {
        
        let activeTheme = isSelected ? self.theme.selectedTabButtonTheme : self.theme.tabButtonTheme
        activeTheme.backgroundColor.setFill()
        NSRectFill(frame)
        
        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: self.tabButtonBorderMask(position))
        self.drawBorder(borderDrawing, color: activeTheme.borderColor)
    }
    
    fileprivate func drawBorder(_ border: BorderDrawing, color: NSColor) {
        
        guard case let .draw(borderRects: borderRects, rectCount: borderRectCount) = border
            else { return }
        
        color.setFill()
        color.setStroke()
        NSRectFillList(borderRects, borderRectCount)
    }
    
}
