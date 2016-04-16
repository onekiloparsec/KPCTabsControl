//
//  NSColor+KPCTabsControl.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 04/11/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Cocoa/Cocoa.h>

@interface NSColor (KPCTabsControl)

/**
 *  The color of the border of the tabs control.
 */
+ (nonnull NSColor *)KPC_defaultControlBorderColor;

/**
 *  The color of the tab control background in normal state (unhighlighted);
 */
+ (nonnull NSColor *)KPC_defaultControlBackgroundColor;

/**
 *  The color of the tab control background in highlighted state;
 */
+ (nonnull NSColor *)KPC_defaultControlHighlightedBackgroundColor;



/**
 *  The color of the border of an individual tab button.
 */
+ (nonnull NSColor *)KPC_defaultTabBorderColor;

/**
 *  The color of the title of an individual tab button, when the button is not selected.
 */
+ (nonnull NSColor *)KPC_defaultTabTitleColor;

/**
 *  The color of the background of an individual tab button, when the button is not selected,
 *  and the control is in normal state (unhighlighted)
 */
+ (nonnull NSColor *)KPC_defaultTabBackgroundColor;

/**
 *  The color of the background of an individual tab button, when the button is not selected,
 *  and the control is in highlighted state
 */
+ (nonnull NSColor *)KPC_defaultTabHighlightedBackgroundColor;



// There is no customization of the colors for the selected tab following the highlight state of the control.


/**
 *  The color of the border of an individual tab when it is selected.
 */
+ (nonnull NSColor *)KPC_defaultTabSelectedBorderColor;

/**
 *  The color of the title an individual tab when it is selected.
 */
+ (nonnull NSColor *)KPC_defaultTabSelectedTitleColor;

/**
 *  The color of the background an individual tab when it is selected.
 */
+ (nonnull NSColor *)KPC_defaultTabSelectedBackgroundColor;



@end
