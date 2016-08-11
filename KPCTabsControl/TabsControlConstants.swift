//
//  Constants.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

@available(*, deprecated=1.0, message="Move this into `Style` drawing code instead")
public struct TabsControlBorderMask: OptionSetType {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    static public let Top = TabsControlBorderMask(rawValue: 1<<0)
    static public let Left = TabsControlBorderMask(rawValue: 1<<1)
    static public let Right = TabsControlBorderMask(rawValue: 1<<2)
    static public let Bottom = TabsControlBorderMask(rawValue: 1<<3)
}

public let TabsControlSelectionDidChangeNotification = "TabsControlSelectionDidChangeNotification"
