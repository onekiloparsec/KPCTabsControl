//
//  KPCTabButtonCell.m
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import "KPCTabsControlConstants.h"
#import "KPCTabButtonCell.h"
#import "KPCTabButton.h"
#import "KPCTabsControl.h"
#import "NSImage+KPCTabsControl.h"
#import "NSColor+KPCTabsControl.h"

static CGFloat titleMargin = 5.0;

@implementation KPCTabButtonCell

- (id)initTextCell:(NSString *)string
{
    self = [super initTextCell:string];
    if (self) {        
        [self setBordered:YES];
        [self setBackgroundStyle:NSBackgroundStyleLight];
        [self setHighlightsBy:NSChangeBackgroundCellMask];
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
        [self setFocusRingType:NSFocusRingTypeNone];
        
        _tabBorderColor = [NSColor KPC_defaultTabBorderColor];
        _tabTitleColor = [NSColor KPC_defaultTabTitleColor];
        _tabBackgroundColor = [NSColor KPC_defaultTabBackgroundColor];
        _tabHighlightedBackgroundColor = [NSColor KPC_defaultTabHighlightedBackgroundColor];
        _tabSelectedBorderColor = [NSColor KPC_defaultTabSelectedBorderColor];
        _tabSelectedTitleColor = [NSColor KPC_defaultTabSelectedTitleColor];
        _tabSelectedBackgroundColor = [NSColor KPC_defaultTabSelectedBackgroundColor];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    KPCTabButtonCell *copy = [[KPCTabButtonCell allocWithZone:zone] initTextCell:self.title];
    
    copy.tabBorderColor = self.tabBorderColor;
    copy.tabTitleColor = self.tabTitleColor;
    copy.tabBackgroundColor = self.tabBackgroundColor;
    copy.tabHighlightedBackgroundColor = self.tabHighlightedBackgroundColor;
    copy.tabSelectedBorderColor = self.tabSelectedBorderColor;
    copy.tabSelectedTitleColor = self.tabSelectedTitleColor;
    copy.tabSelectedBackgroundColor = self.tabSelectedBackgroundColor;
    
    copy.borderMask = self.borderMask;
    copy.state = self.state;
    copy.showsMenu = self.showsMenu;
    copy.highlighted = self.highlighted;
    copy.hasTitleAlternativeIcon = self.hasTitleAlternativeIcon;

    return copy;
}

// Do not allow to change state of the cell associated with the parent Tabs Control.
- (void)setState:(NSInteger)state
{
    if ([self.controlView isKindOfClass:[KPCTabButton class]]) {
        [super setState:state];
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setImage:(NSImage *)image
{
    if (![self.controlView isKindOfClass:[KPCTabButton class]]) {
        [super setImage:image];
        [self.controlView setNeedsDisplay:YES];
    }
}

- (BOOL)isSelected
{
    return (self.state == NSOnState) ? YES : NO;
}

- (void)setShowsMenu:(BOOL)showsMenu
{
    _showsMenu = showsMenu;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setBorderMask:(KPCBorderMask)borderMask
{
    _borderMask = borderMask;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTabBorderColor:(NSColor *)tabBorderColor
{
    _tabBorderColor = tabBorderColor;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTabTitleColor:(NSColor *)tabTitleColor
{
    _tabTitleColor = tabTitleColor;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTabBackgroundColor:(NSColor *)tabBackgroundColor
{
    _tabBackgroundColor = tabBackgroundColor;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTabHighlightedBackgroundColor:(NSColor *)tabHighlightedBackgroundColor
{
    _tabHighlightedBackgroundColor = tabHighlightedBackgroundColor;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTabSelectedBorderColor:(NSColor *)tabSelectedBorderColor
{
    _tabSelectedBorderColor = tabSelectedBorderColor;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTabSelectedTitleColor:(NSColor *)tabSelectedTitleColor
{
    _tabSelectedTitleColor = tabSelectedTitleColor;
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTabSelectedBackgroundColor:(NSColor *)tabSelectedBackgroundColor
{
    _tabSelectedBackgroundColor = tabSelectedBackgroundColor;
    [self.controlView setNeedsDisplay:YES];
}

- (void)highlight:(BOOL)flag
{
    self.highlighted = flag;
    [self.controlView setNeedsDisplay:YES];
}

+ (NSImage *)popupImage
{
    static NSImage *ret = nil;
    if (ret == nil) {
        ret = [[NSImage imageNamed:@"KPCPullDownTemplate"] KPC_imageWithTint:[NSColor darkGrayColor]];
    }
    return ret;
}

- (NSAttributedString *)attributedTitle
{
    NSMutableAttributedString *attributedTitle = [[super attributedTitle] mutableCopy];
    
    NSColor *color = (self.isSelected ? self.tabSelectedTitleColor : self.tabTitleColor);
    [attributedTitle addAttributes:@{ NSForegroundColorAttributeName : color } range:NSMakeRange(0, attributedTitle.length)];
    
    NSFont *font = (self.isHighlighted) ? [NSFont boldSystemFontOfSize:13] : [NSFont systemFontOfSize:13];
    [attributedTitle addAttributes:@{ NSFontAttributeName : font } range:NSMakeRange(0, attributedTitle.length)];
    
    return attributedTitle;
}

- (BOOL)hasRoomToDrawFullTitleInRect:(NSRect)frame
{
    NSRect titleDrawRect = [self titleRectForBounds:frame];
    CGFloat requiredMinimumWidth = [[self attributedTitle] size].width + 2.0*titleMargin;
    return requiredMinimumWidth <= NSWidth(titleDrawRect);
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
    return NSMakeRect(NSMinX(cellFrame), NSMidY(cellFrame) - titleSize.height/2.0, NSWidth(cellFrame), titleSize.height);
}

- (NSRect)editingRectForBounds:(NSRect)rect
{
    return [self titleRectForBounds:NSOffsetRect(rect, 0, 0)];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self drawBezelWithFrame:cellFrame inView:controlView];
    
    if ([self hasRoomToDrawFullTitleInRect:cellFrame] || !self.hasTitleAlternativeIcon) {
        [self drawTitle:[self attributedTitle] withFrame:cellFrame inView:controlView];
    }
    
    if (self.image && self.imagePosition != NSNoImage) {
         [self drawImage:[self.image KPC_imageWithTint:(self.isHighlighted) ? [NSColor darkGrayColor] : [NSColor lightGrayColor]]
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
    if (self.isSelected) {
        [self.tabSelectedBackgroundColor setFill];
    }
    else if (self.isHighlighted) {
        [self.tabHighlightedBackgroundColor setFill];
    }
    else {
        [self.tabBackgroundColor setFill];
    }
    NSRectFill(cellFrame);
    
    NSRect *borderRects;
    NSInteger borderRectCount;
    
    if (KPCRectArrayWithBorderMask(cellFrame, self.borderMask, &borderRects, &borderRectCount)) {
        if (self.isSelected) {
            [self.tabSelectedBorderColor setFill];
        }
        else {
            [self.tabBorderColor setFill];
        }
        [self.tabBorderColor set];
        NSRectFillList(borderRects, borderRectCount);
    }
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSRect titleRect = [self titleRectForBounds:frame];
    [title drawInRect:titleRect];
    return titleRect;
}


@end
