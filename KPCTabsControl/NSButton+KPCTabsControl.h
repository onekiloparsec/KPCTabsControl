//
//  NSButton+KPCTabsControl.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 30/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KPCTabButton.h"

@interface NSButton (KPCTabsControl)

+ (NSButton *)auxiliaryButtonWithImageNamed:(NSString *)name target:(id)target action:(SEL)action;
+ (KPCTabButton *)tabButtonWithItem:(id)item target:(id)target action:(SEL)action;

@end
