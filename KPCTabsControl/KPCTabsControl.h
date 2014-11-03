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

@property(nonatomic, copy) NSColor *borderColor;
@property(nonatomic, copy) NSColor *backgroundColor;

@property(nonatomic, copy) NSColor *titleColor;
@property(nonatomic, copy) NSColor *titleHighlightColor;

@property(nonatomic, assign) CGFloat minTabWidth;
@property(nonatomic, assign) CGFloat maxTabWidth;
@property(nonatomic, assign, readonly) CGFloat currentTabWidth;

@property(nonatomic, weak) IBOutlet id <KPCTabsControlDelegate> delegate;
@property(nonatomic, weak) IBOutlet id <KPCTabsControlDataSource> dataSource;

@property(nonatomic, weak) id selectedItem;

@property(nonatomic, assign) BOOL preferFullWidthTabs;
@property(nonatomic, assign, readonly) BOOL isHighlighted;

@property(nonatomic, assign) SEL addAction;
@property(nonatomic, weak) id addTarget;

- (void)reloadData;
- (void)highlight:(BOOL)flag;

- (void)editItem:(id)item;

@end
