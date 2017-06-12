//
//  PayViewController.m
//  BianMin
//
//  Created by kkk on 16/5/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PayViewController.h"
#import "PayBackViewController.h"
#import "RequestPayOrder.h"
#import "RequestMerchantGoodsListModel.h"
#import "RequestPayOrderModel.h"
#import "UserOrderViewController.h"
#import "RequestMyGoodsOrderListModel.h"
#import "OrderContentViewController.h"
#import "RequestPayGoodsOrder.h"
#import "RequestPayGoodsOrderModel.h"
@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UIView *WXpay;
@property (weak, nonatomic) IBOutlet UIView *AliPay;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic, assign) BOOL isAlipay;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self newShowBackBtn];
    self.title = @"确认支付";
    self.isAlipay = YES;
    UITapGestureRecognizer *wxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxAction:)];
    [self.WXpay addGestureRecognizer:wxTap];
    UITapGestureRecognizer *aliTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliAction:)];
    [self.AliPay addGestureRecognizer:aliTap];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.originUrl]];
    self.nameLabel.text = [NSString stringWithFormat:@"总价:¥%.2f", self.sumPrice];
    self.priceLabel.text = self.goodsModel.goodsName;
    self.onePriceLabel.text = [NSString stringWithFormat:@"单价:%.2f", self.goodsModel.price];
    self.numberLabel.text = [NSString stringWithFormat:@"数量:x%@", self.goodsModel.goodsNumber];
    //支付成功后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessAction:) name:@"支付成功" object:nil];
}

- (void)newShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(newDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)newDoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 支付成功的通知
- (void)paySuccessAction:(NSNotification *)sender {
//    PayBackViewController *payBackC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayBackViewController"];
//    payBackC.payOrderModel = self.payOrderModel;
//    [self.navigationController pushViewController:payBackC animated:YES];
//    UserOrderViewController *userOrder = [[UserOrderViewController alloc] init];
//    userOrder.model = [RequestMyGoodsOrderListModel yy_modelWithJSON:[self.payOrderModel yy_modelToJSONString]];
//    [self.navigationController pushViewController:userOrder animated:YES];
    OrderContentViewController *orderController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderContentViewController"];
    orderController.orderNo = self.payOrderModel.orderNo;
    orderController.goodsOrderId =self.payOrderModel.goodsOrderId;
    orderController.isPayBack = 6;
    [self.navigationController pushViewController:orderController animated:YES];
    
}

- (void)wxAction:(UITapGestureRecognizer *)sender {
    self.isAlipay = NO;
    self.wxPayImage.image = [UIImage imageNamed:@"btn_my_zhifudingdan_dagou"];
    self.payImage.image = [UIImage imageNamed:@""];
    
    
}
- (void)aliAction:(UITapGestureRecognizer *)sender {
    self.isAlipay = YES;
    self.wxPayImage.image = [UIImage imageNamed:@""];
    self.payImage.image = [UIImage imageNamed:@"btn_my_zhifudingdan_dagou"];
}

- (IBAction)payAction:(id)sender {
    OKLog(@"确认支付");
    if (self.isAlipay) {
        [self AliPayAction];
    }else {
        [self getWXdata];
    }
}
#pragma mark - 支付宝
- (void)AliPayAction {
    [self getZFBdata];
    //[self AliPayWith:self.payOrderModel];
}
#pragma mark - 支付宝支付
- (void)getZFBdata {
    RequestPayGoodsOrder *payG = [[RequestPayGoodsOrder alloc] init];
    payG.orderNo = self.payOrderModel.orderNo;
    payG.goodsOrderId = self.payOrderModel.goodsOrderId;
    payG.payType = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[payG yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestPayGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestPayOrderModel *model = [RequestPayOrderModel yy_modelWithJSON:baseRes.data];
            [self AliPayWith:model];
        }else {
          [self showToast:baseRes.msg];//   [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
    
}

- (void)AliPayWith:(RequestPayOrderModel *)model {
    
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        [self showToast:@"尚未安装支付宝"];
        
    }else{
        [DWHelper AliPayActionWithOrderStr:model.prealipay];
    }
//    NSLog(@"%@,%@,%@", model.prealipay, model.goodsName, model.payAmount);
//    
//    
//    
//    
//    [DWHelper AliPayActionWithOrderStr:model.prealipay];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.layer.cornerRadius = 3;
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - 微信支付
- (void)getWXdata {
    RequestPayGoodsOrder *payG = [[RequestPayGoodsOrder alloc] init];
    payG.orderNo = self.payOrderModel.orderNo;
    payG.goodsOrderId = self.payOrderModel.goodsOrderId;
    payG.payType = 2;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[payG yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestPayGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestPayGoodsOrderModel *model = [RequestPayGoodsOrderModel yy_modelWithJSON:baseRes.data];
            [self WXpay:model];
        }else {
          [self showToast:baseRes.msg];//   [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
    
}

- (void)WXpay:(RequestPayGoodsOrderModel *)model {
    if (        [WXApi isWXAppInstalled]
        ) {
       [DWHelper  WXpayAction:model.prepayid withpartnerId:model.partnerid withpackage:model.package withnonceStr:model.noncestr withtimeStamp:model.timestamp withsign:model.sign];
    }else{
        [self showToast:@"尚未安装微信"];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    
    
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
