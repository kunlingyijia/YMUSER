//
//  CouponMessageViewController.m
//  BianMin
//
//  Created by kkk on 16/6/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CouponMessageViewController.h"
#import "RequestMerchantCouponListModel.h"
#import "RequestReceiveCoupon.h"
@interface CouponMessageViewController ()

@end

@implementation CouponMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newShowBackBtn];
    [DWHelper SD_WebImage:self.iconUrl imageUrlStr:self.iconUrlStr placeholderImage:nil];
    self.couponName.text = self.model.couponName;
    
    self.nameLabel.text =  self.model.merchantName;
    self.strarTime.text =[NSString stringWithFormat:@"%@", self.model.beginTime];
    
    self.endTime.text =[NSString stringWithFormat:@"%@", self.model.endTime];
    self.nameLabel.text = self.title;
    if (self.model.couponType == 1) {
        self.couponImageV.image = [UIImage imageNamed:@"bg_my_youhuiquan_manjianquan"];
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.model.mVaule];
        self.couponContent.text = [NSString stringWithFormat:@"单笔消费满%.2f元,减%.2f元", self.model.mPrice, self.model.mVaule];
    }else if (self.model.couponType == 2) {
        self.couponImageV.image = [UIImage imageNamed:@"bg_my_youhuiquan_lijianjuan"];
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.model.lValue];
        self.couponContent.text = [NSString stringWithFormat:@"下单立减%.2f元", self.model.lValue];
    }else {
        self.couponImageV.image = [UIImage imageNamed:@"bg_my_youhuiquan_zhekouquan"];
        self.yuan.hidden = YES;
        if (self.model.dValue%10 == 0) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.0f", self.model.dValue/10.0];
        }else {
             self.priceLabel.text = [NSString stringWithFormat:@"%.1f", self.model.dValue/10.0];
        }
        
        self.couponContent.hidden = YES;
        self.couponL.text = @"折";
    }
    
    if (self.model.isReceived == 1) {
        self.sureBtn.userInteractionEnabled = NO;
        [self.sureBtn setTitle:@"已领取" forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = [UIColor grayColor];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    
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
//    self.balckBlock(nil);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureAction:(id)sender {
    RequestReceiveCoupon *coupon = [[RequestReceiveCoupon alloc] init];
    __weak typeof(self) weakSelf = self;

    coupon.couponId = self.model.couponId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[coupon yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestReceiveCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.sureBtn.userInteractionEnabled = NO;
            self.sureBtn.backgroundColor = [UIColor grayColor];
            [self.sureBtn setTitle:@"已领取" forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"领取成功" object:@"领取成功" userInfo:@{}];
        }else {
            [weakSelf showToast:baseRes.msg];
           // [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
    }];
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