//
//  KPCTabButton.m
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "KPCTabButton.h"

@interface KPCTabButton ()
@property(nonatomic, strong) NSImageView *iconView;
@property(nonatomic, strong) NSTrackingArea *trackingArea;
@end

@implementation KPCTabButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setCell:[[KPCTabButtonCell alloc] initTextCell:@""]];
}

- (KPCTabButtonCell *)cell
{
    return (KPCTabButtonCell *)[super cell];
}

- (void)setIcon:(NSImage *)icon
{
    _icon = icon;
    
    if (icon && !self.iconView) {
        self.iconView = [[NSImageView alloc] initWithFrame:CGRectMake(10.0, 0.0, 18.0, 18.0)];
        [self.iconView setImageFrameStyle:NSImageFrameNone];
        [self.iconView setImage:icon];
        [self addSubview:self.iconView];
    }
    else if (!icon && self.iconView) {
        [self.iconView removeFromSuperview];
        self.iconView = nil;
    }
}

- (void)useMenu:(NSMenu *)menu
{
    [self.cell setMenu:menu];
    [self updateTrackingAreas];
}

- (void)updateTrackingAreas
{
    [self removeTrackingArea:self.trackingArea];
    
    id item = [[self cell] representedObject];
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                     options:(NSTrackingMouseEnteredAndExited|NSTrackingActiveInActiveApp|NSTrackingInVisibleRect)
                                                       owner:self
                                                    userInfo:item ? @{@"item" : item} : nil];
    
    [self addTrackingArea:self.trackingArea];
    
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint:mouseLocation fromView:nil];
    
    if (NSPointInRect(mouseLocation, [self bounds])) {
        [self mouseEntered:nil];
    }
    else {
        [self mouseExited:nil];
    }
    
    [super updateTrackingAreas];
}

- (void)resetCursorRects
{
    [self addCursorRect:[self bounds] cursor:[NSCursor arrowCursor]];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [super mouseEntered:theEvent];
    self.showsMenu = ([[[self.cell menu] itemArray] count] > 0);
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [super mouseExited:theEvent];
    self.showsMenu = NO;
}


#pragma mark - Forwards

- (BOOL)showsMenu
{
    return [self.cell showsMenu];
}

- (void)setShowsMenu:(BOOL)showsMenu
{
    [self.cell setShowsMenu:showsMenu];
}

- (KPCBorderMask)borderMask
{
    return [self.cell borderMask];
}

- (void)setBorderMask:(KPCBorderMask)borderMask
{
    [self.cell setBorderMask:borderMask];
}

- (NSColor *)borderColor
{
    return [self.cell borderColor];
}

- (void)setBorderColor:(NSColor *)borderColor
{
    [self.cell setBorderColor:borderColor];
}

- (NSColor *)backgroundColor
{
    return [self.cell backgroundColor];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    [self.cell setBackgroundColor:backgroundColor];
}

- (NSColor *)titleColor
{
    return [self.cell titleColor];
}

- (void)setTitleColor:(NSColor *)titleColor
{
    [self.cell setTitleColor:titleColor];
}

- (NSColor *)titleHighlightColor
{
    return [self.cell titleHighlightColor];
}

- (void)setTitleHighlightColor:(NSColor *)titleHighlightColor
{
    [self.cell setTitleHighlightColor:titleHighlightColor];
}

@end


BOOL KPCRectArrayWithBorderMask(NSRect sourceRect, KPCBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount)
{
    NSInteger outputCount = 0;
    static NSRect outputArray[4];
    
    NSRect remainderRect;
    if (borderMask & KPCBorderMaskTop) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMinYEdge);
    }
    if (borderMask & KPCBorderMaskLeft) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMinXEdge);
    }
    if (borderMask & KPCBorderMaskRight) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMaxXEdge);
    }
    if (borderMask & KPCBorderMaskBottom) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMaxYEdge);
    }
    
    if (rectCount) *rectCount = outputCount;
    if (rectArray) *rectArray = &outputArray[0];
    
    return (outputCount > 0);
}
