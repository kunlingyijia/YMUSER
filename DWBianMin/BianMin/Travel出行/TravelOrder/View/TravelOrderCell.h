//
//  TravelOrderCell.h
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TripModel;
@interface TravelOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarUrl;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *carNo;
@property (weak, nonatomic) IBOutlet UILabel *carColor;

@property (weak, nonatomic) IBOutlet UILabel *states;

@property (weak, nonatomic) IBOutlet UITextField *startPlace;
@property (weak, nonatomic) IBOutlet UITextField *endPlace;
-(void)CellGetData:(TripModel*)model;
@end
