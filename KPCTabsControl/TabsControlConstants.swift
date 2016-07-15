//
//  Constants.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

public struct TabsControlBorderMask: OptionSetType {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    static let Top = TabsControlBorderMask(rawValue: 1<<0)
    static let Left = TabsControlBorderMask(rawValue: 1<<1)
    static let Right = TabsControlBorderMask(rawValue: 1<<2)
    static let Bottom = TabsControlBorderMask(rawValue: 1<<3)
}

public enum TabsControlTabsStyle {
    case NumbersApp
    case ChromeBrowser
    case SafariBrowser
    case XcodeNavigators
}

public let TabsControlSelectionDidChangeNotification = "TabsControlSelectionDidChangeNotification"
