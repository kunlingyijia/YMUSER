//
//  IndustryModel.h
//  BianMinMerchant
//
//  Created by 席亚坤 on 2017/6/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface IndustryModel : NSObject
///1-全部，2-已使用，3-未使用，4已过期
@property (nonatomic, strong) NSString  *type ;
///申请总面额/总面额
@property (nonatomic, strong) NSString  *totalFaceAmount	 ;
///有效期起
@property (nonatomic, strong) NSString  *beginTime;
///有效期止
@property (nonatomic, strong) NSString  *endTime;
///面额id
@property (nonatomic, strong) NSString  *faceId ;
///1-未使用(可删除) ，2-已使用(可删除)，3-已过期 (可删除)/	1-未使用(可删除) ，2-已使用(可删除)，3-已过期 (可删除)
@property (nonatomic, strong) NSString  *status ;
///余额
@property (nonatomic, strong) NSString  *balanceFaceAmount ;
///行业抵用券id
@property (nonatomic, strong) NSString  *industryCouponId ;
///面额
@property (nonatomic, strong) NSString  *faceAmount ;
///发放对象名称/面额
@property (nonatomic, strong) NSString  *name ;
///领取数量
@property (nonatomic, strong) NSString  *receiveNumber ;
///满xx元可用
@property (nonatomic, strong) NSString  *limitAmount ;
///发放数量
@property (nonatomic, strong) NSString  *stock ;
///目标车行id
@property (nonatomic, strong) NSString  *companyId ;
///车行名称
@property (nonatomic, strong) NSString  *companyName ;
///值
@property (nonatomic, strong) NSString  *value ;
///审核不通过的原因
@property (nonatomic, strong) NSString  *refuseReason;
///名称:NO.1001
@property (nonatomic, strong) NSString  *no ;
///	1-可选择，2-不可选择
@property (nonatomic, strong) NSString  *selectStatus;
///select
@property (nonatomic, assign) BOOL  selected ;

///我的行业抵用券id
@property (nonatomic, strong) NSString  *industryCouponUserId ;



///店铺logo
@property (nonatomic, strong) NSString  *iconUrl	 ;
///商户名称
@property (nonatomic, strong) NSString  *merchantName ;
///满减的额度，满减券
@property (nonatomic, assign) CGFloat mVaule ;
///满减券，多少满减
@property (nonatomic, assign) CGFloat mPrice ;
///折扣，10 表示 1折扣。 折扣券
@property (nonatomic, assign) NSInteger dValue ;
///立减多少钱. 立减券
@property (nonatomic,assign) CGFloat lValue;

///商家id
@property (nonatomic, strong) NSString  *merchantId ;
///卡券描述
@property (nonatomic, strong) NSString  *couponContent ;
///卡券名称
@property (nonatomic, strong) NSString  *couponName ;
///1-满减券  2-立减券  3-折扣券
@property (nonatomic, assign) NSInteger  couponType ;
///卡券id
@property (nonatomic, strong) NSString  *couponId ;
///领取ID
@property (nonatomic, strong) NSString  *couponUserId ;

///有效期
@property (nonatomic, strong) NSString  *expireTime ;

///实际支付金额
@property (nonatomic, strong) NSString  *amount ;


///		订单号
@property (nonatomic, strong) NSString  *orderNo ;

///	行业抵用券领取id
@property (nonatomic, strong) NSString  *receiveId ;







@end
