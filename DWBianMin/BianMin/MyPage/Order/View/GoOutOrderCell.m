//
//  GoOutOrderCell.m
//  BianMin
//
//  Created by kkk on 16/8/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoOutOrderCell.h"

@interface GoOutOrderCell()
@property (nonatomic, strong) RequestTripOrderListModel *model;

@end

@implementation GoOutOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellGetDataWithModel:(RequestTripOrderListModel *)model {
    self.model = model;
    self.adressLabel.text = [NSString stringWithFormat:@"%@-%@",model.getOnPlace, model.getDownPlace];
    self.cardNum.text = model.carNo;
    self.carType.text = model.carType;
    self.timeLabel.text = [NSString stringWithFormat:@"%@开",[model.startTime substringToIndex:16]];
    self.payBtn.hidden = NO;
    switch (model.status) {
        case 1:
            self.statusL.text = @"已预约";
            break;
        case 2:
            self.statusL.text = @"已完成";
            self.payBtn.hidden = YES;
            break;
        case 3:
            self.statusL.text = @"已退订";
            self.payBtn.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)payAction:(id)sender {
    self.backBlockAction(self.model.orderNo);
}

@end
