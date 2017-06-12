//
//  WIFIViewCell.m
//  BianMin
//
//  Created by kkk on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "WIFIViewCell.h"

@implementation WIFIViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UILabel *label = [UILabel new];
    [self.contentView addSubview:label];
    label.text = @"仅Wi-Fi下显示图片";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:kTitleColor];
//    label.backgroundColor = [UIColor redColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).with.offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(@(200));
    }];
    
    self.wifiSwitch = [UISwitch new];
    self.wifiSwitch.onTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.contentView addSubview:self.wifiSwitch];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *isNetWorkImage = [userDefault objectForKey:@"isNetWorkImage"];
    if ([isNetWorkImage integerValue]) {
        self.wifiSwitch.on = YES;
    }else {
        self.wifiSwitch.on = NO;
    }
    
    [self.wifiSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.wifiSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).with.offset(5);
        make.right.mas_equalTo(self.contentView ).with.offset(-10);
        make.bottom.mas_equalTo(self.contentView).with.offset(-5);
        make.width.mas_equalTo(@(50));
    }];
}

- (void)onSwitch:(UISwitch *)sender {
    DWHelper *helper = [DWHelper shareHelper];
    helper.isWifiOn = sender.isOn;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (sender.isOn) {
        [userDefault setObject:@(1) forKey:@"isNetWorkImage"];
    }else {
        [userDefault setObject:@(0) forKey:@"isNetWorkImage"];
    }
    OKLog(@"%d", sender.isOn?YES : NO);
    
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
