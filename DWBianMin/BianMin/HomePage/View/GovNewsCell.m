//
//  NewsCell.m
//  BianMin
//
//  Created by kkk on 16/5/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GovNewsCell.h"
#import "RequestGovAffairsListModel.h"
#define Space 10
@implementation GovNewsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.pictureImage = [UIImageView new];
    self.pictureImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.pictureImage];
    [self.pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(Space);
        make.size.mas_offset(CGSizeMake(80, 48));
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(Space);
        make.left.equalTo(self.pictureImage.mas_right).with.offset(Space/2);
        make.size.mas_equalTo(CGSizeMake(Width-85, 20));
    }];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.pictureImage.mas_right).with.offset(Space/2);
        make.right.equalTo(self.contentView).with.offset(-Space);
        make.height.mas_equalTo(@(40));
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

- (void)setDataSource:(RequestGovAffairsListModel *)model{
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.subTitle;
    [self.pictureImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    
}

@end
