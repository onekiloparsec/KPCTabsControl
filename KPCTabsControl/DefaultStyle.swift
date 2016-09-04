//
//  DefaultStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public enum TitleDefaults {
    static let alignment = NSTextAlignment.Center
    static let lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
}

/// Default implementation of Themed Style

public extension ThemedStyle {
    
    // MARK: - Tab Buttons
    
    public func tabButtonOffset(position position: TabPosition) -> Offset {
        return NSPoint()
    }

    public func tabButtonBorderMask(position: TabPosition) -> BorderMask? {
        return BorderMask.all()
    }
    
    // MARK: - Tab Button Titles

    public func iconFrames(tabRect rect: NSRect) -> IconFrames {
        
        let verticalPadding: CGFloat = 2.0
        let paddedHeight = CGRectGetHeight(rect) - 2*verticalPadding
        let x = CGRectGetWidth(rect) / 2.0 - paddedHeight / 2.0
        
        return (NSMakeRect(10.0, verticalPadding, paddedHeight, paddedHeight),
                NSMakeRect(x, verticalPadding, paddedHeight, paddedHeight))
    }
        
    public func titleRect(title title: NSAttributedString, inBounds rect: NSRect, showingIcon: Bool) -> NSRect {
        
        let titleSize = title.size()
        let fullWidthRect = NSRect(x: NSMinX(rect),
                                   y: NSMidY(rect) - titleSize.height/2.0 - 0.5,
                                   width: NSWidth(rect),
                                   height: titleSize.height)
        
        return self.paddedRectForIcon(fullWidthRect, showingIcon: showingIcon)
    }
    
    private func paddedRectForIcon(rect: NSRect, showingIcon: Bool) -> NSRect {
        
        guard showingIcon else {
            return rect
        }
        
        let iconRect = self.iconFrames(tabRect: rect).iconFrame
        let pad = NSMaxX(iconRect)+titleMargin
        return rect.offsetBy(dx: pad, dy: 0.0).shrinkBy(dx: pad, dy: 0.0)
    }
    
    public func titleEditorSettings() -> TitleEditorSettings {
        return (textColor: NSColor(calibratedWhite: 1.0/6, alpha: 1.0),
                font: self.theme.tabButtonTheme.titleFont,
                alignment: TitleDefaults.alignment)
    }
    
    public func attributedTitle(content content: String, selectionState: TabSelectionState) -> NSAttributedString {
        
        let activeTheme = self.theme.tabButtonThemeFromSelectionState(selectionState)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = TitleDefaults.alignment
        paragraphStyle.lineBreakMode = TitleDefaults.lineBreakMode
        
        let attributes = [NSForegroundColorAttributeName : activeTheme.titleColor,
                          NSFontAttributeName : activeTheme.titleFont,
                          NSParagraphStyleAttributeName : paragraphStyle]
        
        return NSAttributedString(string: content, attributes: attributes)
    }

    // MARK: - Tabs Control
    
    public var recommendedTabsControlHeight: CGFloat {
        return 21.0
    }

    public func tabsControlBorderMask() -> BorderMask? {
        return BorderMask.top.union(BorderMask.bottom)
    }

    // MARK: - Drawing

    public func drawTabsControlBezel(frame frame: NSRect) {
        self.theme.tabsControlTheme.backgroundColor.setFill()
        NSRectFill(frame)
        
        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: self.tabsControlBorderMask())
        self.drawBorder(borderDrawing, color: self.theme.tabsControlTheme.borderColor)
    }
    
    public func drawTabButtonBezel(frame frame: NSRect, position: TabPosition, isSelected: Bool) {
        
        let activeTheme = isSelected ? self.theme.selectedTabButtonTheme : self.theme.tabButtonTheme
        activeTheme.backgroundColor.setFill()
        NSRectFill(frame)
        
        let borderDrawing = BorderDrawing.fromMask(frame, borderMask: self.tabButtonBorderMask(position))
        self.drawBorder(borderDrawing, color: activeTheme.borderColor)
    }

    private func drawBorder(border: BorderDrawing, color: NSColor) {
        
        guard case let .draw(borderRects: borderRects, rectCount: borderRectCount) = border
            else { return }
        
        color.setFill()
        color.setStroke()
        NSRectFillList(borderRects, borderRectCount)
    }
}

// MARK: -

private enum BorderDrawing {
    case empty
    case draw(borderRects: [NSRect], rectCount: Int)
    
    private static func fromMask(sourceRect: NSRect, borderMask: BorderMask?) -> BorderDrawing {
        
        guard let mask = borderMask else { return .empty }

        var outputCount: Int = 0
        var remainderRect = NSZeroRect
        var borderRects: [NSRect] = [NSZeroRect, NSZeroRect, NSZeroRect, NSZeroRect]
        
        if mask.contains(.top) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .MinY)
            outputCount += 1
        }
        if mask.contains(.left) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .MinX)
            outputCount += 1
        }
        if mask.contains(.right) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .MaxX)
            outputCount += 1
        }
        if mask.contains(.bottom) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .MaxY)
            outputCount += 1
        }
        
        guard outputCount > 0 else { return .empty }
        
        return .draw(borderRects: borderRects, rectCount: outputCount)
    }
}

// MARK: - 

/**
 *  The default TabsControl style. Used with the DefaultTheme, it provides an experience similar to Apple's Numbers.app.
 */
public struct DefaultStyle: ThemedStyle {
    public let theme: Theme
    public let tabButtonWidth: TabWidth

    public init(theme: Theme = DefaultTheme(), tabButtonWidth: TabWidth = .Flexible(min: 50, max: 150)) {
        self.theme = theme
        self.tabButtonWidth = tabButtonWidth
    }
}

