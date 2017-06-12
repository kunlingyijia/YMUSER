//
//  RefundReasonsCell.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/22.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RefundReasonsCell.h"
#import "RefundModel.h"
@implementation RefundReasonsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
}
-(void)CellGetData:(RefundModel*)model{
    self.title.text = model.title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    if (selected) {
        
        self.imageV.image = [UIImage imageNamed:@"选中"];
    }else
    {
        self.imageV.image = [UIImage imageNamed:@"未选中"];
        
    }
}

@end
