//
//  Error.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

@noreturn func fatalMethodNotImplemented(function: String = #function) {
    fatalError("Method \(function) not implemented")
}
