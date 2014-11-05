//
//  KPCTabsControl.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Copyright (c) 2014 @onekiloparsec (Cédric Foellmi). All rights reserved.
//

#import <AppKit/AppKit.h>
#import "KPCTabsControlProtocols.h"

@interface KPCTabsControl : NSControl

@property(nonatomic, weak) IBOutlet id <KPCTabsControlDataSource> dataSource;
@property(nonatomic, weak) IBOutlet id <KPCTabsControlDelegate> delegate;

@property(nonatomic, weak) id selectedItem;

@property(nonatomic, assign) CGFloat minTabWidth;
@property(nonatomic, assign) CGFloat maxTabWidth;
@property(nonatomic, assign, readonly) CGFloat currentTabWidth;
@property(nonatomic, assign) BOOL preferFullWidthTabs;

@property(nonatomic, copy) NSColor *controlBorderColor;
@property(nonatomic, copy) NSColor *controlBackgroundColor;
@property(nonatomic, copy) NSColor *controlHighlightedBackgroundColor;

@property(nonatomic, copy) NSColor *tabBorderColor;
@property(nonatomic, copy) NSColor *tabTitleColor;
@property(nonatomic, copy) NSColor *tabBackgroundColor;
@property(nonatomic, copy) NSColor *tabHighlightedBackgroundColor;

@property(nonatomic, copy) NSColor *tabSelectedBorderColor;
@property(nonatomic, copy) NSColor *tabSelectedTitleColor;
@property(nonatomic, copy) NSColor *tabSelectedBackgroundColor;

@property(nonatomic, assign, readonly) BOOL isHighlighted;

- (void)reloadTabs;
- (void)highlight:(BOOL)flag;

@end
