//
//  Error.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation

@noreturn func fatalMethodNotImplemented(function: String = #function) {
    fatalError("Method \(function) not implemented")
}
