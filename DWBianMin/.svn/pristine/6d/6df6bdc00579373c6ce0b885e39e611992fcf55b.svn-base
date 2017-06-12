//
//  ClassLeftCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/3/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ClassLeftCell.h"

@implementation ClassLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.textColor = [UIColor colorWithHexString:kTitleColor];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
        //self.label.textColor = [UIColor redColor];
    }else{
      //self.label.textColor = [UIColor colorWithHexString:kTitleColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
