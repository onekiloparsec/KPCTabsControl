//
//  NSRect.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 10/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation

extension NSRect {

    /// Change width and height by `-dx` and `-dy`.
    @warn_unused_result
    func shrinkBy(dx dx: CGFloat, dy: CGFloat) -> NSRect {
        var result = self
        result.size = CGSize(width: result.size.width - dx, height: result.size.height - dy)
        return result
    }
}
