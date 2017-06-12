//
//  MoreShopContentViewController.h
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "RequestMerchantDetailModel.h"
@interface MoreShopContentViewController : BaseViewController
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, strong) RequestMerchantDetailModel *shopModel;
@end
