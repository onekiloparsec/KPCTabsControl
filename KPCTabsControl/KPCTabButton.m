//
//  KPCTabButton.m
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import "KPCTabButton.h"
#import "KPCTabButtonCell.h"
#import "KPCTabsControl.h"
#import "NSColor+KPCTabsControl.h"

@interface KPCTabButton ()
@property(nonatomic, strong) NSImageView *iconView;
@property(nonatomic, strong) NSImageView *alternativeTitleIconView;
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

- (instancetype)copyWithZone:(NSZone *)zone
{
    KPCTabButton *copy = [[KPCTabButton allocWithZone:zone] initWithFrame:self.frame];

    KPCTabButtonCell *cellCopy = [self.cell copy];
    [copy setCell:cellCopy];

    copy.icon = self.icon;
    copy.alternativeTitleIcon = self.alternativeTitleIcon;

    return copy;
}

- (KPCTabButtonCell *)cell
{
    return (KPCTabButtonCell *)[super cell];
}

- (void)highlight:(BOOL)flag
{
    [self.cell highlight:flag];
}

- (void)setIcon:(NSImage *)icon
{
    _icon = icon;
    
    if (icon && !self.iconView) {
        self.iconView = [[NSImageView alloc] initWithFrame:NSZeroRect];
        [self.iconView setImageFrameStyle:NSImageFrameNone];
        [self.iconView setImage:icon];
        [self addSubview:self.iconView];
    }
    else if (!icon && self.iconView) {
        [self.iconView removeFromSuperview];
        self.iconView = nil;
    }
}

- (void)setAlternativeTitleIcon:(NSImage *)alternativeTitleIcon
{
    _alternativeTitleIcon = alternativeTitleIcon;
    self.cell.hasTitleAlternativeIcon = (_alternativeTitleIcon != nil);
    
    if (_alternativeTitleIcon && !self.iconView) {
        self.alternativeTitleIconView = [[NSImageView alloc] initWithFrame:NSZeroRect];
        [self.alternativeTitleIconView setImageFrameStyle:NSImageFrameNone];
        [self.alternativeTitleIconView setImage:_alternativeTitleIcon];
        [self addSubview:self.alternativeTitleIconView];
        [self.alternativeTitleIconView setHidden:YES];
    }
    else if (!_alternativeTitleIcon && self.alternativeTitleIconView) {
        [self.alternativeTitleIconView removeFromSuperview];
        self.alternativeTitleIconView = nil;
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    CGFloat y = 2.0;
    CGFloat s = CGRectGetHeight(self.frame) - 2*y;
    CGFloat x = CGRectGetWidth(self.frame) / 2.0 - s / 2.0;
    self.iconView.frame = NSMakeRect(10.0, y, s, s);
    self.alternativeTitleIconView.frame = NSMakeRect(x, y, s, s);

    if (self.iconView.image.size.width > 1.2 * s) {
        NSImage *smallIcon = [[NSImage alloc] initWithSize:NSMakeSize(s, s)];
        [smallIcon addRepresentation:[NSBitmapImageRep imageRepWithData:[self.icon TIFFRepresentation]]];
        self.iconView.image = smallIcon;
    }

    if (self.alternativeTitleIconView.image.size.width > 1.2 * s) {
        NSImage *smallIcon = [[NSImage alloc] initWithSize:NSMakeSize(s, s)];
        [smallIcon addRepresentation:[NSBitmapImageRep imageRepWithData:[self.alternativeTitleIcon TIFFRepresentation]]];
        self.alternativeTitleIconView.image = smallIcon;
    }
    
    BOOL hasRoom = [self.cell hasRoomToDrawFullTitleInRect:self.bounds];
    [self.alternativeTitleIconView setHidden:hasRoom];
    self.toolTip = (hasRoom) ? nil : self.title;
    
    [super drawRect:dirtyRect];    
}

- (NSMenu *)menu
{
    return [self.cell menu];
}

- (void)setMenu:(NSMenu *)menu
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
        [self mouseEntered:[NSApp currentEvent]];
    }
    else {
        [self mouseExited:[NSApp currentEvent]];
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
