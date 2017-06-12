//
//  TOrderDetailsThreeCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TOrderDetailsThreeCell.h"
#import "TripModel.h"

@implementation TOrderDetailsThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellGetData:(TripModel*)model{
    self.orderNo.text = [NSString stringWithFormat:@"订单号:%@",model.orderNo];
    //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
    if ([model.status isEqualToString:@"1"]) {
        self.status.text = @"未支付";
    }else if ([model.status isEqualToString:@"2"]) {
        self.status.text = @"已支付";
    }else if ([model.status isEqualToString:@"3"]) {
        self.status.text = @"已上车";
    }else if ([model.status isEqualToString:@"4"]) {
        self.status.text = @"已完成";
    }else if ([model.status isEqualToString:@"5"]) {
        self.status.text = @"退款中";
    }else if ([model.status isEqualToString:@"6"]) {
        self.status.text = @"已退款";
    }else if ([model.status isEqualToString:@"7"]) {
        self.status.text = @"已取消";
    }else{
        
    }
    self.price.text = [NSString stringWithFormat:@"支付金额:%@",model.payAmount];
    self.createTime.text = [NSString stringWithFormat:@"下单时间:%@",model.createTime];
    self.remark.text = model.remark;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
