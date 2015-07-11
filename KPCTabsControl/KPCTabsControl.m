//
//  KPCTabsControl.m
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 28/10/14.
//  Copyright (c) 2014 @onekiloparsec (Cédric Foellmi). All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KPCTabsControlConstants.h"
#import "KPCTabsControl.h"
#import "KPCTabButton.h"
#import "KPCTabButtonCell.h"
#import "NSButton+KPCTabsControl.h"
#import "NSColor+KPCTabsControl.h"
#import "KPCMessageInterceptor.h"

@interface KPCTabsControl () <NSTextFieldDelegate>
@property(nonatomic, strong) KPCMessageInterceptor *delegateInterceptor;

@property(nonatomic, strong) NSScrollView *scrollView;
@property(nonatomic, strong) NSView *tabsView;

@property(nonatomic, strong) NSButton *addButton;
@property(nonatomic, strong) NSButton *scrollLeftButton;
@property(nonatomic, strong) NSButton *scrollRightButton;

@property(nonatomic, strong) NSTextField *editingTextField;

@property(nonatomic, assign) BOOL hideScrollButtons;
@property(nonatomic, assign) BOOL isHighlighted;

@property(nonatomic, weak) NSButton *selectedButton;
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

- (instancetype)initWithFrame:(NSRect)frame
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
    [self.cell setFont:[NSFont fontWithName:@"HelveticaNeue-Medium" size:13]];

    self.controlBorderColor = [NSColor KPC_defaultControlBorderColor];
    self.controlBackgroundColor = [NSColor KPC_defaultControlBackgroundColor];
    self.controlHighlightedBackgroundColor = [NSColor KPC_defaultControlHighlightedBackgroundColor];
    
    self.tabBorderColor = [NSColor KPC_defaultTabBorderColor];
    self.tabTitleColor = [NSColor KPC_defaultTabTitleColor];
    self.tabBackgroundColor = [NSColor KPC_defaultTabBackgroundColor];
    self.tabHighlightedBackgroundColor = [NSColor KPC_defaultTabHighlightedBackgroundColor];
    
    self.tabSelectedBorderColor = [NSColor KPC_defaultTabSelectedBorderColor];
    self.tabSelectedTitleColor = [NSColor KPC_defaultTabSelectedTitleColor];
    self.tabSelectedBackgroundColor = [NSColor KPC_defaultTabSelectedBackgroundColor];

	self.minTabWidth = 50.0;
	self.maxTabWidth = 150.0;
    
    self.automaticSideBorderMasks = YES;
    
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

    self.addButton = [NSButton KPC_auxiliaryButtonWithImageNamed:@"KPCTabPlusTemplate" target:self action:@selector(add:)];
    [self.addButton.cell setBorderMask:[self.addButton.cell borderMask] | KPCBorderMaskRight];

    if (!self.hideScrollButtons) {
        self.scrollLeftButton = [NSButton KPC_auxiliaryButtonWithImageNamed:@"KPCTabLeftTemplate" target:self action:@selector(scrollLeft:)];
        self.scrollRightButton = [NSButton KPC_auxiliaryButtonWithImageNamed:@"KPCTabRightTemplate" target:self action:@selector(scrollRight:)];
                
        self.scrollLeftButton.autoresizingMask = NSViewMinXMargin;
        self.scrollRightButton.autoresizingMask = NSViewMinXMargin;
        
        [self.scrollLeftButton.cell setBorderMask:[self.scrollLeftButton.cell borderMask] | KPCBorderMaskLeft];

        [self addSubview:self.scrollLeftButton];
        [self addSubview:self.scrollRightButton];
        
        // This is typically what's autolayout is supposed to help avoiding.
        // But for pixel-control freaking guys like me, I see no escape.
        CGRect r = CGRectZero;
        r.size.height = CGRectGetHeight(self.scrollView.frame);
        r.size.width = CGRectGetWidth(self.scrollLeftButton.frame);
        r.origin.x = CGRectGetMaxX(self.scrollView.frame) - r.size.width;
        self.scrollRightButton.frame = r;
        r.origin.x -= r.size.width;
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
    
    _dataSource = dataSource;
    [self reloadTabs];
}

- (void)reloadTabs
{
    id selectedItem = [self selectedItem];
    [[self tabButtons] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0, count = [self.dataSource tabsControlNumberOfTabs:self]; i < count; i++) {
        [newItems addObject:[self.dataSource tabsControl:self itemAtIndex:i]];
    }
    
    for (NSUInteger i = 0; i < newItems.count; i++) {
        id item = newItems[i];
        
        KPCTabButton *button = [NSButton KPC_tabButtonWithItem:item target:self action:@selector(selectTab:)];
        
        KPCBorderMask mask = [self.cell borderMask];
        if (i == 0 && self.automaticSideBorderMasks) {
            mask |= KPCBorderMaskLeft;
        }
        if (i == newItems.count-1 && self.automaticSideBorderMasks) {
            mask |= KPCBorderMaskRight;
        }
        [button.cell setBorderMask:[self.cell borderMask]];
        
        [button setTitle:[self.dataSource tabsControl:self titleForItem:item]];
        [button setState:(item == selectedItem) ? NSOnState : NSOffState];
        [button highlight:self.isHighlighted];
        
        if ([self.dataSource respondsToSelector:@selector(tabsControl:iconForItem:)]) {
            [button setIcon:[self.dataSource tabsControl:self iconForItem:item]];
        }
        
        if ([self.dataSource respondsToSelector:@selector(tabsControl:menuForItem:)]) {
            [button setMenu:[self.dataSource tabsControl:self menuForItem:item]];
        }
        
        if ([self.dataSource respondsToSelector:@selector(tabsControl:titleAlternativeIconForItem:)]) {
            [button setAlternativeTitleIcon:[self.dataSource tabsControl:self titleAlternativeIconForItem:item]];
        }
        
        [self.tabsView addSubview:button];
    }

	[self layoutTabButtons:nil animated:NO];
    [self updateAuxiliaryButtons];
    [self invalidateRestorableState];
}

- (void)layoutTabButtons:(NSArray *)buttons animated:(BOOL)anim
{
	if (!buttons) {
        buttons = [self tabButtons];
	}

    __block CGFloat tabsViewWidth = 0.0;
	[buttons enumerateObjectsUsingBlock:^(KPCTabButton *button, NSUInteger idx, BOOL *stop) {

		CGFloat fullSizeWidth = CGRectGetWidth(self.scrollView.frame) / buttons.count;
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

		if ([self.delegateInterceptor.receiver respondsToSelector:@selector(tabsControl:canSelectItem:)]) {
			[[button cell] setSelectable:[self.delegateInterceptor.receiver tabsControl:self canSelectItem:[button.cell representedObject]]];
		}
        
        button.tag = idx;

		tabsViewWidth += CGRectGetWidth(button.frame);
	}];

	self.tabsView.frame = CGRectMake(0.0, 0.0, tabsViewWidth, CGRectGetHeight(self.scrollView.frame));
}

- (void)updateAuxiliaryButtons
{
    NSClipView *contentView = self.scrollView.contentView;
    BOOL showScrollButtons = (contentView.subviews.count > 0) && (NSMaxX([contentView.subviews[0] frame]) > NSWidth(contentView.bounds));
    showScrollButtons |= (self.preferFullWidthTabs && [self currentTabWidth] == [self minTabWidth]);
    
    if (showScrollButtons) {
        [self.scrollLeftButton  setHidden:NO];
        [self.scrollRightButton setHidden:NO];

        [self.scrollLeftButton  setEnabled:([self firstTabLeftOutsideVisibleRect] != nil)];
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
    
    for (NSButton *button in [self tabButtons]) {
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

    for (NSButton *button in [self tabButtons]) {
        if (NSMaxX(button.frame) > NSMaxX(visibleRect) - 2.0*NSWidth(self.scrollLeftButton.frame)) {
            return button;
        }
    }
    return nil;
}

#pragma mark - Reordering

- (void)reorderTab:(KPCTabButton *)tab withEvent:(NSEvent *)event
{
    NSMutableArray *orderedTabs = [[NSMutableArray alloc] initWithArray:[self tabButtons]];

    CGFloat tabX = NSMinX(tab.frame);
    NSPoint dragPoint = [self.tabsView convertPoint:event.locationInWindow fromView:nil];

    KPCTabButton *draggingTab = [tab copy];
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
				if (reordered && [self.delegateInterceptor.receiver respondsToSelector:@selector(tabsControl:didReorderItems:)]) {
					[self.delegateInterceptor.receiver tabsControl:self didReorderItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
				}
				[self reloadTabs]; // That's the delegate responsability to store new order of items.
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

- (void)selectTab:(id)sender
{
    self.selectedButton = sender;
    
    for (KPCTabButton *button in [self tabButtons]) {
        [button setState:(button == self.selectedButton) ? NSOnState : NSOffState];
        [button highlight:self.isHighlighted];
    }
    
    [[NSApplication sharedApplication] sendAction:self.action to:self.target from:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:KPCTabsControlSelectionDidChangeNotification object:self];
    
    NSEvent *currentEvent = [NSApp currentEvent];
    
    if (currentEvent.type == NSLeftMouseUp && currentEvent.clickCount > 1) { // edit on double click...
        [self editTabButton:sender];
    }
    // watch for a drag event and initiate dragging if a drag is found...
    else if ([self.delegateInterceptor.receiver respondsToSelector:@selector(tabsControl:canReorderItem:)]) {
        if ([self.delegateInterceptor.receiver tabsControl:self canReorderItem:[[sender cell] representedObject]]) {
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
        [self.selectedButton.superview scrollRectToVisible:self.selectedButton.frame];
    } completionHandler:nil];
    
    [self invalidateRestorableState];
    
    if ([self.delegate respondsToSelector:@selector(tabsControlDidChangeSelection:)]) {
        NSNotification *n = [NSNotification notificationWithName:KPCTabsControlSelectionDidChangeNotification object:self];
        [self.delegate performSelector:@selector(tabsControlDidChangeSelection:) withObject:n];
    }
}

- (id)selectedItem
{
    return [[self.selectedButton cell] representedObject];
}

- (void)setSelectedItem:(id)selectedItem
{
    _selectedButton = nil;

    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if ([[[button cell] representedObject] isEqual:selectedItem]) {
            [button setState:NSOnState];
            _selectedButton = button;
            
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setAllowsImplicitAnimation:YES];
                [button scrollRectToVisible:[button bounds]];
            } completionHandler:nil];
        }
		else {
            [button setState:NSOffState];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KPCTabsControlSelectionDidChangeNotification object:self];
    [self invalidateRestorableState];
}

- (NSInteger)selectedItemIndex
{
    return (self.selectedButton) ? [self.selectedButton tag] : -1;
}

- (void)selectItemAtIndex:(NSInteger)index
{
    NSButton *sender = nil;
    for (NSButton *button in [self.scrollView.documentView subviews]) {
        if (button.tag == index) {
            sender = button;
            break;
        }
    }
    
    [self selectTab:sender];
}

#pragma mark - Editing

- (void)editTabButton:(KPCTabButton *)tab
{
    if (!tab) {
        return;
    }
    
    if ([self.delegateInterceptor.receiver respondsToSelector:@selector(tabsControl:canEditTitleOfItem:)] &&
        ![self.delegateInterceptor.receiver tabsControl:self canEditTitleOfItem:tab.cell.representedObject])
    {
        return;
    }
    
    // End existing editing, if any...
    if (self.editingTextField != nil) {
        [self.window makeFirstResponder:self];
    }
    
    NSRect titleRect = [tab.cell editingRectForBounds:tab.bounds];
    self.editingTextField = [[NSTextField alloc] initWithFrame:titleRect];
    self.editingTextField.autoresizingMask = NSViewWidthSizable;
    self.editingTextField.editable = YES;
    self.editingTextField.font = tab.cell.font;
    self.editingTextField.alignment = tab.cell.alignment;
    self.editingTextField.backgroundColor = [NSColor clearColor];
    self.editingTextField.focusRingType = NSFocusRingTypeNone;
    self.editingTextField.textColor = [[NSColor darkGrayColor] blendedColorWithFraction:0.5 ofColor:[NSColor blackColor]];
    self.editingTextField.stringValue = tab.title;

    [self.editingTextField.cell setBordered:NO];
    [self.editingTextField.cell setScrollable:YES];
    
    [tab setTitle:@""];
    [tab addSubview:self.editingTextField];
    
    self.delegateInterceptor.middleMan = self;
    self.editingTextField.delegate = (id)self.delegateInterceptor;
    [self.editingTextField selectText:self];
}

- (id<KPCTabsControlDelegate>)delegate
{
    return self.delegateInterceptor.receiver;
}

- (void)setDelegate:(id<KPCTabsControlDelegate>)newDelegate
{    
    if (!self.delegateInterceptor) {
        self.delegateInterceptor = [[KPCMessageInterceptor alloc] init];
    }
    self.delegateInterceptor.receiver = newDelegate;
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    NSString *title = self.editingTextField.stringValue;
    NSButton *button = (id)[self.editingTextField superview];
    
    if (title.length > 0 && [self.delegateInterceptor.receiver respondsToSelector:@selector(tabsControl:setTitle:forItem:)]) {
        [button setTitle:title];
        [self.delegateInterceptor.receiver tabsControl:self setTitle:title forItem:[button.cell representedObject]];
    }
    
    if ([self.delegateInterceptor.receiver respondsToSelector:@selector(controlTextDidEndEditing:)]) {
        [self.delegateInterceptor.receiver controlTextDidEndEditing:obj];
    }

    self.delegateInterceptor.receiver = nil;
    self.editingTextField.delegate = nil;
    [self.editingTextField removeFromSuperview];
    self.editingTextField = nil;
    
    [self reloadTabs]; // That's the receiver responsability to store the new title;
}

#pragma mark - Drawing

- (BOOL)isOpaque
{
    return YES;
}
- (BOOL)isFlipped
{
    return YES;
}

- (NSArray *)tabButtons
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class == %@", [KPCTabButton class]];
    return [self.tabsView.subviews filteredArrayUsingPredicate:predicate];
}

- (void)highlight:(BOOL)flag
{
    self.isHighlighted = flag;
    [self.cell highlight:flag];
    [self.scrollLeftButton.cell highlight:flag];
    [self.scrollRightButton.cell highlight:flag];
    [[self tabButtons] enumerateObjectsUsingBlock:^(KPCTabButton *button, NSUInteger idx, BOOL *stop) {
        [button highlight:flag];
    }];
}

#pragma mark - Border Mask

- (KPCBorderMask)controlBorderMask
{
    return [self.cell borderMask];
}

- (void)setControlBorderMask:(KPCBorderMask)controlBorderMask
{
    [self.cell setBorderMask:controlBorderMask];
    
    NSArray *buttons = [self tabButtons];
    [buttons enumerateObjectsUsingBlock:^(KPCTabButton *button, NSUInteger idx, BOOL *stop) {
        KPCBorderMask mask = controlBorderMask;
        if (idx == 0 && self.automaticSideBorderMasks) {
            mask |= KPCBorderMaskLeft;
        }
        // Not 'else', as one might have only 1 button...
        if (idx == buttons.count-1 && self.automaticSideBorderMasks) {
            mask |= KPCBorderMaskRight;
        }
        [button.cell setBorderMask:controlBorderMask];
    }];
}

#pragma mark - Tab Widths

- (CGFloat)currentTabWidth
{
    NSArray *tabs = [self tabButtons];
	if ([tabs count] > 0) {
		return CGRectGetWidth([tabs[0] frame]);
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

- (void)setPreferFullWidthTabs:(BOOL)preferFullWidthTabs
{
    _preferFullWidthTabs = preferFullWidthTabs;
    [self layoutTabButtons:nil animated:NO];
    [self updateAuxiliaryButtons];
}

#pragma mark - Control Colors

- (NSColor *)controlBorderColor
{
    return [self.cell tabBorderColor];
}

- (void)setControlBorderColor:(NSColor *)controlBorderColor
{
    [self.cell setTabBorderColor:controlBorderColor];
    [self.scrollLeftButton.cell setTabBorderColor:controlBorderColor];
    [self.scrollRightButton.cell setTabBorderColor:controlBorderColor];
    [self setNeedsDisplay];
}

- (NSColor *)controlBackgroundColor
{
    return [self.cell tabBackgroundColor];
}

- (void)setControlBackgroundColor:(NSColor *)controlBackgroundColor
{
    [self.cell setTabBackgroundColor:controlBackgroundColor];
    [self.scrollLeftButton.cell setTabBackgroundColor:controlBackgroundColor];
    [self.scrollRightButton.cell setTabBackgroundColor:controlBackgroundColor];
    [self setNeedsDisplay];
}

- (NSColor *)controlHighlightedBackgroundColor
{
    return [self.cell tabHighlightedBackgroundColor];
}

- (void)setControlHighlightedBackgroundColor:(NSColor *)controlHighlightedBackgroundColor
{
    [self.cell setTabHighlightedBackgroundColor:controlHighlightedBackgroundColor];
    [self.scrollLeftButton.cell setTabHighlightedBackgroundColor:controlHighlightedBackgroundColor];
    [self.scrollRightButton.cell setTabHighlightedBackgroundColor:controlHighlightedBackgroundColor];
    [self setNeedsDisplay];
}

#pragma mark - Tabs Colors

- (NSColor *)tabBorderColor
{
    return [[[[self tabButtons] firstObject] cell] tabBorderColor] ?: [NSColor KPC_defaultTabBorderColor];
}

- (void)setTabBorderColor:(NSColor *)tabBorderColor
{
    [[[self tabButtons] valueForKey:@"cell"] setValue:tabBorderColor forKey:@"tabBorderColor"];
    [self setNeedsDisplay];
}

- (NSColor *)tabTitleColor
{
    return [[[[self tabButtons] firstObject] cell] tabTitleColor] ?: [NSColor KPC_defaultTabTitleColor];
}

- (void)setTabTitleColor:(NSColor *)tabTitleColor
{
    [[[self tabButtons] valueForKey:@"cell"] setValue:tabTitleColor forKey:@"tabTitleColor"];
    [self setNeedsDisplay];
}

- (NSColor *)tabBackgroundColor
{
    return [[[[self tabButtons] firstObject] cell] tabBackgroundColor] ?: [NSColor KPC_defaultTabBackgroundColor];
}

- (void)setTabBackgroundColor:(NSColor *)tabBackgroundColor
{
    [[[self tabButtons] valueForKey:@"cell"] setValue:tabBackgroundColor forKey:@"tabBackgroundColor"];
    [self setNeedsDisplay];
}

- (NSColor *)tabHighlightedBackgroundColor
{
    return [[[[self tabButtons] firstObject] cell] tabHighlightedBackgroundColor] ?: [NSColor KPC_defaultTabHighlightedBackgroundColor];
}

- (void)setTabHighlightedBackgroundColor:(NSColor *)tabHighlightedBackgroundColor
{
    [[[self tabButtons] valueForKey:@"cell"] setValue:tabHighlightedBackgroundColor forKey:@"tabHighlightedBackgroundColor"];
    [self setNeedsDisplay];
}

- (NSColor *)tabSelectedBorderColor
{
    return [[[[self tabButtons] firstObject] cell] tabSelectedBorderColor] ?: [NSColor KPC_defaultTabSelectedBorderColor];
}

- (void)setTabSelectedBorderColor:(NSColor *)tabSelectedBorderColor
{
    [[[self tabButtons] valueForKey:@"cell"] setValue:tabSelectedBorderColor forKey:@"tabSelectedBorderColor"];
    [self setNeedsDisplay];
}

- (NSColor *)tabSelectedTitleColor
{
    return [[[[self tabButtons] firstObject] cell] tabSelectedTitleColor] ?: [NSColor KPC_defaultTabSelectedTitleColor];
}

- (void)setTabSelectedTittleColor:(NSColor *)tabSelectedTitleColor
{
    [[[self tabButtons] valueForKey:@"cell"] setValue:tabSelectedTitleColor forKey:@"tabSelectedTitleColor"];
    [self setNeedsDisplay];
}

- (NSColor *)tabSelectedBackgroundColor
{
    return [[[[self tabButtons] firstObject] cell] tabSelectedBackgroundColor] ?: [NSColor KPC_defaultTabSelectedBackgroundColor];
}

- (void)setTabSelectedBackgroundColor:(NSColor *)tabSelectedBackgroundColor
{
    [[[self tabButtons] valueForKey:@"cell"] setValue:tabSelectedBackgroundColor forKey:@"tabSelectedBackgroundColor"];
    [self setNeedsDisplay];
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


@end

