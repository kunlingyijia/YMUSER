//
//  TripModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 17/2/11.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripModel : NSObject
///出发地 纬度
@property (nonatomic, strong) NSString  *startPlaceLat ;
///出发地 经度
@property (nonatomic, strong) NSString  *startPlaceLng ;
///出发地
@property (nonatomic, strong) NSString  *startPlace ;
///可提供座位数量
@property (nonatomic, strong) NSString  *seatNumber ;
///发车时间:HH:II
@property (nonatomic, strong) NSString  *time ;
///发车时间:YYYY-MM-DD
@property (nonatomic, strong) NSString  *date ;
///每座价格
@property (nonatomic, strong) NSString  *price ;
///目的地 纬度
@property (nonatomic, strong) NSString  *endPlaceLat ;
///目的地 经度
@property (nonatomic, strong) NSString  *endPlaceLng ;
///目的地
@property (nonatomic, strong) NSString  *endPlace ;
///行程状态：1-待发布，2-已发布 ，3-待发车,4-已发车 ，5-已结束 订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消/1-未支付，2-已支付 
@property (nonatomic, strong) NSString  *status ;
///路线id
@property (nonatomic, strong) NSString  *planId ;

///已经预约的人数
@property (nonatomic, strong) NSString  *bookNumber ;
///1-待上车，2-已上车
@property (nonatomic, strong) NSString  *orderStatus ;
///联系电话
@property (nonatomic, strong) NSString  *tel	 ;

///联系名字
@property (nonatomic, strong) NSString  *name ;

///	下单时间
@property (nonatomic, strong) NSString  *createTime ;
///订单id
@property (nonatomic, strong) NSString  *orderId;
///车主姓名
@property (nonatomic, strong) NSString  *realName ;
///车主头像
@property (nonatomic, strong) NSString  *avatarUrl ;
///性别 0-女 1-男
@property (nonatomic, strong) NSString  *gender ;
///订单号
@property (nonatomic, strong) NSString  *orderNo ;



///车牌号
@property (nonatomic, strong) NSString  *carNo ;
///车颜色
@property (nonatomic, strong) NSString  *carColor ;


///品牌型号
@property (nonatomic, strong) NSString  *carBrand
 ;

///出发时间
@property (nonatomic, strong) NSString  *startTime ;



///1-展示，0-不展示
@property (nonatomic, strong) NSString  *isShowPosition ;

///payAmount
@property (nonatomic, strong) NSString  *payAmount ;



///剩余座位数
@property (nonatomic, strong) NSString  *restNumber ;
///1-正常，2-满员，3-已发车，4-已结束
@property (nonatomic, strong) NSString  *planStatus ;


///验证码
@property (nonatomic, strong) NSString  *verifyCode;
///倒计时时间(秒)

@property (nonatomic, strong) NSString  *payTimeLimit ;

///1-支付宝支付，2-微信支付
@property (nonatomic, strong) NSString  *payType ;

///司机电话
@property (nonatomic, strong) NSString  *mobile ;

///		备注（新增20170320）
@property (nonatomic, strong) NSString  *remark ;

///行业抵用券id
@property (nonatomic, strong) NSString  *industryCouponUserId ;


///车行id
@property (nonatomic, strong) NSString  *companyId ;


///行业抵用券面额
@property (nonatomic, strong) NSString  *faceAmount ;












@end
