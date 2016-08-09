//
//  SequenceType.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

extension SequenceType {

    func findFirst(predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {

        for element in self {
            if predicate(element) {
                return element
            }
        }

        return nil
    }
}
