//
//  RequestMyCouponListModel.h
//  BianMin
//
//  Created by kkk on 16/7/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMyCouponListModel : NSObject

@property (nonatomic, copy) NSString *couponUserId;
@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, assign) NSInteger couponType;
@property (nonatomic, copy) NSString *couponContent;
@property (nonatomic, copy) NSString *storeAmount;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, assign) CGFloat lValue;
@property (nonatomic, assign) NSInteger dValue;
@property (nonatomic, assign) CGFloat mPrice;
@property (nonatomic, assign) CGFloat mVaule;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, assign) NSInteger isReceived;
///有效期
@property (nonatomic, strong) NSString  *expireTime ;


@end
