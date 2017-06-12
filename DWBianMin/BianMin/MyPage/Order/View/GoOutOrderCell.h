//
//  GoOutOrderCell.h
//  BianMin
//
//  Created by kkk on 16/8/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestTripOrderListModel.h"
@interface GoOutOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

- (void)cellGetDataWithModel:(RequestTripOrderListModel *)model;
@property (nonatomic, copy)void(^backBlockAction)(NSString *orderNo);
@end
