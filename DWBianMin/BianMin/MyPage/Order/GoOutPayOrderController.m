//
//  PayOrderController.m
//  Go
//
//  Created by 月美 刘 on 16/8/31.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "GoOutPayOrderController.h"
#import "RequestTripDetail.h"
#import "RequestTripDetailModel.h"
#import "RequestPayTripOrder.h"
#import "RequestTripDetailModel.h"
#import "RequestPayTripOrderModel.H"
#import "GoingOutMessageController.h"
@interface GoOutPayOrderController ()
@property (nonatomic, strong) RequestTripDetailModel *tripModel;
@property (nonatomic, assign) NSInteger payType;
@end

@implementation GoOutPayOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"支付订单";
    self.payType = 1;
    
    self.confirmPayBtn.layer.masksToBounds = YES;
    self.confirmPayBtn.layer.cornerRadius = 4;
    [self createView];
    //支付成功后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessAction:) name:@"支付成功" object:nil];
    
}

- (void)paySuccessAction:(NSNotification *)sender {
    GoingOutMessageController *payBack = [[GoingOutMessageController alloc] initWithNibName:@"GoingOutMessageController" bundle:nil];
    payBack.isNewC = 6;
    [self showSuccessWith:@"支付成功"];
    payBack.orderNo = self.tripModel.orderNo;
    [self.navigationController pushViewController:payBack animated:YES];
}

- (void)createView {
    UITapGestureRecognizer *aliTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliPayImage:)];
    self.aliPayBg.userInteractionEnabled = YES;
    [self.aliPayBg addGestureRecognizer:aliTap];
    UITapGestureRecognizer *wxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxPayImage:)];
    [self.wxPayBg addGestureRecognizer:wxTap];
    self.wxPayBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *moneyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyPayImage:)];
    self.moneyPayBg.userInteractionEnabled = YES;
    [self.moneyPayBg addGestureRecognizer:moneyTap];
    [self getGoOutMessage];
}

- (void)aliPayImage:(UITapGestureRecognizer *)sender {
    self.chooseWeixin.hidden = YES;
    self.chooseOffline.hidden = YES;
    self.chooseZhifubao.hidden = NO;
    self.payType= 1;
}
- (void)wxPayImage:(UITapGestureRecognizer *)sender {
    self.chooseWeixin.hidden = NO;
    self.chooseOffline.hidden = YES;
    self.chooseZhifubao.hidden = YES;
    self.payType= 2;
}
- (void)moneyPayImage:(UITapGestureRecognizer *)sender {
    self.chooseWeixin.hidden = YES;
    self.chooseOffline.hidden = NO;
    self.chooseZhifubao.hidden = YES;
    self.payType= 4;
}


- (void)viewGetData {
    self.orderNo.text = [NSString stringWithFormat:@"%@", self.tripModel.orderNo];
    self.orderDate.text = [self.tripModel.startTime substringToIndex:10];
    self.startPlace.text = self.tripModel.startPlace;
    self.endPlace.text = self.tripModel.endPlace;
    self.carNo.text = self.tripModel.carNo;
    NSString *startT = [self.tripModel.startTime substringToIndex:16];
    self.startTime.text = [startT substringFromIndex:11];
    NSString *endT = [self.tripModel.arriveTime substringToIndex:16];
    self.arriveTime.text = [endT substringFromIndex:11];
}


- (IBAction)ConfirmPayBtnClick:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.placeholder  = @"请输入金额";
        
    }];
    UITextField *textField = [alertC.textFields firstObject];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (self.payType) {
                case 1:
                    [self payActionWithPyte:1 withPrice:textField.text];
                    break;
                case 2:
                    [self payActionWithPyte:2 withPrice:textField.text];
                    break;
                case 4:
                    [self payActionWithPyte:4 withPrice:textField.text];
                    break;
                default:
                    break;
            }

        });
    }]];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
    

}

#pragma mark - networking
- (void)getGoOutMessage {
    RequestTripDetail *detail = [[RequestTripDetail alloc] init];
    detail.orderNo = self.orderNumber;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[detail yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Trip/requestTriporderDetail" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes  = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            self.tripModel = [RequestTripDetailModel yy_modelWithJSON:baseRes.data];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self viewGetData];
    } faild:^(id error) {
        
    }];
}

- (void)payActionWithPyte:(NSInteger)payType withPrice:(NSString *)price{
    self.confirmPayBtn.userInteractionEnabled = NO;
    RequestPayTripOrder *tripOrder = [[RequestPayTripOrder alloc] init];
    tripOrder.payType = payType;
    tripOrder.orderNo = self.tripModel.orderNo;
    tripOrder.payAmount = price;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[tripOrder yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Trip/requestPayTripOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (payType == 4) {
                self.confirmPayBtn.userInteractionEnabled = YES;
                    GoingOutMessageController *payBack = [[GoingOutMessageController alloc] initWithNibName:@"GoingOutMessageController" bundle:nil];
                payBack.isNewC = 6;
                [payBack showSuccessWith:@"线下支付成功"];
                payBack.orderNo = self.tripModel.orderNo;
                [self.navigationController pushViewController:payBack animated:YES];
            }else {
                self.confirmPayBtn.userInteractionEnabled = YES;
                RequestPayTripOrderModel *payModel = [RequestPayTripOrderModel yy_modelWithJSON:baseRes.data];
                [self payActionWithModel:payModel];
            }
        }else {
            self.confirmPayBtn.userInteractionEnabled = YES;
        }
    } faild:^(id error) {
        self.confirmPayBtn.userInteractionEnabled = YES;
        NSLog(@"%@", error);
    }];
}

- (void)payActionWithModel:(RequestPayTripOrderModel *)model {
    switch (self.payType) {
        case 1:
            NSLog(@"%@", model.orderNo);
            [DWHelper AliPayActionWithOrderStr:model.prealipay];
            break;
        case 2:
            if (        [WXApi isWXAppInstalled]
) {
                [DWHelper WXpayAction:model.prepayid withpartnerId:model.partnerid withpackage:model.package withnonceStr:model.noncestr withtimeStamp:model.timestamp withsign:model.sign];
            }else{
                [self showToast:@"尚未安装微信"];
            }
            
            
            break;
            
        default:
            break;
    }
}



@end
