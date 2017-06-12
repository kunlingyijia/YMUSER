//
//  RequestMerchantCouponListModel.h
//  BianMin
//
//  Created by kkk on 16/6/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantCouponListModel : NSObject

@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, assign) NSInteger couponType; //;1-满减券  2-立减券  3-折扣券
@property (nonatomic, copy) NSString * couponName;
@property (nonatomic, copy) NSString * couponContent;
@property (nonatomic, copy) NSString * storeAmount;
@property (nonatomic, copy) NSString * merchantId;
@property (nonatomic, assign) CGFloat lValue;
@property (nonatomic, assign) NSInteger dValue;
@property (nonatomic, assign) CGFloat mPrice;
@property (nonatomic, assign) CGFloat mVaule;
@property (nonatomic, assign) NSInteger isReceived;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *merchantName;
///expireTime
@property (nonatomic, strong) NSString  *expireTime ;


@end
