//
//  RefundDetailsThreeCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RefundDetailsThreeCell.h"
#import "RefundModel.h"
@implementation RefundDetailsThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)CellGetData:(RefundModel*)model{
    ///退款状态：1-待审核（已申请），2-拒绝退款（填写原因），3-退款完成
    if ([model.status isEqualToString:@"1"]) {
        self.oneView.hidden = YES;
        self.OneImageV.image = [UIImage imageNamed:@"绿色"];
        //self.OneLabel.textColor = [UIColor greenColor];
        self.OneLabel.textColor = [UIColor colorWithRed:36/255.0 green:171/255.0 blue:94/255.0 alpha:1.0];
        self.Twolabel.textColor = [UIColor colorWithRed:36/255.0 green:171/255.0 blue:94/255.0 alpha:1.0];
        //self.Twolabel.textColor = [UIColor greenColor];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
