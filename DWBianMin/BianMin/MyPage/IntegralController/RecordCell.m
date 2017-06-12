//
//  RecordCell.m
//  BianMin
//
//  Created by kkk on 16/7/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataWith:(RequestScoreOrderListModel *)model with:(BaseViewController *)vc {
    [vc loadImageWithView:self.pictureImage urlStr:model.originUrl];
    self.nameLabel.text = model.goodsName;
    self.priceLabel.text = model.score;
    if (model.status == 1) {
        self.handleLabel.text = @"待发货";
    }else if (model.status == 2) {
        self.handleLabel.text = @"已发货";
    }else {
        self.handleLabel.text = @"完成";
    }
}

@end
