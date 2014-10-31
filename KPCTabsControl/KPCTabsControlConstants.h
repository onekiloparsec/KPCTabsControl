//
//  KPCTabsControlConstants.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KPCBorderMaskTop     = (1<<0),
    KPCBorderMaskLeft    = (1<<1),
    KPCBorderMaskRight   = (1<<2),
    KPCBorderMaskBottom  = (1<<3)
} KPCBorderMask;

extern NSString * const KPCTabsControlSelectionDidChangeNotification;

