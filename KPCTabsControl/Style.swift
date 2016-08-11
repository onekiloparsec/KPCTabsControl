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

public typealias IconFrames = (iconFrame: NSRect, alternativeTitleIconFrame: NSRect)

public protocol Style {

    var tabWidth: FlexibleWidth { get }

    func maxIconHeight(tabRect rect: NSRect, scale: CGFloat) -> CGFloat
    func iconFrames(tabRect rect: NSRect) -> IconFrames
    
    func drawTabButton(rect dirtyRect: NSRect, scale: CGFloat)
}

@available(*, deprecated=1.0)
public enum TabsControlTabsStyle {
    case NumbersApp
    case ChromeBrowser
    case SafariBrowser
    case XcodeNavigators
}
