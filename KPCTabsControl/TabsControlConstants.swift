//
//  Constants.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

public let TabsControlSelectionDidChangeNotification = "TabsControlSelectionDidChangeNotification"

public enum TabButtonPosition {
    case first
    case middle
    case last
}

public typealias Offset = NSPoint

extension Offset {
    
    init(x: CGFloat) {
        
        self.x = x
        self.y = 0
    }
    
    init(y: CGFloat) {
        
        self.x = 0
        self.y = y
    }
}
