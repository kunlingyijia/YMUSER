//
//  TripListCell.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripListCell.h"
#import "TripModel.h"
@implementation TripListCell

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
    self.date.text =[NSString stringWithFormat:@"%@ %@", model.date ,model.time];
    
    ///1-正常，2-满员，3-已发车，4-已结束
    if ([model.planStatus isEqualToString:@"1"]) {
        self.states.text = @"去拼车";
    }else if ([model.planStatus isEqualToString:@"2"]) {
        self.states.text = @"满员";
    }else if ([model.planStatus isEqualToString:@"3"]) {
        self.states.text = @"已发车";
    }else if ([model.planStatus isEqualToString:@"4"]) {
        self.states.text = @"已结束";
    }else{
        
    }
    
    if ([model.restNumber isEqualToString:@"0"]) {
        self.restNumber.text = @"已满员";
        self.states.backgroundColor = [UIColor grayColor];
    }else{
        self.restNumber.text = [NSString stringWithFormat:@"剩余%@座",model.restNumber];
        self.states.backgroundColor = [UIColor colorWithRed:255/255.0 green:204.0/255 blue:102.0/255 alpha:1.0];
    }
    
    
    
    self.carColor.text =[NSString stringWithFormat:@"%@·%@",model.carColor,model.carBrand];
    self.startPlace.text = model.startPlace;
    self.endPlace.text = model.endPlace;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
