//
//  PaneViewController.m
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 31/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "PaneViewController.h"
#import "KPCTabsControlConstants.h"

@interface PaneViewController ()
@property(nonatomic, assign) BOOL isSelected;
@property (strong) NSArray *titles;
@end

@implementation PaneViewController

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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUponPaneSelectionDidChange:)
                                                 name:@"PaneSelectionDidChangeNotification"
                                               object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
 
    self.titles = @[@"Tab1", @"Tab2", @"Tab3", @"Tab4", @"Tab5"];
    [self.tabsBar reloadData];
}

- (IBAction)toggleFullWidthTabs:(id)sender
{
    
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    
    BOOL sendNotification = (!self.isSelected);
    
    self.isSelected = YES;
    [self.tabsBar highlight];
    //    [self.topBarView setUniformColor:[STLSmartColor colorWithWhite:0.85 alpha:1.0]];
    [self.view setNeedsDisplay:YES];
    
    if (sendNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaneSelectionDidChangeNotification"
                                                            object:self
                                                          userInfo:nil];
    }
}

- (void)updateUponPaneSelectionDidChange:(NSNotification *)notif
{
    if ([notif object] != self) {
        self.isSelected = NO;
        [self.tabsBar unhighlight];
        //    [self.topBarView setUniformColor:[STLSmartColor colorWithWhite:0.98 alpha:1.0]];
        [self.view setNeedsDisplay:YES];
    }
}

#pragma mark - KPCTabsControlDataSource

- (NSUInteger)tabControlNumberOfTabs:(KPCTabsControl *)tabControl
{
    return self.titles.count;
}

- (id)tabControl:(KPCTabsControl *)tabControl itemAtIndex:(NSUInteger)index
{
    return self.titles[index];
}

- (NSString *)tabControl:(KPCTabsControl *)tabControl titleForItem:(id)item
{
    NSUInteger index = [self.titles indexOfObject:item];
    return (index == NSNotFound) ? @"?" : self.titles[index];
}


@end
