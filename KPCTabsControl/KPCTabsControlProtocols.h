//
//  KPCTabsControlDataSource.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Foundation/Foundation.h>

@class KPCTabsControl;

NS_ASSUME_NONNULL_BEGIN
@protocol KPCTabsControlDataSource <NSObject>

/**
 *  Returns the number of tabs
 *
 *  @param tabControl The instance of the tabs control.
 *
 *  @return A unsigned integer indicating the number of tabs to display.
 */
- (NSUInteger)tabsControlNumberOfTabs:(KPCTabsControl *)tabControl;

/**
 *  Return the item for the tab at the given index, similarly to a "representedObject" in a cell view.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param index      The index of the given item.
 *
 *  @return An instance of an object representing the tab.
 */
- (id)tabsControl:(KPCTabsControl *)tabControl itemAtIndex:(NSUInteger)index;

/**
 *  Return the title for the tab of the given item
 *
 *  @param tabControl The instance of the tabs control.
 *  @param item       The item representing the given tab.
 *
 *  @return A string to be used as title of the tab.
 */
- (NSString *)tabsControl:(KPCTabsControl *)tabControl titleForItem:(id)item;


@optional

/**
 *  If any, returns a menu for the tab, to be place to the right side of it. It is your responsability to fully
 *  configure its targets and actions before returning it to the tabs control.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param item       The item representing the given tab.
 *
 *  @return A menu instance.
 */
- (NSMenu * _Nullable)tabsControl:(KPCTabsControl *)tabControl menuForItem:(id)item;

/**
 *  If any, returns an icon for the tab, to be placed to the left side of it.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param item       The item representing the given tab.
 *
 *  @return An image instance for the icon.
 */
- (NSImage * _Nullable)tabsControl:(KPCTabsControl *)tabControl iconForItem:(id)item;

/**
 *  If the width of the tab is not large enough to draw the title, it is possible to provide here an alternate
 *  icon to replace it. The threshold at which one switch between the title and the icon is computed individually
 *  for each title.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param item       The item representing the given tab.
 *
 *  @return An image instance for the alternate icon.
 */
- (NSImage * _Nullable)tabsControl:(KPCTabsControl *)tabControl titleAlternativeIconForItem:(id)item;

@end


@protocol KPCTabsControlDelegate <NSControlTextEditingDelegate>
@optional

/**
 *  Return YES if the tab can be selected.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param item       The item representing the given tab.
 *
 *  @return A boolean value indicating whether the tab can be selected or not.
 */
- (BOOL)tabsControl:(KPCTabsControl *)tabControl canSelectItem:(id)item;

/**
 *  If implemented, the delegate is informed that the selected tab did change.
 *
 *  @param notification A notification instance whose 'object' value is the instance of the tabs control.
 */
- (void)tabsControlDidChangeSelection:(NSNotification *)notification;

/**
 *  Return YES if the tab is allowed to be reordered (by being dragged by the mouse).
 *
 *  @param tabControl The instance of the tabs control.
 *  @param item       The item representing the given tab.
 *
 *  @return A boolean value indicating whether the tab can be reordered or not.
 */
- (BOOL)tabsControl:(KPCTabsControl *)tabControl canReorderItem:(id)item;

/**
 *  If implemented, the delegate is informed that the tabs have been reordered. It is the delegate responsability
 *  to store the new order of items. If not stored, the tabs will recover their original order.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param itemArray  The array the items following the new orders.
 */
- (void)tabsControl:(KPCTabsControl *)tabControl didReorderItems:(NSArray *)itemArray;

/**
 *  Return YES if you allow the editing of the title of the tab. By default, titles are not editable.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param item       The item representing the given tab.
 *
 *  @return A boolean value indicating whether the tab title can be edited or not.
 */
- (BOOL)tabsControl:(KPCTabsControl *)tabControl canEditTitleOfItem:(id)item;

/**
 *  If implemented, the delegate is informed that the tab has been renamed to the given title. Again, it is the
 *  delegate responsability to store the new title.
 *
 *  @param tabControl The instance of the tabs control.
 *  @param title      The new title value.
 *  @param item       The item representing the given tab.
 */
- (void)tabsControl:(KPCTabsControl *)tabControl setTitle:(NSString *)title forItem:(id)item;

@end
NS_ASSUME_NONNULL_END
