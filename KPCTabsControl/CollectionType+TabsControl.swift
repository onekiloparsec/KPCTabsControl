//
//  CollectionType+TabsControl.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 15/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

extension CollectionType where Self.Index : Comparable {

    subscript (safe index: Self.Index) -> Self.Generator.Element? {
        return index < endIndex ? self[index] : nil
    }
}
