//
//  CommitOrderController.m
//  BianMin
//
//  Created by kkk on 16/5/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CommitOrderController.h"
#import "PayViewController.h"
#import "RequestMerchantGoodsListModel.h"
#import "RequestPayOrder.h"
#import "RequestPayOrderModel.h"
#import "PayBackViewController.h"
#import "RequestMyCouponList.h"
#import "RequestMyCouponListModel.h"
#import "UseCouponViewController.h"
#import "OrderContentViewController.h"
@interface CommitOrderController ()
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, strong) RequestMyCouponListModel *couponModel;
@end

@implementation CommitOrderController
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (IBAction)addNumberAction:(id)sender {
    NSInteger num = [self.numberLabel.text integerValue];
    num = num + 1;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    CGFloat sum = num * self.goodsModel.discountedPrice;
    self.sumLabel.text = [NSString stringWithFormat:@"%.2f", sum];
//    self.couponPriceLabel.text = self.sumLabel.text;
    [self couponGetData];
}
- (IBAction)reduceNumberAction:(id)sender {
    NSInteger num = [self.numberLabel.text integerValue];
    if (num > 1) {
        num = num - 1;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
        CGFloat sum = num * self.goodsModel.discountedPrice;
            self.sumLabel.text = [NSString stringWithFormat:@"%.2f", sum];
    }
    [self couponGetData];
}

- (void)getCouponList {
    RequestMyCouponList *couponList = [[RequestMyCouponList alloc] init];
    couponList.pageCount = 1000;
    couponList.pageIndex = 1;
    couponList.merchantId = self.merchantId;
    couponList.status = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[couponList yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestMyCouponList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestMyCouponListModel *model = [RequestMyCouponListModel yy_modelWithDictionary:dic];
                if (model.status == 1) {
                   [self.dataSource addObject:model];
                }
            }
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self couponGetData];
    } faild:^(id error) {
       
    }];
}
- (void)couponGetData {
    RequestMyCouponListModel *model = [self getCouponModelWithPrice:[self.sumLabel.text floatValue]];
    if (model == nil || model == NULL) {
        self.couponLabel.text = @"没有可用优惠券";
        self.couponPriceLabel.text = self.sumLabel.text;
    }else {
        if (model.couponType == 1) {
            self.couponLabel.text = [NSString stringWithFormat:@"%@:满%.2f元,减%.2f元",model.couponName, model.mPrice, model.mVaule];
            self.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self.sumLabel.text floatValue] - model.mVaule];
            self.couponModel = model;
        }else if (model.couponType == 2) {
            self.couponLabel.text = [NSString stringWithFormat:@"%@:下单立减%.2f元",model.couponName, model.lValue];
            if ([self.sumLabel.text floatValue] - model.lValue < 0) {
                self.couponPriceLabel.text = @"0";
            }else {
                self.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self.sumLabel.text floatValue] - model.lValue];
            }
            self.couponModel = model;
        }else if (model.couponType == 3) {
            self.couponLabel.text = [NSString stringWithFormat:@"%@:%.1f折",model.couponName, model.dValue/10.0];
            self.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self.sumLabel.text floatValue] * model.dValue/100];
            self.couponModel = model;
        }
    }
}



- (IBAction)commitAction:(id)sender {
    [self showProgress];
    RequestPayOrder *order = [[RequestPayOrder alloc] init];
    order.goodsId = self.goodsModel.goodsId;
    order.number = [self.numberLabel.text integerValue];
    if (self.couponModel.couponId != nil || self.couponModel.couponId != NULL) {
        order.couponId = self.couponModel.couponId;
    }
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[order yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestAddGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestPayOrderModel *model = [RequestPayOrderModel yy_modelWithJSON:baseRes.data];
            [self payAction:model];
        }else {
            [self showToast:baseRes.msg];

           // [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self hideProgress];
    } faild:^(id error) {
        NSLog(@"%@", error);
        [self hideProgress];
    }];
}

- (void)payAction:(RequestPayOrderModel *)model {
    
    if (model.status == 0) {
        PayViewController *payViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayViewController"];
        payViewController.goodsModel = self.goodsModel;
        NSLog(@"%@",[self.goodsModel.goodsOrderId yy_modelToJSONObject]);
        payViewController.sumPrice = [self.couponPriceLabel.text floatValue];
        payViewController.goodsNum = [self.numberLabel.text integerValue];
        self.goodsModel.goodsNumber = self.numberLabel.text;
        self.goodsModel.price = model.price;
        payViewController.payOrderModel = model;
        [self.navigationController pushViewController:payViewController animated:YES];
    }
    else if (model.status == 1) {
        //self.qrImgView.image = [LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@:%@:%@:%@", self.orderNo,self.couponNo,self.goodsOrderId,self.goodsOrderCouponId]
//        PayBackViewController *payBackC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayBackViewController"];
//        payBackC.payOrderModel = model;
//        [self.navigationController pushViewController:payBackC animated:YES];
        OrderContentViewController *orderController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderContentViewController"];
        orderController.orderNo = model.orderNo;
        orderController.goodsOrderId = model.goodsOrderId;
        [self.navigationController pushViewController:orderController animated:YES];
    }

}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"提交订单";
    self.nameLabel.text  = self.goodsModel.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice];
    self.sumLabel.text = [NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice];
    [self getCouponList];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedCouponAction:)];
    [self.couponView addGestureRecognizer:tap];
}

- (void)selectedCouponAction:(UITapGestureRecognizer *)sender {
    UseCouponViewController *useCoupC = [[UseCouponViewController alloc] init];
    useCoupC.merchantId = self.merchantId;
    __weak CommitOrderController *weakSelf = self;
    useCoupC.selectedCouponAction = ^(RequestMyCouponListModel *couponModel) {
        switch (couponModel.couponType) {
            case 1:
                if ([weakSelf.sumLabel.text floatValue] < couponModel.mPrice) {
                    weakSelf.couponLabel.text = @"没有可用的优惠券";
                    weakSelf.couponPriceLabel.text = weakSelf.sumLabel.text;
                    weakSelf.couponModel = nil;
                }else {
                    weakSelf.couponLabel.text = [NSString stringWithFormat:@"满%.2f元,减%.2f元", couponModel.mPrice, couponModel.mVaule];
                    weakSelf.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f", [weakSelf.sumLabel.text floatValue]-couponModel.mVaule];
                    weakSelf.couponModel = couponModel;
                }
                break;
            case 2:
                 weakSelf.couponLabel.text = [NSString stringWithFormat:@"下单立减%.0f元", couponModel.lValue];
                if ([weakSelf.sumLabel.text floatValue] - couponModel.lValue < 0) {
                    weakSelf.couponPriceLabel.text = @"0.00";
                    weakSelf.couponModel = couponModel;
                }else {
                    weakSelf.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f", [weakSelf.sumLabel.text floatValue]-couponModel.lValue];
                    weakSelf.couponModel = couponModel;
                }
                break;
            case 3:
                 weakSelf.couponLabel.text = [NSString stringWithFormat:@"%.1f", couponModel.dValue/10.0];
                NSLog(@"%ld", (long)couponModel.dValue);
                weakSelf.couponPriceLabel.text = [NSString stringWithFormat:@"%.2f", [weakSelf.sumLabel.text floatValue]*(couponModel.dValue / 100.0)];
                weakSelf.couponModel = couponModel;
                
                break;
            default:
                break;
        }
    };
    [self.navigationController pushViewController:useCoupC animated:YES];
}

- (void)viewDidLayoutSubviews {
    self.commitBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 3;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RequestMyCouponListModel *)getCouponModelWithPrice:(CGFloat)price{
    RequestMyCouponListModel *lCouponModel = [[RequestMyCouponListModel alloc] init];
    lCouponModel.lValue = 0;
    RequestMyCouponListModel *mCouponModel = [[RequestMyCouponListModel alloc] init];
    mCouponModel.mVaule = 0;
    RequestMyCouponListModel *dCouponModel = [[RequestMyCouponListModel alloc] init];
    dCouponModel.dValue = 100;
    for (RequestMyCouponListModel *model in self.dataSource) {
        if (model.couponType == 2) {
            if (model.lValue > lCouponModel.lValue) {
                lCouponModel = model;
            }
        }else if (model.couponType == 3) {
            if (model.dValue < dCouponModel.dValue) {
            dCouponModel = model;
                            }
        }else if (model.couponType == 1) {
            if (model.mVaule > mCouponModel.mVaule) {
                if (model.mPrice < price) {
                    mCouponModel = model;
                }
            }
        }
    }
    
    if (lCouponModel.merchantId != nil || lCouponModel.merchantId != NULL) {
        return lCouponModel;
    }else if (dCouponModel.merchantId != nil || dCouponModel.merchantId != NULL) {
        return dCouponModel;
    }else if (mCouponModel.merchantId != nil || mCouponModel.merchantId != NULL) {
        return mCouponModel;
    }else {
        return nil;
    }
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
