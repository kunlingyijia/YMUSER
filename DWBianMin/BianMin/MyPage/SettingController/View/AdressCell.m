//
//  AdressCell.m
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AdressCell.h"
#import "AdressModel.h"
#define Space 5
@implementation AdressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(2*Space);
    }];
    
    
    self.selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_my_shouhuodizhi_xuanzhong"]];
    self.selectedImage.hidden = YES;
    [self.contentView addSubview:self.selectedImage];
    self.selectedImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.selectedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).with.offset(-4*Space);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
    self.phoneLabel = [UILabel new];
    self.phoneLabel.text = @"12345678910";
    self.phoneLabel.font = [UIFont systemFontOfSize:16];
    self.phoneLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.right.equalTo(self.selectedImage.mas_left).with.offset(-Space);
    }];

    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@(1));
    }];
    
    self.adressLabel = [UILabel new];
    self.adressLabel.font = [UIFont systemFontOfSize:14];
    self.adressLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.adressLabel.text = @"福州市晋安区福新中路永同昌大厦十八楼十八E";
    self.adressLabel.numberOfLines = 0;
    [self.contentView addSubview:self.adressLabel];
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(Space);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).with.offset(-2*Space);
         make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-2*Space);
//        make.height.mas_equalTo(@(20));
    }];
    
}


- (void)cellGetData:(AdressModel *)model {
    if (model.isDefault == YES) {
        self.selectedImage.hidden = NO;
    }else {
        self.selectedImage.hidden = YES;
    }
    self.nameLabel.text = model.userName;
    self.phoneLabel.text = model.mobile;
    self.adressLabel.text =[NSString stringWithFormat:@"%@ %@",model.address   ,model.street];
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
