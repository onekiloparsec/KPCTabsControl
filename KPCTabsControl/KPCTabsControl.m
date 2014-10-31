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
@end

@implementation KPCTabsControl

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubviews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setWantsLayer:YES];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self setCell:[[KPCTabButtonCell alloc] initTextCell:@""]];
    [self.cell setBorderMask:KPCBorderMaskBottom];
    [self.cell setFont:[NSFont fontWithName:@"HelveticaNeue-Medium" size:13]];

    [self unhighlight];
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
        r.size.width = CGRectGetWidth(self.scrollLeftButton.frame);
        r.origin.x = CGRectGetMaxX(self.scrollView.frame) - r.size.width;
        self.scrollRightButton.frame = r;
        r.origin.x -= r.size.width;
        self.scrollLeftButton.frame = r;
    }
    
//    [self startObservingScrollView];
//    [self updateButtons];
}

- (void)dealloc
{
//    [self stopObservingScrollView];
}

- (void)reconfigureWithScrollButtons:(BOOL)showScrollButtons
{
    self.hideScrollButtons = !showScrollButtons;
//    [self stopObservingScrollView];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    [self configureSubviews];
}

//- (void)updateButtons
//{
//    BOOL showAddButton = self.addAction != NULL;
//    
//    [_addButton setHidden:(showAddButton) ? NO : YES];
//    [_addButton.constraints.lastObject setConstant:(showAddButton) ? 48 : 0];
//    
//    NSClipView *contentView = self.scrollView.contentView;
//    
//    BOOL isDocumentClipped = (contentView.subviews.count > 0) && (NSMaxX([contentView.subviews[0] frame]) > NSWidth(contentView.bounds));
//    
//    if (isDocumentClipped) {
//        [_scrollLeftButton  setHidden:NO];
//        [_scrollRightButton setHidden:NO];
//        
//        [_scrollLeftButton setEnabled:([self firstTabLeftOutsideVisibleRect] != nil)];
//        [_scrollRightButton setEnabled:([self firstTabRightOutsideVisibleRect] != nil)];
//        
//    } else {
//        [_scrollLeftButton  setHidden:YES];
//        [_scrollRightButton setHidden:YES];
//    }
//}


//#pragma mark - ScrollView Observation
//
//static char KPCScrollViewObservationContext;
//
//- (void)startObservingScrollView
//{
//    [self.scrollView addObserver:self forKeyPath:@"frame" options:0 context:&KPCScrollViewObservationContext];
//    [self.scrollView addObserver:self forKeyPath:@"documentView.frame" options:0 context:&KPCScrollViewObservationContext];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(scrollViewDidScroll:)
//                                                 name:NSViewFrameDidChangeNotification
//                                               object:self.scrollView];
//}
//
//- (void)stopObservingScrollView
//{
//    [self.scrollView removeObserver:self forKeyPath:@"frame" context:&KPCScrollViewObservationContext];
//    [self.scrollView removeObserver:self forKeyPath:@"documentView.frame" context:&KPCScrollViewObservationContext];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:NSViewBoundsDidChangeNotification
//                                                  object:self.scrollView];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (context == &KPCScrollViewObservationContext) {
//        [self updateButtons];
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//- (void)scrollViewDidScroll:(NSNotification *)notification
//{
//    NSView *tabView = self.scrollView.documentView;
//    [self layoutTabs:[tabView subviews] inView:tabView];
//    [self updateButtons];
//    [self invalidateRestorableState];
//}

#pragma mark -
#pragma mark Actions

//- (void)setAddAction:(SEL)addAction {
//    if (_addAction != addAction) {
//        _addAction = addAction;
//        
//        [self updateButtons];
//    }
//}
//
//- (void)add:(id)sender {
//    [[NSApplication sharedApplication] sendAction:self.addAction to:self.addTarget from:self];
//    
//    [self invalidateRestorableState];
//}
//
//- (void)goLeft:(id)sender {
//    NSButton *tab = [self firstTabLeftOutsideVisibleRect];
//    
//    if (tab != nil) {
//        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//            [context setAllowsImplicitAnimation:YES];
//            [tab scrollRectToVisible:[tab bounds]];
//        } completionHandler:nil];
//    }
//}
//
//- (NSButton *)firstTabLeftOutsideVisibleRect {
//    NSView *tabView = self.scrollView.documentView;
//    NSRect  visibleRect = tabView.visibleRect;
//    
//    for (NSButton *button in tabView.subviews) {
//        if (NSMinX(button.frame) < NSMinX(visibleRect)) {
//            return button;
//        }
//    }
//    return nil;
//}
//
//- (void)goRight:(id)sender {
//    NSButton *tab = [self firstTabRightOutsideVisibleRect];
//    
//    if (tab != nil) {
//        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//            [context setAllowsImplicitAnimation:YES];
//            [tab scrollRectToVisible:[tab bounds]];
//        } completionHandler:nil];
//    }
//}
//
//- (NSButton *)firstTabRightOutsideVisibleRect {
//    NSView *tabView = self.scrollView.documentView;
//    NSRect  visibleRect = tabView.visibleRect;
//    
//    for (NSButton *button in [tabView subviews]) {
//        if (NSMaxX(button.frame) > NSMaxX(visibleRect)) {
//            return button;
//        }
//    }
//    return nil;
//}
//
//- (void)selectTab:(id)sender {
//    NSButton *selectedButton = sender;
//    
//    for (NSButton *button in [self.scrollView.documentView subviews]) {
//        [button setState:(button == selectedButton) ? 1 : 0];
//    }
//    
//    [[NSApplication sharedApplication] sendAction:self.action to:self.target from:self];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KPCTabsControlSelectionDidChangeNotification object:self];
//    
//    NSEvent *currentEvent = [NSApp currentEvent];
//    
//    if (currentEvent.clickCount > 1) {
//        // edit on double click...
//        [self editItem:[[sender cell] representedObject]];
//        
//    } else if ([self.dataSource tabControl:self canReorderItem:[[sender cell] representedObject]]) {
//        // watch for a drag event and initiate dragging if a drag is found...
//        if ([self.window nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:NO].type == NSLeftMouseDragged) {
//            [self reorderTab:sender withEvent:currentEvent];
//            return; // no autoscroll
//        }
//    }
//    
//    // scroll to visible if either editing or selecting...
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        [context setAllowsImplicitAnimation:YES];
//        [selectedButton.superview scrollRectToVisible:selectedButton.frame];
//    } completionHandler:nil];
//    
//    [self invalidateRestorableState];
//}

#pragma mark -
#pragma mark Reordering

//- (void)reorderTab:(NSButton *)tab withEvent:(NSEvent *)event {
//    // note existing tabs which will be reordered over
//    // the course of our drag; while the dragging tab maintains
//    // its position over the course of the dragging operation
//    
//    NSView          *tabView        = self.scrollView.documentView;
//    NSMutableArray  *orderedTabs    = [[NSMutableArray alloc] initWithArray:tabView.subviews.reverseObjectEnumerator.allObjects];
//    
//    // create a dragging tab used to represent our drag,
//    // and constraint its position and its size; the first
//    // constraint sets position - we'll be varying this one
//    // during our drag...
//    
//    CGFloat   tabX                  = NSMinX(tab.frame);
//    NSPoint   dragPoint             = [tabView convertPoint:event.locationInWindow fromView:nil];
//    
//    
//    NSButton *draggingTab           = [self tabWithItem:[tab.cell representedObject]];
//    
//    NSArray  *draggingConstraints   = @[[NSLayoutConstraint constraintWithItem:draggingTab attribute:NSLayoutAttributeLeading
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:tabView attribute:NSLayoutAttributeLeading
//                                                                    multiplier:1 constant:tabX],                                // VARIABLE
//                                        
//                                        [NSLayoutConstraint constraintWithItem:draggingTab attribute:NSLayoutAttributeTop
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:tabView attribute:NSLayoutAttributeTop
//                                                                    multiplier:1 constant:0],                                   // CONSTANT
//                                        [NSLayoutConstraint constraintWithItem:draggingTab attribute:NSLayoutAttributeBottom
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:tabView attribute:NSLayoutAttributeBottom
//                                                                    multiplier:1 constant:0]];                                  // CONSTANT
//    
//    
//    draggingTab.cell = [tab.cell copy];
//    
//    // cell subclasses may alter drawing based on represented object
//    [draggingTab.cell setRepresentedObject:[tab.cell representedObject]];
//    
//    // the presence of a menu affects the vertical offset of our title
//    if ([tab.cell menu] != nil) [draggingTab.cell setMenu:[[NSMenu alloc] init]];
//    
//    
//    [tabView addSubview:draggingTab];
//    [tabView addConstraints:draggingConstraints];
//    
//    [tab setHidden:YES];
//    
//    CGPoint prevPoint = dragPoint;
//    BOOL    dragged = NO, reordered = NO;
//    
//    while (1) {
//        event = [self.window nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
//        
//        if (event.type == NSLeftMouseUp) break;
//        
//        // ensure the dragged tab shows borders on both of its sides when dragging
//        if (dragged == NO && event.type == NSLeftMouseDragged) {
//            dragged = YES;
//            
//            KPCTabButtonCell *cell = draggingTab.cell;
//            cell.borderMask = cell.borderMask | KPCBorderMaskLeft | KPCBorderMaskRight;
//        }
//        
//        // move the dragged tab
//        NSPoint nextPoint = [tabView convertPoint:event.locationInWindow fromView:nil];
//        
//        CGFloat nextX = tabX + (nextPoint.x - dragPoint.x);
//        
//        BOOL    movingLeft = (nextPoint.x < prevPoint.x);
//        BOOL    movingRight = (nextPoint.x > prevPoint.x);
//        
//        prevPoint = nextPoint;
//        
//        [draggingConstraints[0] setConstant:nextX];
//        
//        // test for reordering...
//        if (movingLeft && NSMidX(draggingTab.frame) < NSMinX(tab.frame) && tab != orderedTabs.firstObject) {
//            // shift left
//            NSUInteger index = [orderedTabs indexOfObject:tab];
//            [orderedTabs exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
//            
//            [self layoutTabs:orderedTabs inView:tabView];
//            [tabView addConstraints:draggingConstraints];
//            
//            if (self.notifiesOnPartialReorder) {
//                [self.dataSource tabControlDidReorderItems:self orderedItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
//            }
//            
//            reordered = YES;
//            
//        } else if (movingRight && NSMidX(draggingTab.frame) > NSMaxX(tab.frame) && tab != orderedTabs.lastObject) {
//            // shift right
//            NSUInteger index = [orderedTabs indexOfObject:tab];
//            [orderedTabs exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
//            
//            [self layoutTabs:orderedTabs inView:tabView];
//            [tabView addConstraints:draggingConstraints];
//            
//            if (self.notifiesOnPartialReorder) {
//                [self.dataSource tabControlDidReorderItems:self orderedItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
//            }
//            
//            reordered = YES;
//        }
//        
//        [tabView layoutSubtreeIfNeeded];
//    }
//    
//    [draggingTab removeFromSuperview];
//    draggingTab = nil;
//    
//    [tabView removeConstraints:draggingConstraints];
//    
//    [tab setHidden:NO];
//    [tab.cell setControlView:tab];
//    
//    if (reordered) {
//        if (!self.notifiesOnPartialReorder) {
//            [self.dataSource tabControlDidReorderItems:self orderedItems:[orderedTabs valueForKeyPath:@"cell.representedObject"]];
//        }
//        
//        [self reloadData];
//        
//        [self setSelectedItem:[tab.cell representedObject]];
//    }
//}

#pragma mark -
#pragma mark Selection

//- (id)selectedItem {
//    for (NSButton *button in [self.scrollView.documentView subviews]) {
//        if ([button state] == 1) {
//            return [[button cell] representedObject];
//        }
//    }
//    return nil;
//}
//- (void)setSelectedItem:(id)selectedItem {
//    for (NSButton *button in [self.scrollView.documentView subviews]) {
//        if ([[[button cell] representedObject] isEqual:selectedItem]) {
//            [button setState:1];
//            
//            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//                [context setAllowsImplicitAnimation:YES];
//                [button scrollRectToVisible:[button bounds]];
//            } completionHandler:nil];
//            
//        } else {
//            [button setState:0];
//        }
//    }
//    
//    [self invalidateRestorableState];
//}

#pragma mark -
#pragma mark Data Source

- (void)setDataSource:(id<KPCTabsControlDataSource>)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlDidChangeSelection:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:_dataSource
                                                        name:KPCTabsControlSelectionDidChangeNotification
                                                      object:self];
    }
    
    _dataSource = dataSource;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlDidChangeSelection:)])
        [[NSNotificationCenter defaultCenter] addObserver:_dataSource
                                                 selector:@selector(tabControlDidChangeSelection:)
                                                     name:KPCTabsControlSelectionDidChangeNotification
                                                   object:self];
    
    [self reloadData];
}

- (void)reloadData
{
    [self.tabsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0, count = [self.dataSource tabControlNumberOfTabs:self]; i < count; i++) {
        [newItems addObject:[self.dataSource tabControl:self itemAtIndex:i]];
    }
    
    NSMutableArray *newTabs = [[NSMutableArray alloc] init];
    for (id item in newItems) {
        KPCTabButton *button = [NSButton tabButtonWithItem:item target:self action:@selector(selectTab:)];
        
        if ([self.dataSource respondsToSelector:@selector(tabControl:menuForItem:)]) {
            NSMenu *menu = [self.dataSource tabControl:self menuForItem:item];
            if (menu) {
                [button useMenu:menu];
            }
        }
        
        [self.tabsView addSubview:button];
        [newTabs addObject:button];
    }
    
    [self layoutTabs:newTabs];
    
    self.items = newItems;
    
//    if (self.scrollView.documentView) {
//        NSClipView *clipView = self.scrollView.contentView;
//        NSView *documentView = self.scrollView.documentView;
//        
//        // document content is as tall as our scrolling area, and at least as wide...
//        
//        [clipView addConstraints:
//         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[documentView]|"
//                                                 options:0
//                                                 metrics:nil
//                                                   views:@{@"documentView": documentView}]];
//        
//        [clipView addConstraints:
//         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[documentView]"
//                                                 options:0
//                                                 metrics:nil
//                                                   views:@{@"documentView": documentView}]];
//        
//        // here's the 'at least as wide' constraint...
//        
//        [clipView addConstraint:
//         [NSLayoutConstraint constraintWithItem:documentView attribute:NSLayoutAttributeRight
//                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                         toItem:clipView attribute:NSLayoutAttributeRight
//                                     multiplier:1 constant:0]];
//    }
    
//    [self updateButtons];
    
//    [self invalidateRestorableState];
}

- (void)layoutTabs:(NSArray *)tabs
{
    if (!tabs || [tabs count] == 0) {
        return;
    }
    
    self.preferFullWidthTabs = YES;
    
    CGFloat minWidth = [(KPCTabButton *)tabs[0] minWidth];
    CGFloat maxWidth = [(KPCTabButton *)tabs[0] maxWidth];
    NSAssert([tabs count]*minWidth <= CGRectGetWidth(self.tabsView.frame), @"Impossible to place tabs");
    
    CGFloat availableWidth = CGRectGetWidth(self.tabsView.frame) - ((self.hideScrollButtons) ? 0.0 : 2*CGRectGetWidth(self.scrollLeftButton.frame));
    CGFloat fullSizeWidth = availableWidth / tabs.count;
    CGFloat buttonWidth = (self.preferFullWidthTabs) ? fullSizeWidth : MIN(maxWidth, fullSizeWidth);
    
    NSAssert(buttonWidth >= minWidth, @"Impossible to place tabs: button width %1.f > min width %.1f", buttonWidth, minWidth);
    
    for (NSUInteger i = 0; i < tabs.count; i++) {
        CGRect r = CGRectMake(i*buttonWidth, 0, buttonWidth, CGRectGetHeight(self.tabsView.frame));
        KPCTabButton *button = tabs[i];
        [button setFrame:r];
    }
}

//- (KPCTabButton *)tabWithItem:(id)item
//{
//    KPCTabButtonCell *tabCell = [self.cell copy];
//    
//    tabCell.representedObject = item;
//    
//    tabCell.imagePosition = NSNoImage;
//    tabCell.borderMask = KPCBorderMaskRight|KPCBorderMaskBottom;
//    
//    tabCell.title = [self.dataSource tabControl:self titleForItem:item];
//    
//    tabCell.target = self;
//    tabCell.action = @selector(selectTab:);
//    
//    [tabCell sendActionOn:NSLeftMouseDownMask];
//    
//    KPCTabButton *tab = [[KPCTabButton alloc] initWithFrame:CGRectMake(0.0, 0.0, tabCell.minWidth, CGRectGetHeight(self.scrollView.frame))];
//    
//    [tab setCell:tabCell];
//    
//    if ([self.dataSource respondsToSelector:@selector(tabControl:canSelectItem:)]) {
//        [[tab cell] setSelectable:[self.dataSource tabControl:self canSelectItem:item]];
//    }
//    
//    if ([self.dataSource respondsToSelector:@selector(tabControl:willDisplayButton:forItem:)]) {
//        [self.dataSource tabControl:self willDisplayButton:tab forItem:item];
//    }
//    
//    return tab;
//}

//- (NSArray *)tabButtons
//{
//    NSMutableArray *buttons = @[].mutableCopy;
//    
//    for (NSButton *button in [self.scrollView.documentView subviews]) {
//        if (button != self.draggingTab) {
//            [buttons addObject:button];
//        }
//    }
//    return buttons;
//}
//
//- (NSButton *)tabButtonWithItem:(id)item {
//    for (NSButton *button in [self.scrollView.documentView subviews]) {
//        if (button != self.draggingTab) {
//            if ([[[button cell] representedObject] isEqual:item]) {
//                return button;
//            }
//        }
//    }
//    return nil;
//}

#pragma mark -
#pragma mark ScrollView Tracking

//- (NSButton *)trackedButtonWithEvent:(NSEvent *)theEvent {
//    id item = theEvent.trackingArea.userInfo[@"item"];
//    return (item != nil) ? [self tabButtonWithItem:item] : nil;
//}
//
//- (void)mouseEntered:(NSEvent *)theEvent {
//    [[[self trackedButtonWithEvent:theEvent] cell] setShowsMenu:YES];
//}
//- (void)mouseExited:(NSEvent *)theEvent {
//    [[[self trackedButtonWithEvent:theEvent] cell] setShowsMenu:NO];
//}

#pragma mark -
#pragma mark Editing

//- (void)editItem:(id)item {
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
//}

#pragma mark -
#pragma mark NSTextFieldDelegate

//- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
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

- (void)highlight
{
    NSColor *color = [NSColor colorWithCalibratedWhite:0.85 alpha:1.0];
    [self setBackgroundColor:color];
    [[self.scrollView.documentView subviews] makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:color];
}

- (void)unhighlight
{
    NSColor *color = [NSColor colorWithCalibratedWhite:0.95 alpha:1.0];
    [self setBackgroundColor:color];
    [[self.scrollView.documentView subviews] makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:color];
}


#pragma mark - State Restoration

// NOTE: to enable state restoration, be sure to either assign an identifier to
// the LITabControl instance within IB or, if the control is created programmatically,
// prior to adding it to your window's view hierarchy.

//#define kScrollXOffsetKey @"scrollOrigin"
//#define kSelectedButtonIndexKey @"selectedButtonIndex"
//
//- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    [super encodeRestorableStateWithCoder:coder];
//    
//    CGFloat scrollXOffset = 0;
//    NSUInteger selectedButtonIndex = NSNotFound;
//    
//    scrollXOffset = self.scrollView.contentView.bounds.origin.x;
//    
//    NSUInteger index = 0;
//    for (NSButton *button in [self.scrollView.documentView subviews]) {
//        if (button.state == 1) {
//            selectedButtonIndex = index;
//            break;
//        }
//        index += 1;
//    }
//    
//    [coder encodeDouble:scrollXOffset forKey:kScrollXOffsetKey];
//    [coder encodeInteger:selectedButtonIndex forKey:kSelectedButtonIndexKey];
//}
//
//- (void)restoreStateWithCoder:(NSCoder *)coder
//{
//    [super restoreStateWithCoder:coder];
//    
//    CGFloat scrollXOffset = [coder decodeDoubleForKey:kScrollXOffsetKey];
//    NSUInteger selectedButtonIndex = [coder decodeIntegerForKey:kSelectedButtonIndexKey];
//    
//    NSRect bounds = self.scrollView.contentView.bounds; bounds.origin.x = scrollXOffset;
//    self.scrollView.contentView.bounds = bounds;
//    
//    NSUInteger index = 0;
//    for (NSButton *button in [self.scrollView.documentView subviews]) {
//        [button setState:(index == selectedButtonIndex) ? NSOnState : NSOffState];
//        index += 1;
//    }
//}

#pragma mark - Properties

//- (void)setBorderColor:(NSColor *)borderColor
//{
//    [self.cell setBorderColor:borderColor];
//    for (id subview in self.subviews) {
//        if ([subview respondsToSelector:@selector(cell)]) {
//            id cell = [subview cell];
//            if ([cell respondsToSelector:@selector(setBorderColor:)]) {
//                [cell setBorderColor:borderColor];
//            }
//        }
//    }
//}
//
//- (void)setBackgroundColor:(NSColor *)backgroundColor
//{
//    [self.cell setBackgroundColor:backgroundColor];
//    for (id subview in self.subviews) {
//        if ([subview respondsToSelector:@selector(cell)]) {
//            id cell = [subview cell];
//            if ([cell respondsToSelector:@selector(setBackgroundColor:)]) {
//                [cell setBackgroundColor:backgroundColor];
//            }
//        }
//    }
//}
//
//- (void)setTitleColor:(NSColor *)titleColor
//{
//    [self.cell setTitleColor:titleColor];
//    for (id subview in self.subviews) {
//        if ([subview respondsToSelector:@selector(cell)]) {
//            id cell = [subview cell];
//            if ([cell respondsToSelector:@selector(setTitleColor:)]) {
//                [cell setTitleColor:titleColor];
//            }
//        }
//    }
//}
//
//- (void)setTitleHighlightColor:(NSColor *)titleHighlightColor
//{
//    [self.cell setTitleHighlightColor:titleHighlightColor];
//    
//    for (id subview in self.subviews) {
//        if ([subview respondsToSelector:@selector(cell)]) {
//            id cell = [subview cell];
//            if ([cell respondsToSelector:@selector(setTitleHighlightColor:)]) {
//                [cell setTitleHighlightColor:titleHighlightColor];
//            }
//        }
//    }
//}

@end

