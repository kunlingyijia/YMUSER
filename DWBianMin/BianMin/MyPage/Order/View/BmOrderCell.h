//
//  BmOrderCell.h
//  BianMin
//
//  Created by kkk on 16/8/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMyBminorderListModel.h"
@interface BmOrderCell : UITableViewCell

@property (nonatomic, copy)void(^cancelOrderBlock)(NSString *orderId, NSString *typeStr,NSString *bminOrderId);

@property (nonatomic, copy)void(^secondBtnAction)(NSString *orderNO ,NSString *bminOrderId);

@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopContent;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

- (void)cellGetDataWithModel:(RequestMyBminorderListModel *)model;

@end
