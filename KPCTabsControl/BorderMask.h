//
//  BorderMask.h
//  KPCTabsControl
//
//  Created by Charlie Schmidt on 9/24/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

#ifndef BorderMask_h
#define BorderMask_h

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, BorderMask) {
    BorderMaskNone = 0,
    BorderMaskTop = 1 << 0,
    BorderMaskLeft = 1 << 1,
    BorderMaskRight = 1 << 2,
    BorderMaskBottom = 1 << 3
};

#endif /* BorderMask_h */


/**
 *  Border mask option set, used in tab buttons and the tabs control itself.
 */

/*
 public class BorderMask: OptionSet {
    public let rawValue: Int
    
    public required init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    
    public static func all() -> BorderMask {
        return BorderMask.top.union(BorderMask.left).union(BorderMask.right).union(BorderMask.bottom)
    }
    
    public static let top = BorderMask(rawValue: 1 << 0)
    public static let left = BorderMask(rawValue: 1 << 1)
    public static let right = BorderMask(rawValue: 1 << 2)
    public static let bottom = BorderMask(rawValue: 1 << 3)
}
*/
