//
//  NSImage+KPCTabsControl.m
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "NSImage+KPCTabsControl.h"

@implementation NSImage (KPCTabsControl)

- (NSImage *)KPC_imageWithTint:(NSColor *)color
{
    NSRect imageRect = NSZeroRect;
    imageRect.size = self.size;
    
    NSImage *highlightImage = [[NSImage alloc] initWithSize:imageRect.size];
    
    [highlightImage lockFocus];
    
    [self drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    [color set];
    NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
    
    [highlightImage unlockFocus];
    
    return highlightImage;
}

@end
