//
//  KPCTabButton.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "KPCTabButtonCell.h"

@interface KPCTabButton : NSButton<NSCopying>

@property(nonatomic, assign) BOOL showsMenu;
@property(nonatomic, strong) NSImage *icon;
@property(nonatomic, strong) NSMenu *menu;

- (void)highlight:(BOOL)flag;

- (KPCTabButtonCell *)cell;
- (NSImageView *)iconView;

@end

extern BOOL KPCRectArrayWithBorderMask(NSRect sourceRect, KPCBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);
