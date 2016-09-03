//
//  SafariStyle.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 27/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

public struct SafariStyle: ThemedStyle {
    public let theme: Theme
    public let tabButtonWidth: TabButtonWidth
    public let recommendedTabsControlHeight: CGFloat = 24.0
    
    public init(theme: Theme = SafariTheme(), tabButtonWidth: TabButtonWidth = .Full) {
        self.theme = theme
        self.tabButtonWidth = tabButtonWidth
    }
    
    // There is no icons in Safari tabs. Here we force the absence of icon, even if some are provided.
    public func iconFrames(tabRect rect: NSRect) -> IconFrames {
        return (NSZeroRect, NSZeroRect)
    }
    
    public func tabsControlBorderMask() -> BorderMask? {
        return nil
    }
    
    public func tabButtonBorderMask(position: TabButtonPosition) -> BorderMask? {
        return nil
    }
}

