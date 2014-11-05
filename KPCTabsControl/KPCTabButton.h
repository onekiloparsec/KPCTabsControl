//
//  KPCTabButton.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "KPCTabButtonCell.h"

@interface KPCTabButton : NSButton

@property(nonatomic, assign) BOOL showsMenu;
@property(nonatomic, assign) KPCBorderMask borderMask;
@property(nonatomic, strong) NSImage *icon;

- (void)highlight:(BOOL)flag;
- (void)useMenu:(NSMenu *)menu;
- (KPCTabButtonCell *)cell;
- (NSImageView *)iconView;

@end

extern BOOL KPCRectArrayWithBorderMask(NSRect sourceRect, KPCBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);
