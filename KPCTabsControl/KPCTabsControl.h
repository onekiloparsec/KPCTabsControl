//
//  KPCTabsControl.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "KPCTabsControlProtocols.h"

@interface KPCTabsControl : NSControl

@property(nonatomic, copy) NSColor *borderColor;
@property(nonatomic, copy) NSColor *backgroundColor;

@property(nonatomic, copy) NSColor *titleColor;
@property(nonatomic, copy) NSColor *titleHighlightColor;

@property(nonatomic, weak) id <KPCTabsControlDelegate> delegate;
@property(nonatomic, weak) id <KPCTabsControlDataSource> dataSource;

@property(nonatomic, weak) id selectedItem;

@property(nonatomic) SEL addAction;
@property(nonatomic, weak) id addTarget;
@property(nonatomic) BOOL notifiesOnPartialReorder;

- (void)reloadData;

- (void)editItem:(id)item;

- (NSArray *)tabButtons;
- (NSButton *)tabButtonWithItem:(id)item;

- (void)highlight;
- (void)unhighlight;

@end
