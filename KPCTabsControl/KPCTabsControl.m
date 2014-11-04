//
//  KPCTabsControl.m
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KPCTabsControl.h"
#import "KPCTabButton.h"
#import "KPCTabButtonCell.h"
#import "KPCTabsControlConstants.h"
#import "NSButton+KPCTabsControl.h"


@interface KPCTabsControl () <NSTextFieldDelegate>
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) NSScrollView *scrollView;
@property(nonatomic, strong) NSView *tabsView;
@property(nonatomic, strong) NSButton *addButton, *scrollLeftButton, *scrollRightButton, *draggingTab;
@property(nonatomic, strong) NSTextField *editingField;
@property(nonatomic, assign) BOOL hideScrollButtons;
@property(nonatomic, assign) BOOL isHighlighted;
@end

@implementation KPCTabsControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
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

- (void)setup
{
    [self setWantsLayer:YES];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self setCell:[[KPCTabButtonCell alloc] initTextCell:@""]];
    [self.cell setBorderMask:KPCBorderMaskBottom];
    [self.cell setFont:[NSFont fontWithName:@"HelveticaNeue-Medium" size:13]];

	self.minTabWidth = 50.0;
	self.maxTabWidth = 150.0;

    [self highlight:NO];
    [self configureSubviews];
}

- (void)configureSubviews
{
    if (self.scrollView) {
        return;
    }
    
    self.scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
    [self.scrollView setDrawsBackground:NO];
    [self.scrollView setHasHorizontalScroller:NO];
    [self.scrollView setHasVerticalScroller:NO];
    [self.scrollView setUsesPredominantAxisScrolling:YES];
    [self.scrollView setHorizontalScrollElasticity:NSScrollElasticityAllowed];
    [self.scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
    [self.scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.tabsView = [[NSView alloc] initWithFrame:self.scrollView.bounds];
    self.scrollView.documentView = self.tabsView;
    
    [self addSubview:self.scrollView];

    self.addButton = [NSButton auxiliaryButtonWithImageNamed:@"KPCTabPlusTemplate" target:self action:@selector(add:)];
    [self.addButton.cell setBorderMask:[self.addButton.cell borderMask] | KPCBorderMaskRight];

    if (!self.hideScrollButtons) {
        self.scrollLeftButton  = [NSButton auxiliaryButtonWithImageNamed:@"KPCTabLeftTemplate" target:self action:@selector(scrollLeft:)];
        self.scrollRightButton = [NSButton auxiliaryButtonWithImageNamed:@"KPCTabRightTemplate" target:self action:@selector(scrollRight:)];
        
        [self.scrollLeftButton setContinuous:YES];
        [self.scrollRightButton setContinuous:YES];
        
        [self.scrollLeftButton.cell sendActionOn:NSLeftMouseDownMask|NSPeriodicMask];
        [self.scrollRightButton.cell sendActionOn:NSLeftMouseDownMask|NSPeriodicMask];
        
        self.scrollLeftButton.autoresizingMask = NSViewMinXMargin;
        self.scrollRightButton.autoresizingMask = NSViewMinXMargin;
        
        [self.scrollLeftButton.cell setBorderMask:[self.scrollLeftButton.cell borderMask] | KPCBorderMaskLeft];

        [self addSubview:self.scrollLeftButton];
        [self addSubview:self.scrollRightButton];
        
        // This is typically what's autolayout is supposed to avoid.
        // But for pixel-control freaking guys like me, I see no escape.
        CGRect r = CGRectZero;
        r.size.height = CGRectGetHeight(self.scrollView.frame);
        r.size.width = CGRectGetWidth(self.scrollLeftButton.frame) + 2.0;
        r.origin.x = CGRectGetMaxX(self.scrollView.frame) - r.size.width;
        self.scrollRightButton.frame = r;
        r.origin.x -= r.size.width + 2.0;
        self.scrollLeftButton.frame = r;
    }
    
    [self startObservingScrollView];
    [self updateAuxiliaryButtons];
}

- (void)dealloc
{
    [self stopObservingScrollView];
}

#pragma mark - Data Source

- (void)setDataSource:(id<KPCTabsControlDataSource>)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(tabsControlDidChangeSelection:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:_dataSource
                                                        name:KPCTabsControlSelectionDidChangeNotification
                                                      object:self];
    }
    
    _dataSource = dataSource;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(tabsControlDidChangeSelection:)])
        [[NSNotificationCenter defaultCenter] addObserver:_dataSource
                                                 selector:@selector(tabsControlDidChangeSelection:)
                                                     name:KPCTabsControlSelectionDidChangeNotification
                                                   object:self];
    
    [self reloadData];
}

- (void)reloadData
{
    [self.tabsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0, count = [self.dataSource tabsControlNumberOfTabs:self]; i < count; i++) {
        [newItems addObject:[self.dataSource tabsControl:self itemAtIndex:i]];
    }
    
    for (NSUInteger i = 0; i < newItems.count; i++) {
        id item = newItems[i];
        
        KPCTabButton *button = [NSButton tabButtonWithItem:item target:self action:@selector(selectTab:)];
        [button setTitle:[self.dataSource tabsControl:self titleForItem:item]];
        
        if ([self.dataSource respondsToSelector:@selector(tabsControl:menuForItem:)]) {
            NSMenu *menu = [self.dataSource tabsControl:self menuForItem:item];
            if (menu) {
                [button useMenu:menu];
            }
        }
        
        [self.tabsView addSubview:button];
    }

	[self layoutTabButtons:nil animated:NO];
    [self updateAuxiliaryButtons];
    [self invalidateRestorableState];
}

- (void)layoutTabButtons:(NSArray *)buttons animated:(BOOL)anim
{
	__block CGFloat tabsViewWidth = 0.0;

	if (!buttons) {
		buttons = self.tabsView.subviews;
	}

	[buttons enumerateObjectsUsingBlock:^(KPCTabButton *button, NSUInteger idx, BOOL *stop) {

		CGFloat fullSizeWidth = CGRectGetWidth(self.scrollView.frame) / self.tabsView.subviews.count;
		CGFloat buttonWidth = (self.preferFullWidthTabs) ? fullSizeWidth : MIN(self.maxTabWidth, fullSizeWidth);
		buttonWidth = MAX(buttonWidth, self.minTabWidth);
		CGRect r = CGRectMake(idx*buttonWidth, 0, buttonWidth, CGRectGetHeight(self.tabsView.frame));

		// Don't animate if it is hidden, as it will screw order of tabs
		if (anim && ![button isHidden]) {
			[[button animator] setFrame:r];
		}
		else {
			[button setFrame:r];
		}

		if ([self.dataSource respondsToSelector:@selector(tabsControl:canSelectItem:)]) {
			[[button cell] setSelectable:[self.dataSource tabsControl:self canSelectItem:[button.cell representedObject]]];
		}

		if ([self.dataSource respondsToSelector:@selector(tabsControl:willDisplayButton:forItem:)]) {
			[self.dataSource tabsControl:self willDisplayButton:button forItem:[button.cell representedObject]];
		}

		tabsViewWidth += CGRectGetWidth(button.frame);
	}];

	self.tabsView.frame = CGRectMake(0.0, 0.0, tabsViewWidth, CGRectGetHeight(self.scrollView.frame));
}

- (void)updateAuxiliaryButtons
{
    [self.addButton setHidden:(self.addAction == NULL)];

    NSClipView *contentView = self.scrollView.contentView;
    BOOL isDocumentClipped = (contentView.subviews.count > 0) && (NSMaxX([contentView.subviews[0] frame]) > NSWidth(contentView.bounds));

    if (isDocumentClipped) {
        [self.scrollLeftButton  setHidden:NO];
        [self.scrollRightButton setHidden:NO];

        [self.scrollLeftButton setEnabled:([self firstTabLeftOutsideVisibleRect] != nil)];
        [self.scrollRightButton setEnabled:([self firstTabRightOutsideVisibleRect] != nil)];
    }
	else {
        [self.scrollLeftButton  setHidden:YES];
        [self.scrollRightButton setHidden:YES];
    }
}


#pragma mark - ScrollView Observation

static char KPCScrollViewObservationContext;

- (void)startObservingScrollView
{
    [self.scrollView addObserver:self forKeyPath:@"frame" options:0 context:&KPCScrollViewObservationContext];
    [self.scrollView addObserver:self forKeyPath:@"documentView.frame" options:0 context:&KPCScrollViewObservationContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollViewDidScroll:)
                                                 name:NSViewFrameDidChangeNotification
                                               object:self.scrollView];
}

- (void)stopObservingScrollView
{
    [self.scrollView removeObserver:self forKeyPath:@"frame" context:&KPCScrollViewObservationContext];
    [self.scrollView removeObserver:self forKeyPath:@"documentView.frame" context:&KPCScrollViewObservationContext];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSViewFrameDidChangeNotification
                                                  object:self.scrollView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &KPCScrollViewObservationContext) {
        [self updateAuxiliaryButtons];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollViewDidScroll:(NSNotification *)notification
{
	[self layoutTabButtons:nil animated:NO];
    [self updateAuxiliaryButtons];
    [self invalidateRestorableState];
}

#pragma mark - Actions

//- (void)setAddAction:(SEL)addAction {
//    if (_addAction != addAction) {
//        _addAction = addAction;
//        
//        [self updateAuxiliaryButtons];
//    }
//}
//
//- (void)add:(id)sender {
//    [[NSApplication sharedApplication] sendAction:self.addAction to:self.addTarget from:self];
//    
//    [self invalidateRestorableState];
//}

- (void)scrollLeft:(id)sender
{
    NSButton *tab = [self firstTabLeftOutsideVisibleRect];
    
    if (tab != nil) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setAllowsImplicitAnimation:YES];
            [tab scrollRectToVisible:[tab bounds]];
        } completionHandler:^{
			[self invalidateRestorableState];
		}];
    }
}

- (NSButton *)firstTabLeftOutsideVisibleRect
{
    NSRect visibleRect = self.tabsView.visibleRect;
    
    for (NSButton *button in self.tabsView.subviews) {
        if (NSMinX(button.frame) < NSMinX(visibleRect)) {
            return button;
        }
    }
    return nil;
}

- (void)scrollRight:(id)sender
{
    NSButton *tab = [self firstTabRightOutsideVisibleRect];
    
    if (tab != nil) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setAllowsImplicitAnimation:YES];
            [tab scrollRectToVisible:[tab bounds]];
        } completionHandler:^{
			[self invalidateRestorableState];
		}];
    }
}

- (NSButton *)firstTabRightOutsideVisibleRect
{
	NSRect visibleRect = self.tabsView.visibleRect;

    for (NSButton *button in [self.tabsView subviews]) {
        if (NSMaxX(button.frame) > NSMaxX(visibleRect)) {
            return button;
        }
    }
    return nil;
}

- (void)selectTab:(id)sender
{
    NSButton *selectedButton = sender;
    
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        [button setState:(button == selectedButton) ? NSOnState : NSOffState];
    }
    
    [[NSApplication sharedApplication] sendAction:self.action to:self.target from:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:KPCTabsControlSelectionDidChangeNotification object:self];
    
    NSEvent *currentEvent = [NSApp currentEvent];
    
    if (currentEvent.clickCount > 1) { // edit on double click...
        [self editItem:[[sender cell] representedObject]];
    }
	// watch for a drag event and initiate dragging if a drag is found...
	else if ([self.dataSource respondsToSelector:@selector(tabsControl:canReorderItem:)]) {
		if ([self.dataSource tabsControl:self canReorderItem:[[sender cell] representedObject]]) {
		NSEvent *event = [self.window nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask
												  untilDate:[NSDate distantFuture]
													 inMode:NSEventTrackingRunLoopMode
													dequeue:NO];

			if (event.type == NSLeftMouseDragged) {
				[self reorderTab:sender withEvent:currentEvent];
				return; // no autoscroll
			}
		}
    }
    
    // scroll to visible if either editing or selecting...
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setAllowsImplicitAnimation:YES];
        [selectedButton.superview scrollRectToVisible:selectedButton.frame];
    } completionHandler:nil];
    
    [self invalidateRestorableState];
}

#pragma mark -
#pragma mark - Reordering

- (void)reorderTab:(KPCTabButton *)tab withEvent:(NSEvent *)event
{
    NSMutableArray *orderedTabs = [[NSMutableArray alloc] initWithArray:self.tabsView.subviews.objectEnumerator.allObjects];

    CGFloat tabX = NSMinX(tab.frame);
    NSPoint dragPoint = [self.tabsView convertPoint:event.locationInWindow fromView:nil];

	KPCTabButton *draggingTab = [[KPCTabButton alloc] initWithFrame:tab.frame];
	KPCTabButtonCell *draggingTabCell = [tab.cell copy];
	draggingTabCell.borderMask = draggingTabCell.borderMask | KPCBorderMaskLeft | KPCBorderMaskRight;
	draggingTab.cell = draggingTabCell;

	[draggingTab.cell setRepresentedObject:[tab.cell representedObject]];
	[draggingTab setIcon:[tab icon]];
	if ([tab.cell menu] != nil) {
		[draggingTab.cell setMenu:[[NSMenu alloc] init]];
	}

	[self addSubview:draggingTab];
    [tab setHidden:YES];

    CGPoint prevPoint = dragPoint;
    BOOL reordered = NO;
    
    while (1) {
        event = [self.window nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
        
		if (event.type == NSLeftMouseUp) {
			[[NSAnimationContext currentContext] setCompletionHandler:^{
				[draggingTab removeFromSuperview];
				[tab setHidden:NO];
				if (reordered && [self.dataSource respondsToSelector:@selector(tabsControl:didReorderItems:)]) {
					[self.dataSource tabsControl:self didReorderItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
				}
				[self reloadData]; // That's the delegate responsability to store new order of items.
			}];
			[[draggingTab animator] setFrame:tab.frame];
			break;
		};

        NSPoint nextPoint = [self.tabsView convertPoint:event.locationInWindow fromView:nil];
        CGFloat nextX = tabX + (nextPoint.x - dragPoint.x);

		CGRect r = draggingTab.frame;
		r.origin.x = nextX;
		draggingTab.frame = r;
        
        BOOL movingLeft = (nextPoint.x < prevPoint.x);
        BOOL movingRight = (nextPoint.x > prevPoint.x);
        
        prevPoint = nextPoint;

        if (movingLeft && NSMidX(draggingTab.frame) < NSMinX(tab.frame) && tab != orderedTabs.firstObject) {
            // shift left
			NSUInteger index = [orderedTabs indexOfObject:tab];
            [orderedTabs exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
			[self layoutTabButtons:orderedTabs animated:YES];
            reordered = YES;
        }
		else if (movingRight && NSMidX(draggingTab.frame) > NSMaxX(tab.frame) && tab != orderedTabs.lastObject) {
            // shift right
            NSUInteger index = [orderedTabs indexOfObject:tab];
            [orderedTabs exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
			[self layoutTabButtons:orderedTabs animated:YES];
            reordered = YES;
        }
    }
}


#pragma mark - Selection

- (id)selectedItem
{
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if ([button state] == NSOnState) {
            return [[button cell] representedObject];
        }
    }
    return nil;
}

- (void)setSelectedItem:(id)selectedItem
{
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if ([[[button cell] representedObject] isEqual:selectedItem]) {
            [button setState:NSOnState];
            
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setAllowsImplicitAnimation:YES];
                [button scrollRectToVisible:[button bounds]];
            } completionHandler:nil];
        }
		else {
            [button setState:NSOffState];
        }
    }
    
    [self invalidateRestorableState];
}

#pragma mark -
#pragma mark Editing

- (void)editItem:(id)item
{
//    NSButton *button = [self tabButtonWithItem:item];
//    
//    // end existing editing, if any...
//    if (self.editingField != nil) {
//        [self.window makeFirstResponder:self];
//    }
//    
//    // layout items if necessary
//    [self layoutSubtreeIfNeeded];
//    
//    if (button != nil) {
//        if ([self.dataSource respondsToSelector:@selector(tabControl:canEditItem:)] && [self.dataSource tabControl:self canEditItem:item] == NO) {
//            return;
//        }
//        
//        KPCTabButtonCell *cell = button.cell;
//        NSRect titleRect = [cell editingRectForBounds:button.bounds];
//        
//        self.editingField = [[NSTextField alloc] initWithFrame:titleRect];
//        
//        self.editingField.editable = YES;
//        self.editingField.font = cell.font;
//        self.editingField.alignment = cell.alignment;
//        self.editingField.backgroundColor = cell.backgroundColor;
//        self.editingField.focusRingType = NSFocusRingTypeNone;
//        
//        self.editingField.textColor = [[NSColor darkGrayColor] blendedColorWithFraction:0.5 ofColor:[NSColor blackColor]];
//        
//        NSTextFieldCell *textFieldCell = self.editingField.cell;
//        
//        [textFieldCell setBordered:NO];
//        [textFieldCell setScrollable:YES];
//        
//        self.editingField.stringValue = button.title;
//        
//        [button addSubview:self.editingField];
//        
//        self.editingField.delegate = self;
//        [self.editingField selectText:self];
//    }
}


#pragma mark - NSTextFieldDelegate

//- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
//{
//    BOOL ret = YES;
//    if ([_delegate respondsToSelector:_cmd]) {
//        ret = [_delegate control:self textShouldBeginEditing:fieldEditor];
//    }
//    return ret;
//}
//
//- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
//    BOOL ret = YES;
//    if ([_delegate respondsToSelector:_cmd]) {
//        ret = [_delegate control:self textShouldEndEditing:fieldEditor];
//    }
//    return ret;
//}
//
//- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error {
//    BOOL ret = YES;
//    if ([_delegate respondsToSelector:_cmd]) {
//        ret = [_delegate control:self didFailToFormatString:string errorDescription:error];
//    }
//    return ret;
//}
//
//- (void)control:(NSControl *)control didFailToValidatePartialString:(NSString *)string errorDescription:(NSString *)error {
//    if ([_delegate respondsToSelector:_cmd]) {
//        [_delegate control:self didFailToValidatePartialString:string errorDescription:error];
//    }
//}
//
//- (BOOL)control:(NSControl *)control isValidObject:(id)obj {
//    BOOL ret = YES;
//    if ([_delegate respondsToSelector:_cmd]) {
//        ret = [_delegate control:self isValidObject:obj];
//    }
//    return ret;
//}
//
//- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
//    BOOL ret = NO;
//    if ([_delegate respondsToSelector:_cmd]) {
//        ret = [_delegate control:self textView:textView doCommandBySelector:commandSelector];
//    }
//    return ret;
//}
//
//- (NSArray *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
//    NSArray *ret = nil;
//    if ([_delegate respondsToSelector:_cmd]) {
//        
//    }
//    return ret;
//}
//
//- (void)controlTextDidChange:(NSNotification *)obj {
//    [[NSNotificationCenter defaultCenter] postNotificationName:obj.name object:self userInfo:obj.userInfo];
//}
//
//- (void)controlTextDidBeginEditing:(NSNotification *)obj {
//    [[NSNotificationCenter defaultCenter] postNotificationName:obj.name object:self userInfo:obj.userInfo];
//}
//
//- (void)controlTextDidEndEditing:(NSNotification *)obj {
//    NSString *title = self.editingField.stringValue;
//    NSButton *button = (id)[self.editingField superview];
//    
//    self.editingField.delegate = nil;
//    [self.editingField removeFromSuperview];
//    self.editingField = nil;
//    
//    if (title.length > 0) {
//        [button setTitle:title];
//        
//        [self.dataSource tabControl:self setTitle:title forItem:[button.cell representedObject]];
//    }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:obj.name object:self userInfo:obj.userInfo];
//}


#pragma mark - Drawing

- (BOOL)isOpaque
{
    return YES;
}
- (BOOL)isFlipped
{
    return YES;
}

- (void)highlight:(BOOL)flag
{
    self.isHighlighted = flag;
    NSColor *color = [NSColor colorWithCalibratedWhite:(flag) ? 0.85 : 0.95 alpha:1.0];
    [self setBackgroundColor:color];
    [[self.scrollView.documentView subviews] makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:color];
}

#pragma mark - State Restoration

// NOTE: to enable state restoration, be sure to either assign an identifier to
// the LITabControl instance within IB or, if the control is created programmatically,
// prior to adding it to your window's view hierarchy.

#define kScrollXOffsetKey @"scrollOrigin"
#define kSelectedButtonIndexKey @"selectedButtonIndex"


- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    CGFloat scrollXOffset = 0;
    NSUInteger selectedButtonIndex = NSNotFound;
    
    scrollXOffset = self.scrollView.contentView.bounds.origin.x;
    
    NSUInteger index = 0;
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if (button.state == 1) {
            selectedButtonIndex = index;
            break;
        }
        index += 1;
    }
    
    [coder encodeDouble:scrollXOffset forKey:kScrollXOffsetKey];
    [coder encodeInteger:selectedButtonIndex forKey:kSelectedButtonIndexKey];
}

- (void)restoreStateWithCoder:(NSCoder *)coder
{
    [super restoreStateWithCoder:coder];
    
    CGFloat scrollXOffset = [coder decodeDoubleForKey:kScrollXOffsetKey];
    NSUInteger selectedButtonIndex = [coder decodeIntegerForKey:kSelectedButtonIndexKey];
    
    NSRect bounds = self.scrollView.contentView.bounds; bounds.origin.x = scrollXOffset;
    self.scrollView.contentView.bounds = bounds;
    
    NSUInteger index = 0;
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        [button setState:(index == selectedButtonIndex) ? NSOnState : NSOffState];
        index += 1;
    }
}

#pragma mark - Properties

- (CGFloat)currentTabWidth
{
	if (self.tabsView.subviews.count > 0) {
		return CGRectGetWidth([self.tabsView.subviews[0] frame]);
	}
	return 0.0;
}

- (void)setMinTabWidth:(CGFloat)minTabWidth
{
	_minTabWidth = minTabWidth;
	[self layoutTabButtons:nil animated:NO];
	[self updateAuxiliaryButtons];
}

- (void)setMaxTabWidth:(CGFloat)maxTabWidth
{
	if (maxTabWidth <= self.minTabWidth) {
		[NSException raise:NSInvalidArgumentException
					format:@"Max width '%.1f' must be larger than min width (%.1f)!", maxTabWidth, self.minTabWidth];
	}
	_maxTabWidth = maxTabWidth;
	[self layoutTabButtons:nil animated:NO];
	[self updateAuxiliaryButtons];
}

- (void)setBorderColor:(NSColor *)borderColor
{
    [self.cell setBorderColor:borderColor];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(setBorderColor:) withObject:borderColor];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    [self.cell setBackgroundColor:backgroundColor];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:backgroundColor];
}

- (void)setTitleColor:(NSColor *)titleColor
{
    [self.cell setTitleColor:titleColor];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(setTitleColor:) withObject:titleColor];
}

- (void)setTitleHighlightColor:(NSColor *)titleHighlightColor
{
    [self.cell setTitleHighlightColor:titleHighlightColor];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(setTitleHighlightColor:) withObject:titleHighlightColor];
}

@end

