//
//  RefundModel.h
//  BianMin
//
//  Created by 席亚坤 on 17/2/22.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefundModel : NSObject

///支付金额
@property (nonatomic, strong) NSString  *payAmount ;
///手续费
@property (nonatomic, strong) NSString  *refundServiceFee ;
///退款金额
@property (nonatomic, strong) NSString  *refundAmount ;
///1-支持退款，0-不支持退款
@property (nonatomic, strong) NSString  *isSupportRefund ;
///title
@property (nonatomic, strong) NSString  *title ;

///isOther
@property (nonatomic, strong) NSString  *isOther ;
///	退款原因
@property (nonatomic, strong) NSString  *reason ;
///订单号
@property (nonatomic, strong) NSString  *orderNo ;
///订单id
@property (nonatomic, strong) NSString  *orderId ;

///退款理由 /申请退款原因
@property (nonatomic, strong) NSString  *content ;
///申请时间
@property (nonatomic, strong) NSString  *createTime ;
///退款完成时间
@property (nonatomic, strong) NSString  *refundTime ;
///退款状态：1-待审核（已申请），2-拒绝退款（填写原因），3-退款完成
@property (nonatomic, strong) NSString  *status ;
///拒绝退款原因
@property (nonatomic, strong) NSString  *refuseReason ;













@end
