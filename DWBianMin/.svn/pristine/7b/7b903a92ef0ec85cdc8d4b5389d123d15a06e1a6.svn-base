//
//  TOrderDetailsOneCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TOrderDetailsOneCell.h"
#import "TripModel.h"
@implementation TOrderDetailsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.avatarUrl.layer.masksToBounds = YES;
    self.avatarUrl.layer.cornerRadius =(0.2*Width-20)/2;
}
-(void)CellGetData:(TripModel*)model{
    [self.avatarUrl sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"bg_zaijia_1-1"]];
    self.realName.text = model.realName;
    ///性别 0-女 1-男
    if ([model.gender isEqualToString:@"0"]) {
        self.gender.image = [UIImage imageNamed:@"性别－女"];
    }else{
        self.gender.image = [UIImage imageNamed:@"性别－男"];
    }
    self.carNo.text = [NSString stringWithFormat:@" · %@",model.carNo];
   //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
    if ([model.status isEqualToString:@"2"]||[model.status isEqualToString:@"3"]) {
        [self.TwoBtn setImage:[UIImage imageNamed:@"电话－绿色"] forState:(UIControlStateNormal)];
        self.TwoBtn.userInteractionEnabled = YES;
        
    }else {
        [self.TwoBtn setImage:[UIImage imageNamed:@"定位－灰色"] forState:(UIControlStateNormal)];
        self.TwoBtn.userInteractionEnabled = NO;
    }
    ///1-展示，0-不展示
    if ([model.isShowPosition isEqualToString:@"0"]) {
        [self.OneBtn setImage:[UIImage imageNamed:@"定位"] forState:(UIControlStateNormal)];
        self.OneBtn.userInteractionEnabled = NO;
    }else{
        [self.OneBtn setImage:[UIImage imageNamed:@"定位－绿色"] forState:(UIControlStateNormal)];
        self.OneBtn.userInteractionEnabled = YES;
    }
    self.carColor.text =[NSString stringWithFormat:@"%@·%@",model.carColor,model.carBrand];
    self.startPlace.text = model.startPlace;
    self.endPlace.text = model.endPlace;
    self.startTime.text = [NSString stringWithFormat:@"出发时间:%@",model.startTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
