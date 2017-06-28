//
//  IndustryListTwoCell.h
//  BianMin
//
//  Created by 席亚坤 on 2017/6/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndustryModel;
@interface IndustryListTwoCell : UITableViewCell
///店铺logo
@property (weak, nonatomic) IBOutlet UIImageView *iconUrl;
///商户名称
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
///卡券使用规则
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/////卡券名称
//@property (nonatomic, strong) NSString  *couponName ;
///1-满减券  2-立减券  3-折扣券
@property (weak, nonatomic) IBOutlet UILabel *couponType;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
///有效期
@property (weak, nonatomic) IBOutlet UILabel *expireTime;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;


///model
@property (nonatomic, strong) IndustryModel *model ;




@end
