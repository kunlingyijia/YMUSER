//
//  industryUseVC.h
//  BianMin
//
//  Created by 席亚坤 on 2017/6/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndustryModel;
@interface industryUseVC : BaseViewController
@property (nonatomic, copy) void(^ industryUseVCBlock)(IndustryModel * model);
@property (weak, nonatomic) IBOutlet UIButton *ChoseBtn;
///行业抵用券id
//@property (nonatomic, strong) NSString  *industryCouponId ;
///model
@property (nonatomic, strong) IndustryModel *industryModel ;

@end
