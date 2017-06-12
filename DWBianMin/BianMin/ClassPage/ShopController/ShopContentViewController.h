//
//  ShopContentViewController.h
//  BianMin
//
//  Created by kkk on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class RequestMerchantGoodsListModel;
@class RequestMerchantDetailModel;
@interface ShopContentViewController : BaseViewController

//@property (nonatomic,copy)NSString *title;
@property (nonatomic, strong) RequestMerchantGoodsListModel *model;
@property (nonatomic, strong) RequestMerchantDetailModel *shopModel;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *merchantId;
@property (nonatomic,copy)NSString *goodsId;
@end
