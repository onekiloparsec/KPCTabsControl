//
//  KPCMessageInterceptor.h
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 04/11/14.
//  Copyright (c) 2014 Cédric Foellmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPCMessageInterceptor : NSObject
@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;
@end
