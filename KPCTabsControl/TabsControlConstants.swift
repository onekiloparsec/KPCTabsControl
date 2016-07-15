//
//  Constants.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

public struct KPCTabsControlBorderMask: OptionSetType {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    static let Top = KPCTabsControlBorderMask(rawValue: 1<<0)
    static let Left = KPCTabsControlBorderMask(rawValue: 1<<1)
    static let Right = KPCTabsControlBorderMask(rawValue: 1<<2)
    static let Bottom = KPCTabsControlBorderMask(rawValue: 1<<3)
}

public enum KPCTabsControlTabStyle {
    case NumbersApp
    case ChromeBrowser
    case SafariBrowser
    case XcodeNavigators
}

public let TabsControlSelectionDidChangeNotification = "TabsControlSelectionDidChangeNotification"
