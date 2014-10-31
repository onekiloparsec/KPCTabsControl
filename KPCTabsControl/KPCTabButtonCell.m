//
//  KPCTabButtonCell.m
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "KPCTabsControlConstants.h"
#import "KPCTabButtonCell.h"
#import "KPCTabButton.h"
#import "KPCTabsControl.h"
#import "NSImage+KPCTabsControl.h"

#define DF_BORDER_COLOR [NSColor lightGrayColor]
#define DF_TITLE_COLOR [NSColor darkGrayColor]
#define DF_HIGHLIGHT_COLOR [NSColor colorWithCalibratedRed:0.119 green:0.399 blue:0.964 alpha:1.000]
#define DF_BACKGROUND_COLOR [NSColor colorWithCalibratedRed:0.854 green:0.858 blue:0.873 alpha:1.000]

// Numbers default
//#define DF_HIGHLIGHT_BACKGROUND_COLOR [NSColor colorWithCalibratedRed:215./255. green:232./255. blue:254./255. alpha:1.000]
// Numbers default
#define DF_HIGHLIGHT_BACKGROUND_COLOR [NSColor colorWithCalibratedRed:205./255. green:222./255. blue:244./255. alpha:1.000]
#define DF_HIGHLIGHT_BORDER_COLOR [NSColor colorWithCalibratedRed:185./255. green:202./255. blue:224./255. alpha:1.000]

@implementation KPCTabButtonCell

- (id)initTextCell:(NSString *)string
{
    self = [super initTextCell:string];
    if (self) {
        _borderColor = DF_BORDER_COLOR;
        _backgroundColor = DF_BACKGROUND_COLOR;
        
        _titleColor = DF_TITLE_COLOR;
        _titleHighlightColor = DF_HIGHLIGHT_COLOR;
        
        [self setBordered:YES];
        [self setBackgroundStyle:NSBackgroundStyleLight];
        [self setHighlightsBy:NSChangeBackgroundCellMask];
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
        [self setFocusRingType:NSFocusRingTypeNone];
    }
    return self;
}

- (void)setShowsMenu:(BOOL)showsMenu
{
    if (_showsMenu != showsMenu) {
        _showsMenu = showsMenu;
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setBorderColor:(NSColor *)borderColor
{
    if (_borderColor != borderColor) {
        _borderColor = borderColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = [backgroundColor copy];
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setBorderMask:(KPCBorderMask)borderMask
{
    if (_borderMask != borderMask) {
        _borderMask = borderMask;
        [self.controlView setNeedsDisplay:YES];
    }
}

+ (NSImage *)popupImage
{
    static NSImage *ret = nil;
    if (ret == nil) {
        ret = [[NSImage imageNamed:@"KPCPullDownTemplate"] imageWithTint:[NSColor darkGrayColor]];
    }
    return ret;
}

- (NSSize)cellSizeForBounds:(NSRect)aRect
{
    NSSize titleSize = [[self attributedTitle] size];
    NSSize popupSize = ([self menu] == nil) ? NSZeroSize : [[KPCTabButtonCell popupImage] size];
    return NSMakeSize(titleSize.width + (popupSize.width * 2) + 36, MAX(titleSize.height, popupSize.height));
}

- (NSRect)popupRectWithFrame:(NSRect)cellFrame
{
    NSRect popupRect = NSZeroRect;
    popupRect.size = [[KPCTabButtonCell popupImage] size];
    popupRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(popupRect) - 8, NSMidY(cellFrame) - NSHeight(popupRect) / 2);
    return popupRect;
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag
{
    NSRect popupRect = [self popupRectWithFrame:cellFrame];
    NSPoint location = [controlView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if ([self hitTestForEvent:theEvent inRect:[[controlView superview] frame] ofView:[controlView superview]] != NSCellHitNone) {
    
        if (self.menu.itemArray.count > 0 &&  NSPointInRect(location, popupRect)) {
            [self.menu popUpMenuPositioningItem:self.menu.itemArray[0]
                                     atLocation:NSMakePoint(NSMidX(popupRect), NSMaxY(popupRect))
                                         inView:controlView];
            
            [self setShowsMenu:NO];
            return YES;
        }
    }
        
    return [super trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:flag];
}

- (NSRect)titleRectForBounds:(NSRect)cellFrame
{
    NSSize titleSize = [[self attributedTitle] size];
    return NSMakeRect(NSMinX(cellFrame), NSMidY(cellFrame) - titleSize.height/2.0 - 2.0, NSWidth(cellFrame), titleSize.height);
}

- (NSRect)editingRectForBounds:(NSRect)rect
{
    return [self titleRectForBounds:NSOffsetRect(rect, 0, -1)];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (self.state) {
        [DF_HIGHLIGHT_BACKGROUND_COLOR setFill];
    }
    else {
        [self.backgroundColor setFill];
    }
    NSRectFill(cellFrame);
    
    [self drawBezelWithFrame:cellFrame inView:controlView];
    
    NSRect titleFrame = cellFrame;
    [self drawTitle:[self attributedTitle] withFrame:titleFrame inView:controlView];
    
    if (self.image && self.imagePosition != NSNoImage) {
        [self drawImage:[self.image imageWithTint:self.isHighlighted ? DF_HIGHLIGHT_COLOR : [NSColor darkGrayColor]]
              withFrame:cellFrame
                 inView:controlView];
    }
    
    if (self.showsMenu) {
        [[KPCTabButtonCell popupImage] drawInRect:[self popupRectWithFrame:cellFrame]
                                         fromRect:NSZeroRect
                                        operation:NSCompositeSourceOver
                                         fraction:1.0
                                   respectFlipped:YES
                                            hints:nil];
    }
}

- (void)drawBezelWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (self.state) {
        [DF_HIGHLIGHT_BACKGROUND_COLOR setFill];
    }
    else {
        [self.backgroundColor setFill];
    }
    NSRectFill(cellFrame);
    
    NSRect *borderRects;
    NSInteger borderRectCount;
    
    if (KPCRectArrayWithBorderMask(cellFrame, self.borderMask, &borderRects, &borderRectCount)) {
        [self.borderColor set];
        NSRectFillList(borderRects, borderRectCount);
    }
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView*)controlView
{
    NSRect titleRect = [self titleRectForBounds:frame];
    [title drawInRect:titleRect];
    return titleRect;
}

- (NSAttributedString *)attributedTitle
{
    NSMutableAttributedString *attributedTitle = [[super attributedTitle] mutableCopy];
    
    NSColor *color = (self.state ? self.titleHighlightColor : self.titleColor);
    [attributedTitle addAttributes:@{ NSForegroundColorAttributeName : color } range:NSMakeRange(0, attributedTitle.length)];
    
    NSFont *font = (self.isHighlighted) ? [NSFont fontWithName:@"HelveticaNeue-Bold" size:13] : [NSFont fontWithName:@"HelveticaNeue-Medium" size:13];
    [attributedTitle addAttributes:@{ NSFontAttributeName : font } range:NSMakeRange(0, attributedTitle.length)];
    
    return attributedTitle;
}


@end
