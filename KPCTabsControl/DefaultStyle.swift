//
//  DefaultStyle.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public enum TitleDefaults {
    static let alignment = NSTextAlignment.center
    static let lineBreakMode = NSLineBreakMode.byTruncatingMiddle
}

// MARK: -

public enum BorderDrawing {
    case empty
    case draw(borderRects: [NSRect], rectCount: Int)
    
    static func fromMask(_ sourceRect: NSRect, borderMask: BorderMask?) -> BorderDrawing {
        
        guard let mask = borderMask else { return .empty }

        var outputCount: Int = 0
        var remainderRect = NSZeroRect
        var borderRects: [NSRect] = [NSZeroRect, NSZeroRect, NSZeroRect, NSZeroRect]
        
        if mask.contains(.top) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .minY)
            outputCount += 1
        }
        if mask.contains(.left) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .minX)
            outputCount += 1
        }
        if mask.contains(.right) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .maxX)
            outputCount += 1
        }
        if mask.contains(.bottom) {
            NSDivideRect(sourceRect, &borderRects[outputCount], &remainderRect, 0.5, .maxY)
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
@objc public class DefaultStyle: ThemedStyle {
    public init() {
        super.init(DefaultTheme())
        self.tabButtonWidth = .flexible
        self.tabButtonFlexibleMaxWidth = 50
        self.tabButtonFlexibleMinWidth = 150
        self.tabsControlRecommendedHeight = 24
    }
    
    public init(tabButtonWidth: TabWidth = .full) {
        super.init(DefaultTheme())
        self.tabButtonWidth = tabButtonWidth
        self.tabButtonFlexibleMaxWidth = 50
        self.tabButtonFlexibleMinWidth = 150
        self.tabsControlRecommendedHeight = 24
    }
}

