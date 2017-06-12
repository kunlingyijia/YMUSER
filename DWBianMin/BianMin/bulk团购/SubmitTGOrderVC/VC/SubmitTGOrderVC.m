//
//  SubmitTGOrderVC.m
//  BianMin
//
//  Created by 席亚坤 on 2017/6/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "SubmitTGOrderVC.h"
#import "PayViewController.h"
#import "RequestMerchantGoodsListModel.h"
#import "RequestPayOrder.h"
#import "RequestPayOrderModel.h"
#import "PayBackViewController.h"
#import "RequestMyCouponList.h"
#import "RequestMyCouponListModel.h"
#import "UseCouponViewController.h"
#import "OrderContentViewController.h"
@interface SubmitTGOrderVC ()
///抵用
@property(nonatomic,assign)CGFloat toUse;
///通用
@property(nonatomic,assign)CGFloat general;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, strong) RequestMyCouponListModel *couponModel;
@end

@implementation SubmitTGOrderVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

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
    self.title = @"提交订单";
    self.AddAndDelView.layer.cornerRadius= 3.0;
    self.AddAndDelView.layer.masksToBounds = YES;
    self.AddAndDelView.layer.borderWidth= 1.0;
    self.AddAndDelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textTf.userInteractionEnabled = YES;
    self.commitBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 3;
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.toUse = 0.00;
    self.general = 0.00;
    self.goodsName.text  = self.goodsModel.goodsName;
    self.discountedPrice.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice];
    self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice];
    ///请求抵用券
    [self getCouponList];
    
    
}
#pragma mark - ///请求抵用券
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
                    [self.dataArray addObject:model];
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
    RequestMyCouponListModel *model = [self getCouponModelWithPrice:[self.subtotalLabel.text floatValue]];
    if (model == nil || model == NULL) {
        self.toUseLabel.text = @"没有可用优惠券";
        self.alltotalLabel.text = self.subtotalLabel.text;
        self.toUseBtn.selected = NO;
        self.toUseBtn.userInteractionEnabled = NO;
    }else {
        self.toUseBtn.selected = YES;
        self.toUseBtn.userInteractionEnabled = YES;

        if (model.couponType == 1) {
            self.toUseLabel.text = [NSString stringWithFormat:@"满%.2f元,减%.2f元", model.mPrice, model.mVaule];
            self.alltotalLabel.text = [NSString stringWithFormat:@"%.2f元", [self.subtotalLabel.text floatValue] - model.mVaule];
            self.couponModel = model;
        }else if (model.couponType == 2) {
            self.toUseLabel.text = [NSString stringWithFormat:@"下单立减%.2f元", model.lValue];
            if ([self.subtotalLabel.text floatValue] - model.lValue < 0) {
                self.alltotalLabel.text = @"0.00元";
            }else {
                self.alltotalLabel.text = [NSString stringWithFormat:@"%.2f元", [self.subtotalLabel.text floatValue] - model.lValue];
            }
            self.couponModel = model;
        }else if (model.couponType == 3) {
            self.toUseLabel.text = [NSString stringWithFormat:@"%.1f折", model.dValue/10.0];
            self.alltotalLabel.text = [NSString stringWithFormat:@"%.2f元", [self.subtotalLabel.text floatValue] * model.dValue/100];
            self.couponModel = model;
        }
    }
}

- (RequestMyCouponListModel *)getCouponModelWithPrice:(CGFloat)price{
    RequestMyCouponListModel *lCouponModel = [[RequestMyCouponListModel alloc] init];
    lCouponModel.lValue = 0;
    RequestMyCouponListModel *mCouponModel = [[RequestMyCouponListModel alloc] init];
    mCouponModel.mVaule = 0;
    RequestMyCouponListModel *dCouponModel = [[RequestMyCouponListModel alloc] init];
    dCouponModel.dValue = 100;
    //1-满减券  2-立减券  3-折扣券
    for (RequestMyCouponListModel *model in self.dataArray) {
        if (model.couponType == 2) {
            if (model.lValue >= lCouponModel.lValue ) {
                lCouponModel = model;
            }
        }else if (model.couponType == 3) {
            if (model.dValue <= dCouponModel.dValue) {
                dCouponModel = model;
            }
        }else if (model.couponType == 1) {
            if (model.mVaule >= mCouponModel.mVaule) {
                if (model.mPrice <= price) {
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





- (IBAction)deleteACtion:(PublicBtn *)sender {
    int a=  [self.textTf.text intValue];
    if ([self.textTf.text intValue]>1) {
        a--;
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
        self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        
        [self couponGetData];
        
    }
   
}
- (IBAction)addAction:(PublicBtn *)sender {
    int a=  [self.textTf.text intValue];
    if ([self.textTf.text intValue]>0) {
        a++;
        
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
        self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
       [self couponGetData];
    }

   
}
- (IBAction)TFChangeACtion:(PublicTF *)sender {
    if (sender.text.length==0||[self.textTf.text intValue]==0) {
        sender.text=@"1";
        self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
[self couponGetData];
    }else{
    int a=  [self.textTf.text intValue];
    self.textTf.text = [NSString stringWithFormat:@"%d",a];
        self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        [self couponGetData];
    }
    
}

- (IBAction)selectedCouponAction:(UIButton *)sender {
    
    
    UseCouponViewController *useCoupC = [[UseCouponViewController alloc] init];
    useCoupC.merchantId = self.merchantId;
    __weak typeof(self) weakSelf = self;
    useCoupC.selectedCouponAction = ^(RequestMyCouponListModel *couponModel) {
        switch (couponModel.couponType) {
            case 1:
                if ([weakSelf.subtotalLabel.text floatValue] < couponModel.mPrice) {
                    weakSelf.toUseLabel.text = @"没有可用的优惠券";
                    weakSelf.alltotalLabel.text = weakSelf.subtotalLabel.text;
                    weakSelf.couponModel = nil;
                }else {
                    weakSelf.toUseLabel.text = [NSString stringWithFormat:@"满%.2f元,减%.2f元", couponModel.mPrice, couponModel.mVaule];
                    weakSelf.alltotalLabel.text = [NSString stringWithFormat:@"%.2f元", [weakSelf.subtotalLabel.text floatValue]-couponModel.mVaule];
                    weakSelf.couponModel = couponModel;
                }
                break;
            case 2:
                weakSelf.toUseLabel.text = [NSString stringWithFormat:@"下单立减%.0f元", couponModel.lValue];
                if ([weakSelf.subtotalLabel.text floatValue] - couponModel.lValue < 0) {
                    weakSelf.alltotalLabel.text = @"0.00元";
                    weakSelf.couponModel = couponModel;
                }else {
                    weakSelf.alltotalLabel.text = [NSString stringWithFormat:@"%.2f元", [weakSelf.subtotalLabel.text floatValue]-couponModel.lValue];
                    weakSelf.couponModel = couponModel;
                }
                break;
            case 3:
                weakSelf.toUseLabel.text = [NSString stringWithFormat:@"%.1f折", couponModel.dValue/10.0];
                NSLog(@"%ld", (long)couponModel.dValue);
                weakSelf.alltotalLabel.text = [NSString stringWithFormat:@"%.2f元", [weakSelf.subtotalLabel.text floatValue]*(couponModel.dValue / 100.0)];
                weakSelf.couponModel = couponModel;
                
                break;
            default:
                break;
        }
    };
    [self.navigationController pushViewController:useCoupC animated:YES];

}


- (IBAction)toUseBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected ==NO) {
        self.alltotalLabel.text = self.subtotalLabel.text;
    }else{
        [self couponGetData];
    }
}




- (IBAction)commitBtnAction:(UIButton *)sender {
    
    
    
    [self showProgress];
    
    RequestPayOrder *order = [[RequestPayOrder alloc] init];
    order.goodsId = self.goodsModel.goodsId;
    order.number = [self.textTf.text integerValue];
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
        payViewController.sumPrice = [self.alltotalLabel.text floatValue];
        payViewController.goodsNum = [self.textTf.text integerValue];
        self.goodsModel.goodsNumber = self.textTf.text;
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






#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}



@end
