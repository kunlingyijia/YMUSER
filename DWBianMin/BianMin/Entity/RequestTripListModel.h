//
//  RequestTripListModel.h
//  BianMin
//
//  Created by kkk on 16/8/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestTripListModel : NSObject

@property (nonatomic, copy) NSString *tripId;//出行id
@property (nonatomic, copy) NSString *carNo;//车牌号
@property (nonatomic, copy) NSString *startPlace;//出发地
@property (nonatomic, copy) NSString *endPlace;//目的地
@property (nonatomic, copy) NSString *lastTicketCount;//车类型
@property (nonatomic, copy) NSString *carType;//当前剩余票数
@property (nonatomic, copy) NSString *driveTime;//行车时间
@property (nonatomic, assign) CGFloat price;//参考价格
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *arriveTime;

@end
