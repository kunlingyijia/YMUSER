//
//  RequestPayBminOrderModel.h
//  BianMin
//
//  Created by kkk on 16/8/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestPayBminOrderModel : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, assign) CGFloat payAmount;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, assign) UInt32 timestamp;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *prealipay;

@end
