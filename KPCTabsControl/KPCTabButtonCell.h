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
@property(nonatomic, assign, readonly, getter=isSelected) BOOL selected;

@property(nonatomic, assign) KPCTabStyle tabStyle;
@property(nonatomic, assign) KPCBorderMask borderMask;

@property(nonatomic, copy, nullable) NSColor *tabBorderColor;
@property(nonatomic, copy, nullable) NSColor *tabTitleColor;
@property(nonatomic, copy, nullable) NSColor *tabBackgroundColor;
@property(nonatomic, copy, nullable) NSColor *tabHighlightedBackgroundColor;

@property(nonatomic, copy, nullable) NSColor *tabSelectedBorderColor;
@property(nonatomic, copy, nullable) NSColor *tabSelectedTitleColor;
@property(nonatomic, copy, nullable) NSColor *tabSelectedBackgroundColor;

- (NSRect)editingRectForBounds:(NSRect)rect;
- (void)highlight:(BOOL)flag;
- (BOOL)hasRoomToDrawFullTitleInRect:(NSRect)frame;

@end
