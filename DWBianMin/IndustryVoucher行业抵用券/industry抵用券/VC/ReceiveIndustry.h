//
//  ReceiveIndustry.h
//  BianMin
//
//  Created by 席亚坤 on 2017/6/13.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndustryModel;
@interface ReceiveIndustry : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *faceAmount;
///model
@property (nonatomic, strong) IndustryModel *industryModel;
@end
