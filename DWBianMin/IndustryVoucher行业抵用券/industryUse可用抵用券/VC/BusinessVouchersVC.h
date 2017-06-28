//
//  BusinessVouchersVC.h
//  BianMin
//
//  Created by 席亚坤 on 2017/6/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class IndustryModel;
@interface BusinessVouchersVC : BaseViewController

@property (nonatomic, copy) void(^ BusinessVouchersVCBlock)(IndustryModel * model);

@property (weak, nonatomic) IBOutlet UIButton *ChoseBtn;

///model
@property (nonatomic, strong) IndustryModel *industryModel ;


@end
