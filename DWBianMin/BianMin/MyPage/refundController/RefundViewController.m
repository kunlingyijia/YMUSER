//
//  RefundViewController.m
//  BianMin
//
//  Created by kkk on 16/5/17.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "RefundViewController.h"
#import "SelectedPasswordViewController.h"
#import "RequestRefundGoodsOrder.h"
#import "RequestMyGoodsOrderDetail.h"
#import "RequestMyGoodsOrderDetailModel.h"
@interface RefundViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *refundLabel;
@property (nonatomic, strong) RequestMyGoodsOrderDetailModel *goodsMessageModel;
@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ShowNodataView];
    // Do any additional setup after loading the view.
    self.title = @"退款";
    [self showBackBtn];
    [self getDataMessage];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 340, Width-20, 80)];
    self.textView.delegate = self;
    self.refundLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 310, Width-20, 20)];
    self.refundLabel.text = @"退款原因:";
    self.refundLabel.font = [UIFont systemFontOfSize:12];
    self.refundLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.view addSubview:self.refundLabel];
    [self.view addSubview:self.textView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedPassword:)];
//    self.passwordLabel.userInteractionEnabled = YES;
//    [self.passwordLabel addGestureRecognizer:tap];

    
}
//- (void)selectedPassword:(UITapGestureRecognizer *)sender {
//    NSLog(@"选择密码");
//    SelectedPasswordViewController *passwordC = [[SelectedPasswordViewController alloc] init];
//    passwordC.coupons = self.coupons;
//    __weak RefundViewController *weakSelf = self;
//    passwordC.selectedPassW = ^(NSString *password) {
//        weakSelf.passwordLabel.text = password;
//    };
//    [self.navigationController pushViewController:passwordC animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == NO) {
        btn.selected = YES;
    }else {
        btn.selected = NO;
    }
}
- (IBAction)refundAction:(id)sender {
    if (self.textView.text.length == 0) {
        [self showToast:@"请输入退款原因"];
    }else {
        RequestRefundGoodsOrder *order = [[RequestRefundGoodsOrder alloc] init];
        order.orderNo = self.messageModel.orderNo;
        order.coupons = self.messageModel.coupons;
        order.goodsOrderId = self.messageModel.goodsOrderId;
        order.content = self.textView.text;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[order yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestRefundGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            NSLog(@"%@", response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [self showToast:@"申请成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }else {
             [self showToast:baseRes.msg];//    [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];

    }
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退款?" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)getDataMessage {
    RequestMyGoodsOrderDetail *detail = [[RequestMyGoodsOrderDetail alloc] init];
    detail.orderNo = self.messageModel.orderNo;
    detail.goodsOrderId = self.messageModel.goodsOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[detail yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyGoodsOrderDetail" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.goodsMessageModel = [RequestMyGoodsOrderDetailModel yy_modelWithJSON:baseRes.data];
            [self showData];
            [self HiddenNodataView];
        }else {
          [self showToast:baseRes.msg];//   [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
}

- (void)showData {
    NSMutableArray *couponArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.goodsMessageModel.coupons) {
        NSString *status = dic[@"status"];
        NSLog(@"%@", status);
        if ([status isEqualToString:@"1"]) {
            [couponArr addObject:dic];
        }
    }
    NSInteger useCount = self.goodsMessageModel.coupons.count - couponArr.count;
    NSLog(@"%ld", useCount);
    if (useCount == self.goodsMessageModel.coupons.count) {
        self.refundMoney.text = [NSString stringWithFormat:@"%.2f", self.goodsMessageModel.payAmount];
    }else {
        CGFloat price = self.goodsMessageModel.price;
        CGFloat allPrice = self.goodsMessageModel.payAmount - couponArr.count * price;
        self.refundMoney.text = [NSString stringWithFormat:@"%.2f", allPrice];
    }
    
    self.passwordLabel.text = [NSString stringWithFormat:@"订单号:%@", self.goodsMessageModel.orderNo];
    ///退款，1-支持，0-否
    if ([self.goodsMessageModel.isSupportRefund isEqualToString:@"1"]) {
        [self.reason removeFromSuperview];
        self.textView.userInteractionEnabled = YES;
        _submitBtn.userInteractionEnabled = YES;


    }else if ([self.goodsMessageModel.isSupportRefund isEqualToString:@"0"]){
        self.reason.text = self.goodsMessageModel.reason;
        _submitBtn.userInteractionEnabled = NO;
        self.textView.userInteractionEnabled = NO;
        _submitBtn.backgroundColor = [UIColor grayColor];
        
    }else{
        [self.reason removeFromSuperview];

    }
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, 120, self.textView.frame.size.width, self.textView.frame.size.height);
    self.refundLabel.frame = CGRectMake(10, 100, Width-20, 20);
    self.fiveLabel.hidden = YES;
    self.firstLabel.hidden = YES;
    self.secondLabel.hidden= YES;
    self.thirdLabel.hidden = YES;
    self.fourLbael.hidden = YES;
    self.refundMoney.hidden = YES;
    self.sixLabel.hidden = YES;
    self.sevenLabel.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"结束编辑");
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, 320, self.textView.frame.size.width, self.textView.frame.size.height);
    self.refundLabel.frame = CGRectMake(10, 300, Width-20, 20);
    self.fiveLabel.hidden = NO;
    self.firstLabel.hidden = NO;
    self.secondLabel.hidden= NO;
    self.thirdLabel.hidden = NO;
    self.fourLbael.hidden = NO;
    self.refundMoney.hidden = NO;
    self.sixLabel.hidden = NO;
    self.sevenLabel.hidden = NO;
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