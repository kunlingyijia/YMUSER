//
//  CommentMoreCell.m
//  BianMin
//
//  Created by kkk on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CommentMoreCell.h"

@implementation CommentMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView  {
    UILabel *commentLabel = [UILabel new];
    [self.contentView addSubview:commentLabel];
    commentLabel.text = @"查看全部评论";
    commentLabel.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    commentLabel.font = [UIFont systemFontOfSize:12];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.width.mas_equalTo(@(100));
        make.height.mas_equalTo(@(20));
    }];
    
    self.numberLabel = [UILabel new];
    self.numberLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    self.numberLabel.text = @"1264条评论";
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(100));
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
