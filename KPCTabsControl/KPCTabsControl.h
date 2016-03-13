//
//  KPCTabsControl.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

FOUNDATION_EXPORT double KPCTabsVersionNumber;

//! Project version string for KPCTabs.
FOUNDATION_EXPORT const unsigned char KPCTabsVersionString[];

#import "KPCTabsControlProtocols.h"
#import "KPCTabsControlConstants.h"

/*
 *  KPCTabsControl is the main class of the library, and is designed to suffice for implementing tabs in your app.
 *  The only necessary thing for it to work is an implementation of uts dataSource.
 *  No other classes (such as those of the buttons) should be necessary to access the full features of KPCTabsControl.
 */
@interface KPCTabsControl : NSControl

/**
 *  The dataSource of the tabs control, providing all the necessary information for the class to build the tabs.
 */
@property(nonatomic, weak) IBOutlet id <KPCTabsControlDataSource> dataSource;

/**
 *  The delegate of the tabs control, providing additional possibilities for customization and precise behavior.
 */
@property(nonatomic, weak) IBOutlet id <KPCTabsControlDelegate> delegate;

/**
 *  Each tab being represented by an item, this property points to the currently selected item. Assigning it to
 *  a new value triggers a new selection. Selecting an unknown item will unselect any tabs, and leave the tabs control
 *  with no tab selected.
 */
@property(nonatomic, weak) id selectedItem;

/**
 *  When `preferFullWidthTabs` is NO, the minimum width of tabs. Given the total width of the tabs control, it will
 *  adjust the tab width between the specified minimum and maximum values. All tabs have the same width, always.
 */
@property(nonatomic, assign) CGFloat minTabWidth;

/**
 *  When `preferFullWidthTabs` is `NO`, the maximum width of tabs. Given the total width of the tabs control, it will
 *  adjust the tab width between the specified minimum and maximum values. All tabs have the same width, always.
 */
@property(nonatomic, assign) CGFloat maxTabWidth;

/**
 *  The current value of the tabs width.
 */
@property(nonatomic, assign, readonly) CGFloat currentTabWidth;

/**
 *  Indicates whether the tabs control should span the whole available width or not. Default is `NO`. If set to `YES`,
 *  the tabs may occur to have a width smaller than `minTabWidth` or larger than `maxTabWidth`.
 */
@property(nonatomic, assign) BOOL preferFullWidthTabs;

/**
 *  The border mask controls for which sides of every tab one should draw a border.
 */
@property(nonatomic, assign) KPCBorderMask controlBorderMask;

/**
 *  Indicates whether one should automatically add a left border to the most leftish tab, and one right border to the
 *  most rightish tab. Default is `YES`.
 */
@property(nonatomic, assign) BOOL automaticSideBorderMasks;

/**
 *  The color of the tabs control itself.
 */
@property(nonatomic, copy) NSColor *controlBorderColor;

/**
 *  The color of the background of the tabs control itself (invisible when `preferFullWidthTabs` is `YES`).
 */
@property(nonatomic, copy) NSColor *controlBackgroundColor;

/**
 *  The color of the background of the tabs control itself when being highlighted (invisible when `preferFullWidthTabs`
 *  is `YES`).
 */
@property(nonatomic, copy) NSColor *controlHighlightedBackgroundColor;

/**
 *  The color of the tab borders for unselected tabs.
 */
@property(nonatomic, copy) NSColor *tabBorderColor;

/**
 *  The color of the tabs titles for unselected tabs.
 */
@property(nonatomic, copy) NSColor *tabTitleColor;

/**
 *  The color of the tabs background for unselected tabs.
 */
@property(nonatomic, copy) NSColor *tabBackgroundColor;

/**
 *  The color of the tabs background when highlighted for unselected tabs.
 */
@property(nonatomic, copy) NSColor *tabHighlightedBackgroundColor;

/**
 *  The color of the selected tab borders.
 */
@property(nonatomic, copy) NSColor *tabSelectedBorderColor;

/**
 *  The color of the selected tab title.
 */
@property(nonatomic, copy) NSColor *tabSelectedTitleColor;

/**
 *  The color of the selected tab background.
 */
@property(nonatomic, copy) NSColor *tabSelectedBackgroundColor;

/**
 *  The highlight state of the tabs control. By default, every new tabs control starts 'unhighlighted'.
 */
@property(nonatomic, assign, readonly) BOOL isHighlighted;

/**
 *  The index of the selected item.
 *
 *  @return An integer indicating the index of the selected item in the list of tabs.
 */
- (NSInteger)selectedItemIndex;

/**
 *  Select an item at a given index. Selecting an invalid index will unselected all tabs.
 *
 *  @param index An integer indicating the index of the item to be selected.
 */
- (void)selectItemAtIndex:(NSInteger)index;

/**
 *  Reloads all tabs of the tabs control. Useful when the `dataSource` has changed.
 */
- (void)reloadTabs;

/**
 *  (Un)highlight the tabs control.
 *
 *  @param flag A boolean value indicating whether the tabs control should adopt a 'highlighted' state
 *  (with slightly darker default background colors) or not.
 */
- (void)highlight:(BOOL)flag;

@end
