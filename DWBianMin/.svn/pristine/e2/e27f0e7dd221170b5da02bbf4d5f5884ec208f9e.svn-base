//
//  TOrderDetailsFiveCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TOrderDetailsFiveCell.h"
#import "TripModel.h"
@implementation TOrderDetailsFiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellGetData:(TripModel*)model{
   
    //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
    if ([model.status isEqualToString:@"1"]) {
        [self.oneBtn setTitle:@"未支付" forState:(UIControlStateNormal)];
        self.oneBtn.hidden = YES;
    }else if ([model.status isEqualToString:@"2"]) {
        [self.oneBtn setTitle:@"退款" forState:(UIControlStateNormal)];
        self.oneBtn.hidden = NO;
    }else if ([model.status isEqualToString:@"3"]) {
        [self.oneBtn setTitle:@"我已到达目的地" forState:(UIControlStateNormal)];
        self.oneBtn.hidden = NO;
    }else if ([model.status isEqualToString:@"4"]) {
        [self.oneBtn setTitle:@"已完成" forState:(UIControlStateNormal)];
        self.oneBtn.hidden = YES;
    }else if ([model.status isEqualToString:@"5"]) {
        [self.oneBtn setTitle:@"退款详情" forState:(UIControlStateNormal)];
        self.oneBtn.hidden = NO;
    }else if ([model.status isEqualToString:@"6"]) {
        [self.oneBtn setTitle:@"退款详情" forState:(UIControlStateNormal)];
        self.oneBtn.hidden = NO;
    }else if ([model.status isEqualToString:@"7"]) {
        [self.oneBtn setTitle:@"已取消" forState:(UIControlStateNormal)];
        self.oneBtn.hidden = YES;
    }else{
        
    }
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
