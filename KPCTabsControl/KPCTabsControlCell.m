//
//  KPCTabsControlCell.m
//  KPCTabsControl
//
//  Created by Christian Tietze on 27/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

#import "KPCTabsControlConstants.h"
#import "KPCTabsControlCell.h"
#import "NSColor+KPCTabsControl.h"
#import "KPCTabButton.h" // to obtain KPCRectArrayWithBorderMask

@implementation KPCTabsControlCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBordered:YES];
        [self setBackgroundStyle:NSBackgroundStyleLight];
        [self setFocusRingType:NSFocusRingTypeNone];
        [self setEnabled:NO];

        _tabBorderColor = [NSColor KPC_defaultTabBorderColor];
        _tabBackgroundColor = [NSColor KPC_defaultTabBackgroundColor];
        _tabHighlightedBackgroundColor = [NSColor KPC_defaultTabHighlightedBackgroundColor];
    }
    return self;
}

- (void)highlight:(BOOL)flag
{
    self.highlighted = flag;
    [self.controlView setNeedsDisplay:YES];
}

- (NSSize)cellSizeForBounds:(NSRect)aRect
{
    return NSMakeSize(36, 0);
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (self.isHighlighted) {
        [self.tabHighlightedBackgroundColor setFill];
    }
    else {
        [self.tabBackgroundColor setFill];
    }

    NSRectFill(cellFrame);

    NSRect *borderRects;
    NSInteger borderRectCount;

    if (KPCRectArrayWithBorderMask(cellFrame, self.borderMask, &borderRects, &borderRectCount)) {

        [self.tabBorderColor setFill];
        [self.tabBorderColor set];
        NSRectFillList(borderRects, borderRectCount);
    }
}
@end
