//
//  RequestRefundGoodsOrderDetail.h
//  BianMin
//
//  Created by kkk on 16/7/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestRefundGoodsOrderDetail : NSObject

@property (nonatomic , copy) NSString *orderNo;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;



@end
