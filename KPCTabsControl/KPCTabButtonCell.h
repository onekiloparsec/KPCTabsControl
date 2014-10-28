//
//  KPCTabButtonCell.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    LIBorderMaskTop     = (1<<0),
    LIBorderMaskLeft    = (1<<1),
    LIBorderMaskRight   = (1<<2),
    LIBorderMaskBottom  = (1<<3)
} LIBorderMask;

@interface KPCTabButtonCell : NSButtonCell

@property(nonatomic, assign) BOOL showsMenu;
@property(nonatomic, assign) LIBorderMask borderMask;

@property(nonatomic, copy) NSColor *borderColor;
@property(nonatomic, copy) NSColor *backgroundColor;

@property(nonatomic, copy) NSColor *titleColor;
@property(nonatomic, copy) NSColor *titleHighlightColor;

@property(nonatomic, assign) CGFloat minWidth;
@property(nonatomic, assign) CGFloat maxWidth;

- (NSRect)editingRectForBounds:(NSRect)rect;

@end
