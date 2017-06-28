//
//  ReceiveIndustry.m
//  BianMin
//
//  Created by 席亚坤 on 2017/6/13.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ReceiveIndustry.h"
#import "IndustryModel.h"
@interface ReceiveIndustry ()
@end
@implementation ReceiveIndustry
- (void)viewDidLoad {
    [super viewDidLoad];
    //控制器通明的关键代码
    self.modalPresentationStyle =UIModalPresentationCustom;
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.name.text = self.industryModel.name;
    NSMutableAttributedString * faceAmount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", self.industryModel.faceAmount]];
    [faceAmount addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:10]
                       range:NSMakeRange(0, 1)];
    [faceAmount addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:20]
                       range:NSMakeRange(1, _industryModel.faceAmount.length-2)];
    _faceAmount.attributedText  =faceAmount;
}
- (IBAction)submitAction:(UIButton *)sender {
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[self.industryModel yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        self.view.userInteractionEnabled = NO;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/IndustryCouponReceive/requestIndustryCouponReceive" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            [weakself showToast:baseRes.msg];
                if (baseRes.resultCode ==1) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        weakself.view.userInteractionEnabled = YES;
                        [weakself dismissViewControllerAnimated:YES completion:nil];
                    });
                }else{
                weakself.view.userInteractionEnabled = YES;
                }
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
    }else {
        
    }

}
#pragma mark - 返回
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end
