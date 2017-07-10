//
//  TripAppointmentController.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripAppointmentController.h"
#import "TripModel.h"
#import "requestVerifyCode.h"
#import "TripPayVC.h"
#import "industryUseVC.h"
#import "IndustryModel.h"
#import "TravelOrderVC.h"
@interface TripAppointmentController ()

@end

@implementation TripAppointmentController
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"预约";
    self.avatarUrl.layer.masksToBounds = YES;
    self.avatarUrl.layer.cornerRadius =(0.2*Width-20)/2;
    self.verifyCodeBtn.layer.masksToBounds = YES;
    self.verifyCodeBtn.layer.cornerRadius =5;
    self.verifyCodeBtn.layer.borderWidth = 1.0;
    self.verifyCodeBtn.layer.borderColor =[UIColor colorWithHexString:kNavigationBgColor].CGColor;
    [self endEditingAction:self.view];
    //可滑动的高度
    self.contentHeight.constant = Height-64;;
}
#pragma mark - 关于数据
-(void)SET_DATA{
    [self kongjianfuzhi];
    
    
    
}


-(void)kongjianfuzhi{
    
    [self.avatarUrl sd_setImageWithURL:[NSURL URLWithString:self.tripModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"bg_zaijia_1-1"]];
    self.realName.text = self.tripModel.realName;
    ///性别 0-女 1-男
    if ([self.tripModel.gender isEqualToString:@"0"]) {
        self.gender.image = [UIImage imageNamed:@"性别－女"];
    }else{
        self.gender.image = [UIImage imageNamed:@"性别－男"];
    }
    self.carNo.text = [NSString stringWithFormat:@" · %@",self.tripModel.carNo];
    

    self.date.text = [NSString stringWithFormat:@"出发时间:%@ %@",self.tripModel.date,self.tripModel.time];
    self.carColor.text =[NSString stringWithFormat:@"%@·%@",self.tripModel.carColor,self.tripModel.carBrand];
    self.startPlace.text = self.tripModel.startPlace;
    self.endPlace.text = self.tripModel.endPlace;
    self.price.text =[NSString stringWithFormat:@"支付金额:%@元", self.tripModel.price];
    [_industryCouponUser setTitle:self.tripModel.industryCouponUserId.length ==0 ?@"使用抵用券":@"" forState:0];
    
}


#pragma mark - 获取验证码
- (IBAction)verifyCodeBtnAction:(UIButton *)sender {
    
    if ([self.tel.text isMobileNumber]) {
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                //倒计时结束 改变颜色
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                    sender.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 120;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [sender setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    sender.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        
        requestVerifyCode *verifyCode = [[requestVerifyCode alloc] init];
        verifyCode.mobile = self.tel.text;
        verifyCode.type = 4;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        
        baseReq.data = [verifyCode yy_modelToJSONObject];
        baseReq.encryptionType = RequestMD5;
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestVerifyCode" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
//            NSNumber *resultCode = [response objectForKey:@"resultCode"];
//            
//            if ([resultCode integerValue] == 1) {
//                [self showToast:@"获取验证码成功"];
//            }
            BaseResponse *baseR =[BaseResponse yy_modelWithJSON:response];
            NSNumber *resultCode = [response objectForKey:@"resultCode"];
            
            if ([resultCode integerValue] == 1) {
                [self showToast:@"获取验证码成功"];
            }else{
                [self showToast:baseR.msg];
            }
        } faild:^(id error) {
            
        }];
        
    }else {
        [self alertWithTitle:@"提示" message:@"输入的手机号不正确" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
            
        }];

    }

    
}
- (IBAction)industryCouponUserAction:(UIButton *)sender {
    //Push 跳转
    industryUseVC * VC = [[industryUseVC alloc]initWithNibName:@"industryUseVC" bundle:nil];
   __block IndustryModel * model =[IndustryModel new];
    model.companyId = self.tripModel.companyId;
    model.amount = self.tripModel.price;
    model.industryCouponUserId = self.tripModel.industryCouponUserId;
    __weak typeof(self) weakSelf = self;
    VC.industryUseVCBlock = ^(IndustryModel * industryModel){
    weakSelf.tripModel.industryCouponUserId = industryModel.industryCouponUserId;
    [_industryCouponUser setTitle:weakSelf.tripModel.industryCouponUserId.length == 0 ?@"使用抵用券": [NSString stringWithFormat:@"-¥%@",industryModel.amount]
    forState:0];
    [_industryCouponUser setTitleColor:weakSelf.tripModel.industryCouponUserId.length ==0 ?[UIColor grayColor]: [UIColor redColor]
    forState:0];

    };
    VC.industryModel =model;
    [self.navigationController  pushViewController:VC animated:YES];

    
}

#pragma mark - 调交订单
- (IBAction)addOrderAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.name.text.length==0) {
        [self showToast:@"请输入姓名"];
        return;
    }
    if (self.verifyCode.text.length==0) {
        [self showToast:@"请输入验证码"];
        return;
    }
    
    TripModel *model = [TripModel new];
    NSString *Token =[AuthenticationModel getLoginToken];
    model.planId = self.tripModel.planId;
    model.tel = self.tel.text;
    model.name = self.name.text;
    model.verifyCode = self.verifyCode.text;
    model.remark = self.remark.text;
    model.industryCouponUserId = self.tripModel.industryCouponUserId;
    NSLog(@"%@",model.verifyCode);
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrder/requestAddOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"预约/提交订单----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                TripModel * model = [TripModel yy_modelWithJSON:response[@"data"]];
                
                //Push 跳转
                TripPayVC * VC = [[TripPayVC alloc]initWithNibName:@"TripPayVC" bundle:nil];
                                VC.tripModel = model;
                //Push 跳转
                TravelOrderVC * travelOrderVC = [[TravelOrderVC alloc]initWithNibName:@"TravelOrderVC" bundle:nil];
               // status  1-未支付，2-已支付
                [weakself.navigationController  pushViewController:[model.status isEqualToString:@"1"] ? VC :travelOrderVC animated:YES];
            }else{
                weakself.view.userInteractionEnabled = YES;

                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
 
}



@end
