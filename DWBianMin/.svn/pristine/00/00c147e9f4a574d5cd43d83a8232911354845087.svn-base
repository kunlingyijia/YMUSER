//
//  DropDownCell.m
//  BianMin
//
//  Created by kkk on 16/4/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DropDownCell.h"

#import "Masonry.h"

@implementation DropDownCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatrView];
    }
    return self;
}

- (void)creatrView {
    self.pictureView = [[UIImageView alloc] init];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.pictureView];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(@(100));
        
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(@(20));
    }];
    
    
}





@end
