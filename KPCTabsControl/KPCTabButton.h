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
@property(nonatomic, strong, nullable) NSImage *icon;
@property(nonatomic, strong, nullable) NSImage *alternativeTitleIcon;

- (void)highlight:(BOOL)flag;

- (nullable KPCTabButtonCell *)cell;
- (nullable NSImageView *)iconView;
- (nullable NSImageView *)alternativeTitleIconView;

@end

extern BOOL KPCRectArrayWithBorderMask(NSRect sourceRect, KPCBorderMask borderMask, NSRect * _Nonnull * _Nonnull rectArray,  NSInteger * _Nonnull rectCount);
