//
//  RefundDetailsFourCell.h
//  BianMin
//
//  Created by 席亚坤 on 17/2/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RefundModel;
@interface RefundDetailsFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *OneImageV;
@property (weak, nonatomic) IBOutlet UILabel *OneLabel;
@property (weak, nonatomic) IBOutlet UILabel *refuseReason;

@property (weak, nonatomic) IBOutlet UILabel *refundTime;


-(void)CellGetData:(RefundModel*)model;

@end
