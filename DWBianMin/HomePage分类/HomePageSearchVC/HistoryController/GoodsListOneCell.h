//
//  GoodsListOneCell.h
//  BianMin
//
//  Created by 席亚坤 on 17/6/1.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWStarRateView;
@class RequestMerchantListModel;
@interface GoodsListOneCell : UITableViewCell

///model
@property (nonatomic, strong) RequestMerchantListModel *model ;
///店铺logo
@property (weak, nonatomic) IBOutlet UIImageView *iconUrl;
///商户名称
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
///haveoffice 是否官方认证，0-不是 1-是
@property (weak, nonatomic) IBOutlet UILabel *Guan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GuanConstraint;
@property (weak, nonatomic) IBOutlet UILabel *TB;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starConstraint;
///星级
@property (weak, nonatomic) IBOutlet CWStarRateView *star;
///销量
@property (weak, nonatomic) IBOutlet UILabel *sales;


@end
