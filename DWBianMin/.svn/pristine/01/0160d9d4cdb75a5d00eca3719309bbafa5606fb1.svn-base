//
//  CacheCell.m
//  BianMin
//
//  Created by kkk on 16/5/18.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CacheCell.h"

@implementation CacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)createView {
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
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
