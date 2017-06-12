//
//  ServiceDetailsVC.h
//  BianMin
//
//  Created by 席亚坤 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class TripModel;
@interface ServiceDetailsVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatarUrl;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *carNo;
@property (weak, nonatomic) IBOutlet UILabel *carColor;
@property (weak, nonatomic) IBOutlet UITextField *startPlace;
@property (weak, nonatomic) IBOutlet UITextField *endPlace;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UILabel *seatNumber;
@property (weak, nonatomic) IBOutlet PublicBtn *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *Map;

///TripModel
@property (nonatomic, strong) TripModel  *tripModel ;



@end
