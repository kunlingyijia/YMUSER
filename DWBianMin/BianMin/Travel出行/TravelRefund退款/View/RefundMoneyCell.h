//
//  RefundMoneyCell.h
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RefundModel;
@interface RefundMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payAmount;
@property (weak, nonatomic) IBOutlet UILabel *refundServiceFee;
@property (weak, nonatomic) IBOutlet UILabel *refundAmount;
-(void)CellGetData:(RefundModel*)model;
@end
