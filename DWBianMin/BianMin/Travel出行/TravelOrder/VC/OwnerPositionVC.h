//
//  OwnerPositionVC.h
//  BianMin
//
//  Created by 席亚坤 on 17/2/24.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class TripModel;
@interface OwnerPositionVC : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatarUrl;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *carNo;
@property (weak, nonatomic) IBOutlet UILabel *carColor;

@property (weak, nonatomic) IBOutlet UIButton *OneBtn;
@property (weak, nonatomic) IBOutlet UIButton *TwoBtn;

///TripModel
@property (nonatomic, strong) TripModel  *tripModel ;



@end
