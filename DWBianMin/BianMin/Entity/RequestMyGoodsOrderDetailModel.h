//
//  RequestMyGoodsOrderDetailModel.h
//  BianMin
//
//  Created by kkk on 16/7/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMyGoodsOrderDetailModel : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *goodsOrderId;
@property (nonatomic, assign) NSInteger payType;//1-支付宝 2-微信支付
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *originUrl;
@property (nonatomic, copy) NSString *middleUrl;
@property (nonatomic, copy) NSString *smallUrl;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSArray *coupons;
@property (nonatomic, assign) CGFloat price;
///支付金额
@property (nonatomic, assign) CGFloat payAmount;
@property (nonatomic, copy) NSString* status; //0-未付款  1-已付款(待使用)  2-退款中  3-等待评价   4-已经退款  5-取消订单 6-已完成
@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, assign) NSInteger couponType;
@property (nonatomic, assign) CGFloat lValue;
@property (nonatomic, assign) NSInteger dValue;
@property (nonatomic, assign) CGFloat mPrice;
@property (nonatomic, assign) CGFloat mVaule;

///团购券Id（新增
@property (nonatomic, strong) NSString  *goodsOrderCouponId ;

///退款，1-支持，0-否
@property (nonatomic, strong) NSString  *isSupportRefund ;
///原因
@property (nonatomic, strong) NSString  *reason ;

///退款金额
@property (nonatomic, strong) NSString  *returnAmount ;

///	行业抵用券面额
@property (nonatomic, strong) NSString  *faceAmount ;


///距离(新增)
@property (nonatomic, strong) NSString  *distance ;











@end
