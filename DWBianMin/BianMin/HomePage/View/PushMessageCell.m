//
//  PushMessageCell.m
//  BianMin
//
//  Created by kkk on 16/7/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PushMessageCell.h"
#import "RequestMerchantCategoryListModel.h"
@implementation PushMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //Cell背景颜色
    //self.contentView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}
-(void)setModel:(RequestMerchantCategoryListModel *)model{
    if (!model) return;
    _model = model;
    self.timeLabel.text = model.createTime;
    self.nameLabel.text = model.title;
    self.messageLabel.text = model.content;

}
@end
