//
//  GoodsListOneCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/6/1.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "GoodsListOneCell.h"
#import "CWStarRateView.h"
#import "RequestMerchantListModel.h"
@implementation GoodsListOneCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    //self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.Guan.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.Guan.layer.masksToBounds = YES;
    self.Guan.layer.cornerRadius  = 2.0;
    self.TB.backgroundColor = [UIColor orangeColor];
    self.TB.layer.masksToBounds = YES;
    self.TB.layer.cornerRadius  = 2.0;

    self.star.allowIncompleteStar = YES;
    self.star.scorePercent = 0.5;
    self.star.hasAnimation = NO;
    self.star.userInteractionEnabled = NO;
   
    self.iconUrl.layer.masksToBounds = YES;
    self.iconUrl.layer.cornerRadius  = 3.0;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(RequestMerchantListModel *)model{
    if (!model) return;
    _model = model;
   [ DWHelper SD_WebImage:self.iconUrl imageUrlStr:model.iconUrl placeholderImage:nil];
   self.merchantName.text = model.merchantName;
   self.distance.text = model.distance;
   self. sales.text =[NSString stringWithFormat:@"销量:%@",model.sales ];
    
    //1-普通用户 2-便民
    if (model.merchantType ==1) {
        self.TB.text = @"团";
        self.star.hidden = NO;
        self.starConstraint.constant = 60.0;
        //self.starRateView.scorePercent = model.star*0.2;
        //0.25 0.75
        int star = model.star;
        CGFloat subStar = model.star-star;
        if (subStar<0.25) {
            self.star.scorePercent = star*0.2;
            
        }else if(subStar>0.75){
            self.star.scorePercent = (star+1)*0.2;
        }else{
            self.star.scorePercent = (star+0.5)*0.2;
            
        }
    }else{
        self.starConstraint.constant = 0.0;
        self.star.hidden = YES;
        self.TB.text = @"便";
    }
    if (model.haveoffice == 1) {
        self.GuanConstraint.constant = 15.0;
        self.Guan.text = @"官";
    }else {
     self.Guan.text = @"";
    self.GuanConstraint.constant = 0.0;
    }

    
    
}
@end
