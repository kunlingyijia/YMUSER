//
//  industryUseOneCell.h
//  BianMin
//
//  Created by 席亚坤 on 2017/6/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndustryModel;
@interface industryUseOneCell : UITableViewCell
///model
@property (nonatomic, strong) IndustryModel *model ;
@property (weak, nonatomic) IBOutlet UIView *LeftView;

@property (weak, nonatomic) IBOutlet UILabel *faceAmount;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *limitAmount;

@property (weak, nonatomic) IBOutlet UILabel *beginTimeAndendtime;

@end
