//
//  SequenceType.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
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
