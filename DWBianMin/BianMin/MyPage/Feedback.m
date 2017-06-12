//
//  Feedback.m
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "Feedback.h"
#import "RequestFeedback.h"
@interface Feedback()

@property (nonatomic, strong) UITextView *contentView;

@end

@implementation Feedback

- (void)viewDidLoad{
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"意见反馈";
    
    [self initWithCumstomView];
}

- (void)initWithCumstomView{
    UIView *feedBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 16, Width - 20, 160)];
    feedBackView.layer.cornerRadius = 10;
    feedBackView.layer.masksToBounds = YES;
    feedBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:feedBackView];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setBackgroundColor:[UIColor colorWithHexString:kNavigationBgColor]];
    submit.frame = CGRectMake(10, feedBackView.frame.origin.y + feedBackView.frame.size.height + 20, Width - 20, 40);
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    [submit setTitle:@"发送" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, Width - 40, 140)];
    self.contentView.textColor = [UIColor colorWithHexString:kTitleColor];

    [feedBackView addSubview:self.contentView];
}

- (void)submitAction:(UIButton *)sender {
    if (self.contentView.text.length == 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"反馈内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }else {
        UIButton *btn = sender;
        sender.userInteractionEnabled = NO;
        [self showProgress];
        RequestFeedback *feedback = [[RequestFeedback alloc] init];
        feedback.content = self.contentView.text;
        
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[feedback yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        baseReq.encryptionType = AES;
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestFeedback" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [self hideProgress];
                [self showToast:@"反馈成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    btn.userInteractionEnabled = YES;
                });
            }else {
                [self hideProgress];
                btn.userInteractionEnabled = YES;
                [self showToast:baseRes.msg];//

               //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            }
            
        } faild:^(id error) {
            [self hideProgress];
            btn.userInteractionEnabled = YES;
        }];
        
    }
    
}


@end
