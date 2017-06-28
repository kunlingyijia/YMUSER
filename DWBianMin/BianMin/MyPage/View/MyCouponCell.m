//
//  MyCouponCell.m
//  BianMin
//
//  Created by kkk on 16/7/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyCouponCell.h"

@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataModel:(RequestMyCouponListModel *)model withController:(BaseViewController *)vc{
    [vc loadImageWithView:self.pictureView urlStr:model.iconUrl];
    self.nameLabel.text = model.merchantName;
    
//    NSString * string = model.expireTime;
    self.expireTime .text = model.expireTime;;
    if (model.couponType == 1) {
        self.couponType.text = @"满减券";
        self.priceLabel.text = [NSString stringWithFormat:@"%.0f", model.mVaule];
        self.contentLabel.text = [NSString stringWithFormat:@"满%.0f减%.0f", model.mPrice,model.mVaule];
    }else if (model.couponType == 2)  {
        self.couponType.text = @"立减券";
        self.priceLabel.text = [NSString stringWithFormat:@"%.0f", model.lValue];
        self.contentLabel.text =[NSString stringWithFormat:@"立减%.0f", model.lValue];

    }else {
        self.couponType.text = @"折扣券";
        self.showMoneyLabel.hidden = YES;
        if (model.dValue % 10 == 0) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.0f折", model.dValue / 10.0];
            self.contentLabel.text =[NSString stringWithFormat:@"全场%.1f折", model.dValue / 10.0];
        }else {
            self.priceLabel.text = [NSString stringWithFormat:@"%.1f折", model.dValue / 10.0];
            self.contentLabel.text =[NSString stringWithFormat:@"全场%.1f折", model.dValue / 10.0];
        }
    }
    if (model.status == 1) {
        self.isUseLabel.text = @"未使用";
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#48cab0"];
        self.showImage.image = [UIImage imageNamed:@"bg_my_youhuiquan_lvse"];
    }else if (model.status == 2) {
        self.isUseLabel.text = @"已使用";
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#c0c0c0"];
        self.showImage.image = [UIImage imageNamed:@"bg_my_youhuiquan_huiise-1"];
    }else if(model.status == 3){
        self.isUseLabel.text = @"已过期";
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#c0c0c0"];
        self.showImage.image = [UIImage imageNamed:@"bg_my_youhuiquan_huiise-1"];
    }
}

- (void)cellGetCouponModel:(RequestMerchantCouponListModel *)model withController:(BaseViewController *)vc {
    [vc loadImageWithView:self.pictureView urlStr:model.iconUrl];
    self.nameLabel.text = model.merchantName;
    self.contentLabel.text = model.couponContent;
//    NSString * string = model.expireTime;
    
    self.expireTime .text =model.expireTime;;
    if (model.couponType == 1) {
        self.couponType.text = @"满减券";
        self.priceLabel.text = [NSString stringWithFormat:@"%.0f", model.mVaule];
        self.contentLabel.text = [NSString stringWithFormat:@"满%.0f减%.0f", model.mPrice,model.mVaule];
    }else if (model.couponType == 2)  {
        self.couponType.text = @"立减券";
        self.priceLabel.text = [NSString stringWithFormat:@"%.0f", model.lValue];
         self.contentLabel.text =[NSString stringWithFormat:@"立减%.0f", model.lValue];
    }else {
        self.couponType.text = @"折扣券";
        self.showMoneyLabel.hidden = YES;
        if (model.dValue % 10 == 0) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.0f折", model.dValue / 10.0];
             self.contentLabel.text =[NSString stringWithFormat:@"全场%.1f折", model.dValue / 10.0];
        }else {
            self.priceLabel.text = [NSString stringWithFormat:@"%.1f折", model.dValue / 10.0];
             self.contentLabel.text =[NSString stringWithFormat:@"全场%.1f折", model.dValue / 10.0];
        }
    }
    if (model.isReceived == 1) {
        self.isUseLabel.text = @"已领取";
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#c0c0c0"];
        self.showImage.image = [UIImage imageNamed:@"bg_my_youhuiquan_huiise-1"];
    }
    if (model.isReceived == 0) {
        self.isUseLabel.text = @"未领取";
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"#48cab0"];
        self.showImage.image = [UIImage imageNamed:@"bg_my_youhuiquan_lvse"];
    }

}


@end
