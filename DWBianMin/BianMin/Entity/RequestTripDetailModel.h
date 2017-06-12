//
//  RequestTripDetailModel.h
//  BianMin
//
//  Created by kkk on 16/8/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestTripDetailModel : NSObject

@property (nonatomic, copy) NSString *tripId;
@property (nonatomic, copy) NSString *carNo;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *startPlace;
@property (nonatomic, copy) NSString *endPlace;
@property (nonatomic, copy) NSString *lastTicketCount;
@property (nonatomic, copy) NSString *hadTicketCount;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *driveTime;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *ticketCount;
@property (nonatomic, copy) NSString *kilometer;
@property (nonatomic, copy) NSString *arriveTime;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, strong) NSArray *stationNameList;
@property (nonatomic, copy) NSString *getOnPlace;
@property (nonatomic, copy) NSString *getDownPlace;

@end
