//
//  UserOrderViewController.h
//  BianMin
//
//  Created by kkk on 16/5/17.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "RequestMyGoodsOrderListModel.h"
@interface UserOrderViewController : BaseViewController

@property (nonatomic, strong) RequestMyGoodsOrderListModel *model;
@property (nonatomic, copy) NSString *isUse;
@property (nonatomic, copy) NSString *couponNo;
@property (nonatomic, copy) NSString *orderNo;
///goodsOrderCouponId
@property (nonatomic, strong) NSString  *goodsOrderCouponId ;
///goodsOrderId
@property (nonatomic, strong) NSString  *goodsOrderId ;



@property (nonatomic, copy) void(^backAction)(NSString *str);
@end
