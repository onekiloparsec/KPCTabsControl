//
//  PaneViewController.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 31/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KPCTabsControl.h"
#import "KPCTabsControlProtocols.h"

@interface PaneViewController : NSViewController <KPCTabsControlDataSource, KPCTabsControlDelegate>

@property(nonatomic, weak) IBOutlet KPCTabsControl *tabsBar;

@property(nonatomic, weak) IBOutlet NSButton *useFullWidthTabsCheckButton;
@property(nonatomic, weak) IBOutlet NSTextField *minWidthLabel;
@property(nonatomic, weak) IBOutlet NSTextField *maxWidthLabel;

- (IBAction)toggleFullWidthTabs:(id)sender;

@end
