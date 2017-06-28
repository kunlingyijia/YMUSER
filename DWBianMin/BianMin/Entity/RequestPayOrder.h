//
//  RequestPayOrder.h
//  BianMin
//
//  Created by kkk on 16/6/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestPayOrder : NSObject

@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, assign) NSInteger number;
///		Int	卡券领取id
@property (nonatomic, strong) NSString  *couponUserId ;
/// 		Int	行业抵用券领取id
@property (nonatomic, strong) NSString  *industryCouponUserId ;



@end
