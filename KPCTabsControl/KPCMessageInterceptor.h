//
//  KPCMessageInterceptor.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 04/11/14.
//  Copyright (c) 2014 @onekiloparsec (Cédric Foellmi). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPCMessageInterceptor : NSObject
@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;
@end
