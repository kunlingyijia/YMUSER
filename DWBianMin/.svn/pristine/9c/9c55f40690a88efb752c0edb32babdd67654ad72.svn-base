//
//  RefundApplyBtnCell.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RefundApplyBtnCell.h"
#import "RefundModel.h"
@implementation RefundApplyBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)CellGetData:(RefundModel*)model{
    //1-支持退款，0-不支持退款
    if ([model.isSupportRefund isEqualToString:@"0"]) {
        self.RefunBtn.backgroundColor = [UIColor lightGrayColor];
        self.RefunBtn.userInteractionEnabled = NO;
    }else{
        self.RefunBtn.userInteractionEnabled = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
