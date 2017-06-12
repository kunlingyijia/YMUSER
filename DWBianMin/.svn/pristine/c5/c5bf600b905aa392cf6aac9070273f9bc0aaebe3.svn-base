//
//  MyCouponCell.h
//  BianMin
//
//  Created by kkk on 16/7/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMyCouponListModel.h"
#import "RequestMerchantCouponListModel.h"
@interface MyCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *expireTime;

@property (weak, nonatomic) IBOutlet UILabel *couponType;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *showMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *isUseLabel;

- (void)cellGetDataModel:(RequestMyCouponListModel *)model withController:(BaseViewController *)vc;
- (void)cellGetCouponModel:(RequestMerchantCouponListModel *)model withController:(BaseViewController *)vc;

@end
