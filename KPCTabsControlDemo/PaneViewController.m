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
@property (strong) NSArray *titles;
@property (strong) NSDictionary *icons;
@property (strong) NSDictionary *menus;
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
    
    switch ([self.title isEqualToString:@"pane1"]) {
        case 0: {
            self.titles = @[@"Tab 1", @"Tab 2", @"Tab 3", @"Tab 4", @"Tab 5"];
            NSMenu *tab2Menu = [[NSMenu alloc] init];
            [tab2Menu addItemWithTitle:@"Action 1" action:NULL keyEquivalent:@""];
            [tab2Menu addItemWithTitle:@"Action 2" action:NULL keyEquivalent:@""];
            self.menus = @{@"Tab 2": tab2Menu};
            break;
        }

        case 1:
            self.titles = @[@"Tab a", @"Tab b", @"Tab c", @"Tab d"];
            break;

        default:
            break;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib]; 
    [self.tabsBar reloadData];
}

- (IBAction)toggleFullWidthTabs:(id)sender
{
    
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    
    BOOL sendNotification = (!self.tabsBar.isHighlighted);

    [self.tabsBar highlight:YES];
    
    if (sendNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaneSelectionDidChangeNotification"
                                                            object:self
                                                          userInfo:nil];
    }
}

- (void)updateUponPaneSelectionDidChange:(NSNotification *)notif
{
    if ([notif object] != self) {
        [self.tabsBar highlight:NO];
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


#pragma - mark Optionals

- (NSMenu *)tabControl:(KPCTabsControl *)tabControl menuForItem:(id)item
{
    return [self.menus objectForKey:item];
}

- (void)tabControl:(KPCTabsControl *)tabControl willDisplayButton:(KPCTabButton *)button forItem:(id)item
{
	NSUInteger index = [self.titles indexOfObject:item];
	if ([self.title isEqualToString:@"pane1"]) {
		switch (index) {
			case 0:
				[button setIcon:[NSImage imageNamed:@"Star"]];
				break;
			case 2:
				[button setIcon:[NSImage imageNamed:@"Oval"]];
				break;

			default:
				break;
		}
	}
	else {
		switch (index) {
			case 1:
				[button setIcon:[NSImage imageNamed:@"Triangle"]];
				break;
			case 2:
				[button setIcon:[NSImage imageNamed:@"Spiral"]];
				break;
			case 3:
				[button setIcon:[NSImage imageNamed:@"Polygon"]];
				break;

			default:
				break;
		}
	}
}


@end
