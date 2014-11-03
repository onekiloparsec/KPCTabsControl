//
//  NSButton+KPCTabsControl.m
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 30/10/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import "NSButton+KPCTabsControl.h"
#import "KPCTabButton.h"
#import "KPCTabButtonCell.h"

@implementation NSButton (KPCTabsControl)

+ (NSButton *)auxiliaryButtonWithImageNamed:(NSString *)name target:(id)target action:(SEL)action
{
    NSButton *button = [[NSButton alloc] init];

	KPCTabButtonCell *cell = [[KPCTabButtonCell alloc] initTextCell:@""];
	cell.borderMask |= KPCBorderMaskBottom;
    [button setCell:cell];

    [button setTarget:target];
    [button setAction:action];
    
    [button setEnabled:action != NULL];
    
    [button setImagePosition:NSImageOnly];
    [button setImage:[NSImage imageNamed:name]];

	CGRect r = CGRectZero;
	r.size = button.image.size;
	button.frame = r;
    
    return button;
}

+ (KPCTabButton *)tabButtonWithItem:(id)item target:(id)target action:(SEL)action
{
    KPCTabButton *tabButton = [[KPCTabButton alloc] initWithFrame:CGRectZero];
    [tabButton setEnabled:action != NULL];

    KPCTabButtonCell *tabCell = [[KPCTabButtonCell alloc] initTextCell:@""];
    
    tabCell.representedObject = item;
    
    tabCell.imagePosition = NSNoImage;
    tabCell.borderMask = KPCBorderMaskRight|KPCBorderMaskBottom;
    
    tabCell.target = target;
    tabCell.action = action;
    
    [tabCell sendActionOn:NSLeftMouseDownMask];
    
    [tabButton setCell:tabCell];
    
    return tabButton;
}

@end
