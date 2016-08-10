//
//  Style.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

public struct FlexibleWidth {
    public let min: CGFloat
    public let max: CGFloat

    public init(min: CGFloat, max: CGFloat) {

        self.min = min
        self.max = max
    }
}

public protocol Style {

    var tabWidth: FlexibleWidth { get }
}

@available(*, deprecated=1.0)
public enum TabsControlTabsStyle {
    case NumbersApp
    case ChromeBrowser
    case SafariBrowser
    case XcodeNavigators
}
