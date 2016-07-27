//
//  KPCTabsControlCell.h
//  KPCTabsControl
//
//  Created by Christian Tietze on 27/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Cocoa/Cocoa.h>

@interface KPCTabsControlCell : NSCell
@property(nonatomic, assign) KPCBorderMask borderMask;
@property(nonatomic, copy, nullable) NSColor *tabBorderColor;
@property(nonatomic, copy, nullable) NSColor *tabBackgroundColor;
@property(nonatomic, copy, nullable) NSColor *tabHighlightedBackgroundColor;

- (void)highlight:(BOOL)flag;

@end
