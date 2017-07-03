//
//  RequestMerchantGoodsListModel.h
//  BianMin
//
//  Created by kkk on 16/6/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantGoodsListModel : NSObject

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat discountedPrice;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *suggestPeople;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *useRule;
@property (nonatomic, copy) NSString *startuseTime;
@property (nonatomic, copy) NSString *enduseTime;
@property (nonatomic, copy) NSString *smallUrl;
@property (nonatomic, copy) NSString *originUrl;
@property (nonatomic, copy) NSString *middleUrl;
@property (nonatomic, copy) NSString *sales;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, strong) NSArray *images;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;
///行业圈id
@property (nonatomic, strong) NSString  *industryCouponUserId ;
///商家id
@property (nonatomic, strong) NSString  *merchantId ;

///		卡券id
@property (nonatomic, strong) NSString  *couponId	 ;

///		Int	卡券领取id
@property (nonatomic, strong) NSString  *couponUserId ;

@property (nonatomic, copy) NSString *payAmount;


@end
