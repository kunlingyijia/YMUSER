//
//  RequestRefundGoodsOrderDetailModel.h
//  BianMin
//
//  Created by kkk on 16/7/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestRefundGoodsOrderDetailModel : NSObject

@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, assign) CGFloat returnAmount;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *refundTime;
@property (nonatomic, strong) NSString *createTime;


@end
