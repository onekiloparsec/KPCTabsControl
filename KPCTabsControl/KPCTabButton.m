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
@end

@implementation KPCTabButton

+ (Class)cellClass
{
    return [KPCTabButtonCell class];
}

- (void)setIcon:(NSImage *)icon
{
    _icon = icon;
    
    if (icon && !self.iconView) {
        self.iconView = [[NSImageView alloc] initWithFrame:CGRectMake(10.0, 0.0, 20.0, 20.0)];
        [self.iconView setImageFrameStyle:NSImageFrameNone];
        [self.iconView setImage:icon];
        [self addSubview:self.iconView];
    }
    else if (!icon && self.iconView) {
        [self.iconView removeFromSuperview];
        self.iconView = nil;
    }
}

- (void)setCell:(NSCell *)cell
{
    [super setCell:cell];
    if ([cell isKindOfClass:[KPCTabButtonCell class]]) {
        [self constrainSizeWithCell:(id)cell];
    }
}

- (void)constrainSizeWithCell:(KPCTabButtonCell *)cell
{
//    if (_minWidthConstraint != nil) {
//        if (cell.minWidth > 0) {
//            [_minWidthConstraint setConstant:cell.minWidth];
//        } else {
//            [self removeConstraint:_minWidthConstraint];
//            _minWidthConstraint = nil;
//        }
//    } else {
//        if (cell.minWidth > 0) {
//            _minWidthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
//                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                                                  toItem:nil attribute:NSLayoutAttributeNotAnAttribute
//                                                              multiplier:1 constant:cell.minWidth];
//            [self addConstraint:_minWidthConstraint];
//        }
//    }
//    
//    if (_maxWidthConstraint != nil) {
//        if (cell.maxWidth > 0) {
//            [_maxWidthConstraint setConstant:cell.maxWidth];
//        } else {
//            [self removeConstraint:_maxWidthConstraint];
//            _maxWidthConstraint = nil;
//        }
//    } else {
//        if (cell.maxWidth > 0) {
//            _maxWidthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
//                                                               relatedBy:NSLayoutRelationLessThanOrEqual
//                                                                  toItem:nil attribute:NSLayoutAttributeNotAnAttribute
//                                                              multiplier:1 constant:cell.maxWidth];
//            [self addConstraint:_maxWidthConstraint];
//        }
//    }
}

- (void)resetCursorRects
{
    [self addCursorRect:[self bounds] cursor:[NSCursor arrowCursor]];
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

- (BOOL)isShowingMenu
{
    return [self.cell isShowingMenu];
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

- (CGFloat)minWidth
{
    return [self.cell minWidth];
}

- (void)setMinWidth:(CGFloat)minWidth
{
    [self.cell setMinWidth:minWidth];
}

- (CGFloat)maxWidth
{
    return [self.cell maxWidth];
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
    [self.cell setMaxWidth:maxWidth];
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
