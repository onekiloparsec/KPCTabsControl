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

+ (nonnull NSButton *)KPC_auxiliaryButtonWithImageNamed:(nullable NSString *)imageName target:(nullable id)target action:(nullable SEL)action;
+ (nonnull KPCTabButton *)KPC_tabButtonWithItem:(nullable id)item target:(nullable id)target action:(nullable  SEL)action;

@end
