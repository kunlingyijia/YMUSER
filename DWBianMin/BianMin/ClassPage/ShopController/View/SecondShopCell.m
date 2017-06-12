//
//  SecondShopCell.m
//  BianMin
//
//  Created by kkk on 16/4/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SecondShopCell.h"
#import "Masonry.h"
#import "MerchantModel.h"
#import "RequestMerchantDetailModel.h"
@implementation SecondShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, Bounds.size.width - 20, 30)];
    nameLabel.text = @"商家介绍";
    nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame), Bounds.size.width-5, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.contentView addSubview:lineView];
    
    //营业时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+5, Bounds.size.width/2, 20)];
    self.timeLabel.text = @"营业时间:00:00-23:59";
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timeLabel];
    
    self.smokeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_xiangqing_wuyanfang"]];
    [self.contentView addSubview:self.smokeImage];
   [self.smokeImage mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.timeLabel.mas_bottom).with.offset(2);
       make.left.equalTo(self.contentView).with.offset(10);
       make.size.mas_equalTo(CGSizeMake(13, 13));
   }];
    
    self.smokeLabel = [UILabel new];
    self.smokeLabel.text = @"无烟房";
    self.smokeLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.smokeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.smokeLabel];
    [self.smokeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.smokeImage);
        make.left.equalTo(self.smokeImage.mas_right).with.offset(5);
        make.width.mas_equalTo(@(35));
    }];
    
    self.airImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_xiangqing_kongtiao"]];
    [self.contentView addSubview:self.airImage];
    [self.airImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.smokeLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    self.airLabel = [UILabel new];
    self.airLabel.text = @"空调";
    self.airLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.airLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.airLabel];
    [self.airLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.smokeImage);
        make.left.equalTo(self.airImage.mas_right).with.offset(5);
        make.width.mas_equalTo(@(25));
    }];
    
    self.waterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_xiangqing_reshui"]];
    [self.contentView addSubview:self.waterImage];
    [self.waterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.airLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    self.waterLabel = [UILabel new];
    self.waterLabel.text = @"24小时热水";
    self.waterLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.waterLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.waterLabel];
    [self.waterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.smokeImage);
        make.left.equalTo(self.waterImage.mas_right).with.offset(5);
        make.width.mas_equalTo(@(65));
    }];
    
    
    
    
    self.haveWifiImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wifi"]];
    [self.contentView addSubview:self.haveWifiImage];
    [self.haveWifiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.waterLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    self.haveWifiLabel = [UILabel new];
    self.haveWifiLabel.text = @"WIFI";
    self.haveWifiLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.haveWifiLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.haveWifiLabel];
    [self.haveWifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.smokeImage);
        make.left.equalTo(self.haveWifiImage.mas_right).with.offset(5);
        make.width.mas_equalTo(@(30));
    }];
    
    
    self.haveParkingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"停车场"]];
    [self.contentView addSubview:self.haveParkingImage];
    [self.haveParkingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.haveWifiLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    self.haveParkingLabel = [UILabel new];
    self.haveParkingLabel.text = @"停车场";
    self.haveParkingLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.haveParkingLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.haveParkingLabel];
    [self.haveParkingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.smokeImage);
        make.left.equalTo(self.haveParkingImage.mas_right).with.offset(5);
        make.width.mas_equalTo(@(40));
    }];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.text = @"";
    self.contentLabel.textColor = [UIColor grayColor];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smokeImage.mas_bottom).with.offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
}

- (void)cellGetData:(RequestMerchantDetailModel *)model {    
    
    if (model.have24hourWater == 0) {
        self.waterImage.hidden = YES;
        self.waterLabel.hidden = YES;
    }else if (model.have24hourWater == 1) {
        self.waterImage.hidden = NO;
        self.waterLabel.hidden = NO;
    }
    if (model.havaNoSmokingRoom == 0) {
        self.smokeLabel.hidden = YES;
        self.smokeImage.hidden = YES;
    }else if (model.havaNoSmokingRoom == 1) {
        self.smokeLabel.hidden = NO;
        self.smokeImage.hidden = NO;
    }
    if (model.havaAirCondition == 0) {
        self.airLabel.hidden = YES;
        self.airImage.hidden = YES;
    }else if (model.havaAirCondition == 1) {
        self.airLabel.hidden = NO;
        self.airImage.hidden = NO;
    }
    
    if (model.haveWifi == 0) {
        self.haveWifiImage.hidden = YES;
        self.haveWifiLabel.hidden = YES;
    }else if (model.haveWifi == 1) {
        self.haveWifiImage.hidden = NO;
        self.haveWifiLabel.hidden = NO;
    }
    if (model.haveParking == 0) {
        self.haveParkingImage.hidden = YES;
        self.haveParkingLabel.hidden = YES;
    } else if (model.haveParking == 1) {
        self.haveParkingImage.hidden = NO;
        self.haveParkingLabel.hidden = NO;
    }
   // 用户端  openTime  营业时间没有数据
    self.contentLabel.text = model.content;
    self.timeLabel.text =[NSString stringWithFormat:@"营业时间: %@",  model.openTime];
}


@end
