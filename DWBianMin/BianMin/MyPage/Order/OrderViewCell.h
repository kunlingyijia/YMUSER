//
//  OrderViewCell.h
//  BianMin
//
//  Created by kkk on 16/5/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMyGoodsOrderListModel.h"

@interface OrderViewCell : UITableViewCell

@property (nonatomic ,copy)void(^talkBlock)(OrderViewCell *);
@property (nonatomic ,copy)void(^cancelAction)(NSString *);

@property (nonatomic, strong)UIImageView *pictureView;
@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *isOrNotPay;
@property (nonatomic, strong)UIButton *payOrTalkBtn;
@property (nonatomic, strong) UILabel *onePrice;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
- (void)cellGetDataWithModel:(RequestMyGoodsOrderListModel *)model WithController:(BaseViewController *)vc;
@end
