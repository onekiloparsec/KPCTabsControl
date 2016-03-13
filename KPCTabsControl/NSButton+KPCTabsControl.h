//
//  NSButton+KPCTabsControl.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 30/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Cocoa/Cocoa.h>
#import "KPCTabButton.h"

@interface NSButton (KPCTabsControl)

+ (NSButton *)KPC_auxiliaryButtonWithImageNamed:(NSString *)imageName target:(id)target action:(SEL)action;
+ (KPCTabButton *)KPC_tabButtonWithItem:(id)item target:(id)target action:(SEL)action;

@end
