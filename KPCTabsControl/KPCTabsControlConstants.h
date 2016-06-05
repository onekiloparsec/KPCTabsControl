//
//  KPCTabsControlConstants.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Foundation/Foundation.h>

typedef enum {
    KPCBorderMaskTop     = (1<<0),
    KPCBorderMaskLeft    = (1<<1),
    KPCBorderMaskRight   = (1<<2),
    KPCBorderMaskBottom  = (1<<3)
} KPCBorderMask;

typedef enum {
    KPCTabStyleChromeBrowser,
    KPCTabStyleNumbersApp, // default
} KPCTabStyle;

extern NSString * const KPCTabsControlSelectionDidChangeNotification;

