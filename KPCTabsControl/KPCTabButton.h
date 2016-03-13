//
//  KPCTabButton.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import "KPCTabButtonCell.h"

@interface KPCTabButton : NSButton<NSCopying>

@property(nonatomic, assign) BOOL showsMenu;
@property(nonatomic, strong) NSImage *icon;
@property(nonatomic, strong) NSImage *alternativeTitleIcon;

- (void)highlight:(BOOL)flag;

- (KPCTabButtonCell *)cell;
- (NSImageView *)iconView;
- (NSImageView *)alternativeTitleIconView;

@end

extern BOOL KPCRectArrayWithBorderMask(NSRect sourceRect, KPCBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);
