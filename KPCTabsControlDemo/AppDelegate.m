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
    self.topPane.paneIndex = 0;
    self.bottomPane.paneIndex = 1;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}



@end
