//
//  KPCTabsControlDataSource.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KPCTabsControl;
@class KPCTabButton;

@protocol KPCTabsControlDataSource <NSObject>

- (NSUInteger)tabControlNumberOfTabs:(KPCTabsControl *)tabControl;

- (id)tabControl:(KPCTabsControl *)tabControl itemAtIndex:(NSUInteger)index;

- (NSMenu *)tabControl:(KPCTabsControl *)tabControl menuForItem:(id)item;

- (NSString *)tabControl:(KPCTabsControl *)tabControl titleForItem:(id)item;
- (void)tabControl:(KPCTabsControl *)tabControl setTitle:(NSString *)title forItem:(id)item;

- (BOOL)tabControl:(KPCTabsControl *)tabControl canReorderItem:(id)item;
- (void)tabControlDidReorderItems:(LITabControl *)tabControl orderedItems:(NSArray *)itemArray;

@optional
- (void)tabControlDidChangeSelection:(NSNotification *)notification;

- (BOOL)tabControl:(KPCTabsControl *)tabControl canEditItem:(id)item;
- (BOOL)tabControl:(KPCTabsControl *)tabControl canSelectItem:(id)item;

- (void)tabControl:(KPCTabsControl *)tabControl willDisplayButton:(KPCTabButton *)button forItem:(id)item;

@end


@protocol KPCTabsControlDelegate <NSControlTextEditingDelegate>
@end
