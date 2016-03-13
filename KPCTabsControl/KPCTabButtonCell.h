//
//  KPCTabButtonCell.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Cocoa/Cocoa.h>
#import "KPCTabsControlConstants.h"

@interface KPCTabButtonCell : NSButtonCell<NSCopying>

@property(nonatomic, assign) BOOL showsMenu;
@property(nonatomic, assign) BOOL hasTitleAlternativeIcon;
@property(nonatomic, assign) KPCBorderMask borderMask;
@property(nonatomic, assign, readonly, getter=isSelected) BOOL selected;

@property(nonatomic, copy) NSColor *tabBorderColor;
@property(nonatomic, copy) NSColor *tabTitleColor;
@property(nonatomic, copy) NSColor *tabBackgroundColor;
@property(nonatomic, copy) NSColor *tabHighlightedBackgroundColor;

@property(nonatomic, copy) NSColor *tabSelectedBorderColor;
@property(nonatomic, copy) NSColor *tabSelectedTitleColor;
@property(nonatomic, copy) NSColor *tabSelectedBackgroundColor;

- (NSRect)editingRectForBounds:(NSRect)rect;
- (void)highlight:(BOOL)flag;
- (BOOL)hasRoomToDrawFullTitleInRect:(NSRect)frame;

@end
