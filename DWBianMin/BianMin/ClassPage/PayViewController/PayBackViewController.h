//
//  PayBackViewController.h
//  BianMin
//
//  Created by kkk on 16/5/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "RequestPayOrderModel.h"
@interface PayBackViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *archNum;
@property (nonatomic, strong) RequestPayOrderModel *payOrderModel;
@end
