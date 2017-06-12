//
//  AddAdressViewController.h
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class AdressModel;
@interface AddAdressViewController : BaseViewController

@property (nonatomic, copy)void(^amendAdressBlock)(AdressModel *);


@property (weak, nonatomic) IBOutlet UISwitch *onSwitch;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *postCode;
@property (weak, nonatomic) IBOutlet EZTextView *adress;
@property (weak, nonatomic) IBOutlet UILabel *textPlacehode;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property (nonatomic, copy) NSString *isChange;
@property (nonatomic, strong) AdressModel *model;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end
