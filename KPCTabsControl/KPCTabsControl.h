//
//  KPCTabsControl.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "KPCTabsControlProtocols.h"
#import "KPCTabsControlConstants.h"
#import "KPCTabButton.h"

@interface KPCTabsControl : NSControl

@property(nonatomic, assign) CGFloat minTabWidth;
@property(nonatomic, assign) CGFloat maxTabWidth;
@property(nonatomic, assign, readonly) CGFloat currentTabWidth;

@property(nonatomic, weak) IBOutlet id <KPCTabsControlDelegate> delegate;
@property(nonatomic, weak) IBOutlet id <KPCTabsControlDataSource> dataSource;

@property(nonatomic, weak) id selectedItem;

@property(nonatomic, assign) BOOL preferFullWidthTabs;
@property(nonatomic, assign, readonly) BOOL isHighlighted;

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

- (void)reloadData;
- (void)highlight:(BOOL)flag;

@end
