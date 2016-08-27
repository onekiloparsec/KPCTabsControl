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
    
    public func iconFrames(tabRect rect: NSRect) -> IconFrames {
        return (NSZeroRect, NSZeroRect)
    }
}

