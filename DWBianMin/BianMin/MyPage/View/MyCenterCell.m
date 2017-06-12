//
//  MyCenterCell.m
//  BianMin
//
//  Created by kkk on 16/4/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyCenterCell.h"
#import "Masonry.h"
@implementation MyCenterCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.pictureImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.pictureImage];
//    
    self.nameLabel =[UILabel new];
    [self.contentView addSubview:self.nameLabel];
    
//    self.rightLabel = [UILabel new];
//    [self.contentView addSubview:self.rightLabel];

    [self.pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(@(30));
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(10);
        make.left.mas_equalTo(self.pictureImage.mas_right).with.offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(@(60));
    }];
    
}





@end
