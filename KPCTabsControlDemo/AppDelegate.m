//
//  AppDelegate.m
//  KPCTabsControlDemo
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Pane View Controllers have a 'title' property set in the XIB that differentiate them.
    
    [self.topPane.tabsBar highlight:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}



@end
