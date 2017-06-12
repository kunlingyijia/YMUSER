//
//  AlterViewController.h
//  BianMin
//
//  Created by kkk on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface AlterViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *codeNum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *againPassword;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end
