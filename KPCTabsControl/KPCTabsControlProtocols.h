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

/** Returns the number of tabs */
- (NSUInteger)tabsControlNumberOfTabs:(KPCTabsControl *)tabControl;

/** Return the item for the tab at the given index, similarly to a "representedObject" in a cell view. */
- (id)tabsControl:(KPCTabsControl *)tabControl itemAtIndex:(NSUInteger)index;

/** Return the title for the tab of the given item */
- (NSString *)tabsControl:(KPCTabsControl *)tabControl titleForItem:(id)item;


@optional

/** If any, returns a menu for the tab. */
- (NSMenu *)tabsControl:(KPCTabsControl *)tabControl menuForItem:(id)item;

/** If any, returns an icon for the tab. */
- (NSImage *)tabsControl:(KPCTabsControl *)tabControl iconForItem:(id)item;

/** If the width of the tab is not large enough to draw the title, before reaching the tabs' minWidth, 
 one can return an icon that is drawn instead of the title. */
- (NSImage *)tabsControl:(KPCTabsControl *)tabControl titleAlternativeIconForItem:(id)item;

@end


@protocol KPCTabsControlDelegate <NSControlTextEditingDelegate>
@optional

/** Return YES if the tab can be selected. */
- (BOOL)tabsControl:(KPCTabsControl *)tabControl canSelectItem:(id)item;

/** If implemented, the data source is informed that the selected tab did change. */
- (void)tabsControlDidChangeSelection:(NSNotification *)notification;

/** Return yes if the tab is allows to be re-ordered. */
- (BOOL)tabsControl:(KPCTabsControl *)tabControl canReorderItem:(id)item;

/** If implemented, the dataSource is informed that the tabs have been re-ordered. It is the dataSource responsability
 to store the new order of items. If not stored, the tabs will recover their original order. */
- (void)tabsControl:(KPCTabsControl *)tabControl didReorderItems:(NSArray *)itemArray;

/** Return YES if you allow the editing of the title of the tab. */
- (BOOL)tabsControl:(KPCTabsControl *)tabControl canEditItem:(id)item;

/** If implemented, the dataSource is informed that the tab has been renamed to the given title. Again, it is the
 dataSource responsability to store the new title. */
- (void)tabsControl:(KPCTabsControl *)tabControl setTitle:(NSString *)title forItem:(id)item;

@end
