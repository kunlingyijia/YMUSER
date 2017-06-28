//
//  IndustryListTwoCell.m
//  BianMin
//
//  Created by 席亚坤 on 2017/6/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryListTwoCell.h"
#import "IndustryModel.h"
@implementation IndustryListTwoCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(IndustryModel *)model{
    if (!model) return;
    _model = model;
    [DWHelper SD_WebImage:self.iconUrl imageUrlStr:model.iconUrl placeholderImage:nil];
    self.merchantName.text = model.merchantName;
    self.expireTime .text = model.expireTime;
    if (model.couponType == 1) {
        self.couponType.text = @"满减券";
        self.priceLabel.text = [NSString stringWithFormat:@"%.0f元", model.mVaule];
        self.contentLabel.text = [NSString stringWithFormat:@"满%.0f减%.0f", model.mPrice,model.mVaule];
    }else if (model.couponType == 2)  {
        self.couponType.text = @"立减券";
        self.priceLabel.text = [NSString stringWithFormat:@"%.0f元", model.lValue];
        self.contentLabel.text =[NSString stringWithFormat:@"立减%.0f", model.lValue];
        
    }else {
        self.couponType.text = @"折扣券";
        if (model.dValue % 10 == 0) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.0f折", model.dValue / 10.0];
            self.contentLabel.text =[NSString stringWithFormat:@"全场%.1f折", model.dValue / 10.0];
        }else {
            self.priceLabel.text = [NSString stringWithFormat:@"%.1f折", model.dValue / 10.0];
            self.contentLabel.text =[NSString stringWithFormat:@"全场%.1f折", model.dValue / 10.0];
        }
    }
    //selectStatus	1-可选择，2-不可选择
      if ([model.selectStatus isEqualToString:@"1"]) {
        self.bottomImageView.image = model.selected == YES ?  [UIImage imageNamed:@"绿-选中"]:[UIImage imageNamed: @"绿"];
    }else if ([model.selectStatus isEqualToString:@"2"]) {
        self.bottomImageView.image = [UIImage imageNamed:@"灰"];
        
    }
}

@end
