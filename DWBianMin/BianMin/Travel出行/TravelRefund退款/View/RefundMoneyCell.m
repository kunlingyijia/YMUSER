//
//  RefundMoneyCell.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RefundMoneyCell.h"
#import "RefundModel.h"
@implementation RefundMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
