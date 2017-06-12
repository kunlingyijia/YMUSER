//
//  RequestTripOrderListModel.h
//  BianMin
//
//  Created by kkk on 16/8/31.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestTripOrderListModel : NSObject

@property (nonatomic, copy) NSString *tripId;
@property (nonatomic, copy) NSString *carNo;
@property (nonatomic, copy) NSString *startPlace;
@property (nonatomic, copy) NSString *endPlace;
@property (nonatomic, copy) NSString *ticketCount;
@property (nonatomic, copy) NSString *driveTime;
@property (nonatomic, copy) NSString *kilometer;
@property (nonatomic, copy) NSString *getOnPlace;
@property (nonatomic, copy) NSString *getDownPlace;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *stationNameList;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, assign) CGFloat payAmount;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger price;

@end
