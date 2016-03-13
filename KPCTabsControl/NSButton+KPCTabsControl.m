//
//  NSButton+KPCTabsControl.m
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 30/10/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import "NSButton+KPCTabsControl.h"
#import "NSImage+KPCTabsControl.h"
#import "KPCTabButton.h"
#import "KPCTabButtonCell.h"

@implementation NSButton (KPCTabsControl)

+ (NSButton *)KPC_auxiliaryButtonWithImageNamed:(NSString *)imageName target:(id)target action:(SEL)action
{
    NSButton *button = [[NSButton alloc] init];

	KPCTabButtonCell *cell = [[KPCTabButtonCell alloc] initTextCell:@""];
	cell.borderMask |= KPCBorderMaskBottom;
    [button setCell:cell];
    [button.cell sendActionOn:NSLeftMouseDownMask|NSPeriodicMask];

    [button setTarget:target];
    [button setAction:action];
    [button setEnabled:action != NULL];
    [button setContinuous:YES];

    [button setImagePosition:NSImageOnly];
    [button setImage:[NSImage imageNamed:imageName]];

	CGRect r = CGRectZero;
	r.size = button.image.size;
    r.size.width += 4.0;
	button.frame = r;
    
    return button;
}

+ (KPCTabButton *)KPC_tabButtonWithItem:(id)item target:(id)target action:(SEL)action
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
