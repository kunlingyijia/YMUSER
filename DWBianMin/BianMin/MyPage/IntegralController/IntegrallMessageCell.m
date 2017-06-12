//
//  IntegrallMessageCell.m
//  BianMin
//
//  Created by kkk on 16/7/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IntegrallMessageCell.h"

@implementation IntegrallMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetData:(RequestScoreHistoryListModel *)model withVC:(BaseViewController *)vc{
    [vc loadImageWithView:self.pictureImage urlStr:model.originUrl];
    self.nameLabel.text = model.title;
    NSString *str = [model.score substringToIndex:1];
    if ([str isEqualToString:@"-"]) {
        self.integraLabel.text = [NSString stringWithFormat:@"%@积分", model.score];
    }else {
        self.integraLabel.text = [NSString stringWithFormat:@"+%@积分", model.score];
    }
    self.createTime.text = model.createTime;
    
}

@end
