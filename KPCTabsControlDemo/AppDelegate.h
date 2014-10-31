//
//  AppDelegate.h
//  KPCTabsControlDemo
//
//  Created by Cédric Foellmi on 28/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PaneViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic, weak) IBOutlet NSWindow *window;

// Top-levels objects
@property(nonatomic, strong) IBOutlet PaneViewController *topPane;
@property(nonatomic, strong) IBOutlet PaneViewController *bottomPane;

@end

