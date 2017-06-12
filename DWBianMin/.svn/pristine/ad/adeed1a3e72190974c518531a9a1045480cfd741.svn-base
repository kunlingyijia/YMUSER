//
//  GoingSuccessViewController.m
//  BianMin
//
//  Created by kkk on 16/6/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoingSuccessViewController.h"

@interface GoingSuccessViewController ()

@end

@implementation GoingSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self newShowBackBtn];
}

- (void)newShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"icon_arrows_left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(newDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)newDoBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createView {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_chuxing_tupian"]];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.frame = CGRectMake(20, 94, Width - 40, Width - 40);
    [self.view addSubview:imageV];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 2;
    sureBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [sureBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-30);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.height.mas_equalTo(@(30));
    }];
}

- (void)sureAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
