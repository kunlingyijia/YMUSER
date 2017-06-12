//
//  RefundDetailsOneCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RefundDetailsOneCell.h"
#import "RefundModel.h"

@implementation RefundDetailsOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;}
-(void)CellGetData:(RefundModel*)model{
    self.payAmount.text = [NSString stringWithFormat:@"%@元",model.payAmount];
    self.refundServiceFee.text = [NSString stringWithFormat:@"%@元",model.refundServiceFee];
    self.refundAmount.text = [NSString stringWithFormat:@"%@元",model.refundAmount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
