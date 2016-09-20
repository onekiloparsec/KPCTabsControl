//
//  SequenceType.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

internal extension Sequence {
    
    internal func findFirst(_ predicate: (Self.Iterator.Element) -> Bool) -> Self.Iterator.Element? {

        for element in self {
            if predicate(element) {
                return element
            }
        }

        return nil
    }
}
