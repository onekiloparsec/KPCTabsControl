//
//  KPCTabsControlDataSource.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Copyright (c) 2014 @onekiloparsec (Cédric Foellmi). All rights reserved.
//

#import <Foundation/Foundation.h>

@class KPCTabsControl;

@protocol KPCTabsControlDataSource <NSObject>

- (NSUInteger)tabsControlNumberOfTabs:(KPCTabsControl *)tabControl;
- (id)tabsControl:(KPCTabsControl *)tabControl itemAtIndex:(NSUInteger)index;
- (NSString *)tabsControl:(KPCTabsControl *)tabControl titleForItem:(id)item;

@optional
- (NSMenu *)tabsControl:(KPCTabsControl *)tabControl menuForItem:(id)item;
- (NSImage *)tabsControl:(KPCTabsControl *)tabControl iconForItem:(id)item;
- (NSImage *)tabsControl:(KPCTabsControl *)tabControl titleAlternativeIconForItem:(id)item;

- (BOOL)tabsControl:(KPCTabsControl *)tabControl canSelectItem:(id)item;
- (void)tabsControlDidChangeSelection:(NSNotification *)notification;

- (BOOL)tabsControl:(KPCTabsControl *)tabControl canReorderItem:(id)item;
- (void)tabsControl:(KPCTabsControl *)tabControl didReorderItems:(NSArray *)itemArray;

- (BOOL)tabsControl:(KPCTabsControl *)tabControl canEditItem:(id)item;
- (void)tabsControl:(KPCTabsControl *)tabControl setTitle:(NSString *)title forItem:(id)item;

@end


@protocol KPCTabsControlDelegate <NSControlTextEditingDelegate>
@end
