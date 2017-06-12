//
//  TOrderDetailsTwoCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TOrderDetailsTwoCell.h"
#import "TripModel.h"

@implementation TOrderDetailsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellGetData:(TripModel*)model{
    //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
    if ([model.status isEqualToString:@"2"]) {
        self.status.text    = @"未使用";
        self.statusimag.image = [UIImage imageNamed:@"二维码－可用"];
        self.oneBtn.userInteractionEnabled = YES;
        
    }else {
       
        self.status.text    = @"已使用";
        self.statusimag.image = [UIImage imageNamed:@"二维码－不可用"];
        self.oneBtn.userInteractionEnabled = NO;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
