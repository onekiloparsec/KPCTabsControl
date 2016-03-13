//
//  KPCMessageInterceptor.m
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 04/11/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import "KPCMessageInterceptor.h"

@implementation KPCMessageInterceptor

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector]) { return self.middleMan; }
    if ([self.receiver respondsToSelector:aSelector]) { return self.receiver; }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.middleMan respondsToSelector:aSelector]) { return YES; }
    if ([self.receiver respondsToSelector:aSelector]) { return YES; }
    return [super respondsToSelector:aSelector];
}

@end
