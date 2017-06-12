//
//  GoingSucessListViewCell.m
//  BianMin
//
//  Created by kkk on 16/6/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoingSucessListViewCell.h"
#import "RequestMyTripListModel.h"
@implementation GoingSucessListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataWithModel:(RequestMyTripListModel *)model {
    self.adressLabel.text = [NSString stringWithFormat:@"%@-%@", model.startPalce, model.endPalce];
    NSLog(@"%@", model.endPalce);
    self.phoneLabel.text = model.contactMobile;
    self.dateLabel.text = [model.startTime substringToIndex:9];
    self.timeLabel.text = [model.startTime substringFromIndex:10];
    self.peopleLabel.text = [NSString stringWithFormat:@"人数:%@", model.peopleAccount];
}


@end
