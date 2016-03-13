//
//  NSImage+KPCTabsControl.m
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
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
