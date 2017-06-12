//
//  RequestSearchStation.h
//  BianMin
//
//  Created by kkk on 16/8/31.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestSearchStation : NSObject

@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *startPlace;
@property (nonatomic, copy) NSString *endPlace;
@property (nonatomic, copy) NSString *startTime;

@end
