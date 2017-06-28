//
//  TOrderDetailsThreeCell.h
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TripModel;

@interface TOrderDetailsThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *orderNo;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UITextField *AllPrice;
@property (weak, nonatomic) IBOutlet UITextField *faceAmount;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *createTime;
@property (weak, nonatomic) IBOutlet UILabel *remark;
-(void)CellGetData:(TripModel*)model;
@end
