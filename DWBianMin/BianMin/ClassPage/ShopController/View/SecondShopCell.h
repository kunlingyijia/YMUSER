//
//  SecondShopCell.h
//  BianMin
//
//  Created by kkk on 16/4/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestMerchantDetailModel;
@interface SecondShopCell : UITableViewCell

@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *smokeImage;
@property (nonatomic, strong) UILabel *smokeLabel;

@property (nonatomic, strong) UIImageView *airImage;
@property (nonatomic, strong) UILabel *airLabel;

@property (nonatomic, strong) UIImageView *waterImage;
@property (nonatomic, strong) UILabel *waterLabel;

@property (nonatomic, strong) UIImageView *haveWifiImage;
@property (nonatomic, strong) UILabel *haveWifiLabel;

@property (nonatomic, strong) UIImageView *haveParkingImage;
@property (nonatomic, strong) UILabel *haveParkingLabel;


- (void)cellGetData:(RequestMerchantDetailModel *)model;


@end
