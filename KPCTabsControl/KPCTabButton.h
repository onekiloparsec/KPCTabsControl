//
//  KPCTabButton.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "KPCTabButtonCell.h"

@interface KPCTabButton : NSButton

+ (Class)cellClass;

@property(nonatomic, assign) BOOL showsMenu;
@property(nonatomic, assign) LIBorderMask borderMask;

@property(nonatomic, copy) NSColor *borderColor;
@property(nonatomic, copy) NSColor *backgroundColor;

@property(nonatomic, copy) NSColor *titleColor;
@property(nonatomic, copy) NSColor *titleHighlightColor;

@property(nonatomic, assign) CGFloat minWidth;
@property(nonatomic, assign) CGFloat maxWidth;

@property(nonatomic, strong) NSImage *icon;

- (void)constrainSizeWithCell:(KPCTabButtonCell *)cell;

@end

extern BOOL KPCRectArrayWithBorderMask(NSRect sourceRect, LIBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);
