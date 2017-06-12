//
//  GoodsCell.m
//  BianMin
//
//  Created by kkk on 16/5/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsCell.h"
#define Space 5
@implementation GoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    self.nameLabel.text = @"干锅小龙虾(3斤)";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(2*Space);
        make.top.equalTo(self.contentView.mas_top).with.offset(Space);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-Space);
        make.width.mas_equalTo(@(100));
    }];
    
    self.numLabel = [UILabel new];
    self.numLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.numLabel.text = @"1份";
    self.numLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.numLabel];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"¥156";
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.priceLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-2*Space);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(@(1));
    }];
    
//    UILabel *secondLine = [UILabel new];
//    secondLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
//    [self.contentView addSubview:secondLine];
//    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.equalTo(self.contentView);
//        make.top.equalTo(self.contentView.mas_top).with.offset(0);
//        make.height.mas_equalTo(@(1));
//    }];
    
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
