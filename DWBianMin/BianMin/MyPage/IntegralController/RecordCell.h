//
//  RecordCell.h
//  BianMin
//
//  Created by kkk on 16/7/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestScoreOrderListModel.h"
@interface RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)cellGetDataWith:(RequestScoreOrderListModel *)model with:(BaseViewController *)vc;

@end
