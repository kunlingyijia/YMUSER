//
//  FootMoreCell.m
//  BianMin
//
//  Created by kkk on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "FootMoreCell.h"

@implementation FootMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UILabel *moreLabel = [UILabel new];
    moreLabel.textAlignment = NSTextAlignmentCenter;
    moreLabel.text = @"更多套餐";
    moreLabel.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    moreLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView.mas_centerX).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
