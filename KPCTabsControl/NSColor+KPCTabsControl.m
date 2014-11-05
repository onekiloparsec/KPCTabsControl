//
//  NSColor+KPCTabsControl.m
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 04/11/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "NSColor+KPCTabsControl.h"

@implementation NSColor (KPCTabsControl)

+ (NSColor *)KPC_defaultControlBorderColor
{
    return [NSColor lightGrayColor];
}

+ (NSColor *)KPC_defaultControlBackgroundColor
{
    return [NSColor colorWithCalibratedWhite:0.95 alpha:1.0];
}

+ (NSColor *)KPC_defaultControlHighlightedBackgroundColor
{
    return [NSColor colorWithCalibratedWhite:0.85 alpha:1.0];
}


+ (NSColor *)KPC_defaultTabBorderColor
{
    return [NSColor KPC_defaultControlBorderColor];
}

+ (NSColor *)KPC_defaultTabTitleColor
{
    return [NSColor darkGrayColor];
}

+ (NSColor *)KPC_defaultTabBackgroundColor
{
    return [NSColor KPC_defaultControlBackgroundColor];
}

+ (NSColor *)KPC_defaultTabHighlightedBackgroundColor
{
    return [NSColor KPC_defaultControlHighlightedBackgroundColor];
}



+ (NSColor *)KPC_defaultTabSelectedBorderColor
{
    return [NSColor colorWithCalibratedRed:185./255. green:202./255. blue:224./255. alpha:1.000];
}

// Very much like ~iOS7+ blue color, huh...
+ (NSColor *)KPC_defaultTabSelectedTitleColor
{
    return [NSColor colorWithCalibratedRed:0.119 green:0.399 blue:0.964 alpha:1.000];
}

// Apple's Numbers App: [NSColor colorWithCalibratedRed:215./255. green:232./255. blue:254./255. alpha:1.000]
+ (NSColor *)KPC_defaultTabSelectedBackgroundColor
{
    return [NSColor colorWithCalibratedRed:205./255. green:222./255. blue:244./255. alpha:1.000];
}

@end
