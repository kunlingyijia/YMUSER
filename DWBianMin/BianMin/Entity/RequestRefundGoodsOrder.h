//
//  RequestRefundGoodsOrder.h
//  BianMin
//
//  Created by kkk on 16/7/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestRefundGoodsOrder : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, copy) NSString *content;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;



@end
