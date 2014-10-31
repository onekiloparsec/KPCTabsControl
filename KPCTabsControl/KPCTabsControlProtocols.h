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
- (NSString *)tabControl:(KPCTabsControl *)tabControl titleForItem:(id)item;

@optional
- (NSMenu *)tabControl:(KPCTabsControl *)tabControl menuForItem:(id)item;

- (BOOL)tabControl:(KPCTabsControl *)tabControl canSelectItem:(id)item;
- (void)tabControlDidChangeSelection:(NSNotification *)notification;

- (BOOL)tabControl:(KPCTabsControl *)tabControl canReorderItem:(id)item;
- (void)tabControlDidReorderItems:(KPCTabsControl *)tabControl orderedItems:(NSArray *)itemArray;

- (BOOL)tabControl:(KPCTabsControl *)tabControl canEditItem:(id)item;
- (void)tabControl:(KPCTabsControl *)tabControl setTitle:(NSString *)title forItem:(id)item;

- (void)tabControl:(KPCTabsControl *)tabControl willDisplayButton:(KPCTabButton *)button forItem:(id)item;

@end


@protocol KPCTabsControlDelegate <NSControlTextEditingDelegate>
@end
