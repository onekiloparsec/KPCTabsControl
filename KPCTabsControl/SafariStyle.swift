//
//  SafariStyle.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 27/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

/**
 *  The Safari style. Use mostly the default implementation of Style.
 */
@objc public class SafariStyle: ThemedStyle {
    
    public init() {
        super.init(SafariTheme())
        self.tabButtonWidth = .full
        self.tabButtonFlexibleMinWidth = 0
        self.tabButtonFlexibleMaxWidth = 0
        self.tabsControlRecommendedHeight = 24.0
    }
    
    // There is no icons in Safari tabs. Here we force the absence of icon, even if some are provided.
    public override func iconFrames(tabRect rect: NSRect) -> IconFrames {
        return IconFrames(NSZeroRect, alternativeTitleIconFrame: NSZeroRect)
    }
    
    public func tabButtonBorderMask(_ position: TabPosition) -> BorderMask? {
        return [.bottom, .top, .right]
    }

    public func tabsControlBorderMask() -> BorderMask? {
        return BorderMask.bottom.union(BorderMask.top).union(BorderMask.left).union(BorderMask.right)
    }
}

