//
//  KPCTabButtonCell.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KPCTabsControlConstants.h"

@interface KPCTabButtonCell : NSButtonCell

@property(nonatomic, assign) BOOL showsMenu;
@property(nonatomic, assign) KPCBorderMask borderMask;

@property(nonatomic, copy) NSColor *borderColor;
@property(nonatomic, copy) NSColor *backgroundColor;

@property(nonatomic, copy) NSColor *titleColor;
@property(nonatomic, copy) NSColor *titleHighlightColor;

- (NSRect)editingRectForBounds:(NSRect)rect;

@end
