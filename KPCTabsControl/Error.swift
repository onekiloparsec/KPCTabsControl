//
//  Error.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

func fatalMethodNotImplemented(_ function: String = #function) -> Never  {
    fatalError("Method \(function) not implemented")
}
