//
//  NSButton+KPCTabsControl.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 30/10/14.
//  Copyright (c) 2014 @onekiloparsec (Cédric Foellmi). All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KPCTabButton.h"

@interface NSButton (KPCTabsControl)

+ (NSButton *)KPC_auxiliaryButtonWithImageNamed:(NSString *)name target:(id)target action:(SEL)action;
+ (KPCTabButton *)KPC_tabButtonWithItem:(id)item target:(id)target action:(SEL)action;

@end
