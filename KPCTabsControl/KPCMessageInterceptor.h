//
//  KPCMessageInterceptor.h
//  KPCTabsControl
//
//  Created by @onekiloparsec (Cédric Foellmi) on 04/11/14.
//  Licensed under the MIT License (see LICENSE file)
//

#import <Foundation/Foundation.h>

@interface KPCMessageInterceptor : NSObject
@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;
@end
