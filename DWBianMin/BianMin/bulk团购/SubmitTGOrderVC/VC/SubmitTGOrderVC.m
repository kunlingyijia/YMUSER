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
#import "industryUseVC.h"
#import "IndustryModel.h"
#import "BusinessVouchersVC.h"
@interface SubmitTGOrderVC ()
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, strong) RequestMyCouponListModel *couponModel;
@property (nonatomic,strong) NSString * AllPrice;
@property(nonatomic,strong) NSString * hangyePrice;

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
    self.addBtn.backgroundColor = [UIColor whiteColor];
    self.deleteBtn.backgroundColor = [UIColor whiteColor];
    self.textTf.userInteractionEnabled = YES;
    self.commitBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 3;
    self.textTf.userInteractionEnabled = YES;
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    self.goodsName.text  = self.goodsModel.goodsName;
    self.discountedPrice.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice];
    self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice];
    self.AllPrice =[NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice];
   _hangyePrice =self.AllPrice;
    self.goodsModel.couponId = @"";
    self.goodsModel.industryCouponUserId = @"";
    self.goodsModel.couponUserId = @"";
    [_shangjiaBtn setTitle:self.goodsModel.couponId.length ==0 ?@"使用商家抵用券":@"" forState:0];
    [_hangyeBtn setTitle:self.goodsModel.industryCouponUserId.length ==0 ?@"使用行业抵用券":@"" forState:0];
    _alltotalLabel.text = self.subtotalLabel.text;
}


- (IBAction)deleteACtion:(PublicBtn *)sender {
    [self.view endEditing:YES];
    int a=  [self.textTf.text intValue];
    if ([self.textTf.text intValue]>1) {
        a--;
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
        self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        self.AllPrice =[NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        _hangyePrice =self.AllPrice;
        _alltotalLabel.text = self.subtotalLabel.text;
        self.goodsModel.couponId = @"";
        self.goodsModel.couponUserId = @"";
        self.goodsModel.industryCouponUserId = @"";
        [_shangjiaBtn setTitle: @"使用商家抵用券"
                    forState:0];
        [_shangjiaBtn setTitleColor:self.goodsModel.couponId.length ==0 ?[UIColor grayColor]: [UIColor redColor]
                         forState:0];
        [_hangyeBtn setTitle:@"使用行业抵用券"forState:0];
        [_hangyeBtn setTitleColor:self.goodsModel.industryCouponUserId.length ==0 ?[UIColor grayColor]: [UIColor redColor]forState:0];
    }
}
- (IBAction)addAction:(PublicBtn *)sender {
    [self.view endEditing:YES];

    int a=  [self.textTf.text intValue];
    if ([self.textTf.text intValue]>0) {
        a++;
        self.textTf.text = [NSString stringWithFormat:@"%d",a];
        self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        _alltotalLabel.text = self.subtotalLabel.text;
        self.AllPrice =[NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        _hangyePrice =self.AllPrice;
        self.goodsModel.couponId = @"";
        self.goodsModel.couponUserId = @"";

        self.goodsModel.industryCouponUserId = @"";
        [_shangjiaBtn setTitle: @"使用商家抵用券"
                      forState:0];
        [_shangjiaBtn setTitleColor:self.goodsModel.couponId.length ==0 ?[UIColor grayColor]: [UIColor redColor]
                           forState:0];
        [_hangyeBtn setTitle:@"使用行业抵用券"forState:0];
        [_hangyeBtn setTitleColor:self.goodsModel.industryCouponUserId.length ==0 ?[UIColor grayColor]: [UIColor redColor]forState:0];
    }
}
- (IBAction)TFChangeACtion:(PublicTF *)sender {
    if (sender.text.length== 0||[self.textTf.text intValue]==0) {
        sender.text=@"1";
    }
//        self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
//        _alltotalLabel.text = self.subtotalLabel.text;
//        self.AllPrice =[NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
//        _hangyePrice =self.AllPrice;
//        self.goodsModel.couponId = @"";
//        self.goodsModel.couponUserId = @"";
//
//        self.goodsModel.industryCouponUserId = @"";
//        [_shangjiaBtn setTitle: @"使用商家抵用券"
//                      forState:0];
//        [_shangjiaBtn setTitleColor:self.goodsModel.couponId.length ==0 ?[UIColor grayColor]: [UIColor redColor]
//                           forState:0];
//        [_hangyeBtn setTitle:@"使用行业抵用券"forState:0];
//        [_hangyeBtn setTitleColor:self.goodsModel.industryCouponUserId.length ==0 ?[UIColor grayColor]: [UIColor redColor]forState:0];
//    }else{
    int a=  [self.textTf.text intValue];
    self.textTf.text = [NSString stringWithFormat:@"%d",a];
    self.subtotalLabel.text = [NSString stringWithFormat:@"%.2f元",self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        _alltotalLabel.text = self.subtotalLabel.text;
        self.AllPrice =[NSString stringWithFormat:@"%.2f", self.goodsModel.discountedPrice*[self.textTf.text intValue]];
        _hangyePrice =self.AllPrice;
        self.goodsModel.couponId = @"";
        self.goodsModel.couponUserId = @"";

        self.goodsModel.industryCouponUserId = @"";
        [_shangjiaBtn setTitle: @"使用商家抵用券"
                      forState:0];
        [_shangjiaBtn setTitleColor:self.goodsModel.couponId.length ==0 ?[UIColor grayColor]: [UIColor redColor]
                           forState:0];
        [_hangyeBtn setTitle:@"使用行业抵用券"forState:0];
        [_hangyeBtn setTitleColor:self.goodsModel.industryCouponUserId.length ==0 ?[UIColor grayColor]: [UIColor redColor]forState:0];
    //}
}
#pragma mark - 商家抵用券
- (IBAction)shangjiaBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //Push 跳转
    BusinessVouchersVC * VC = [[BusinessVouchersVC alloc]initWithNibName:@"BusinessVouchersVC" bundle:nil];
    __block IndustryModel * model =[IndustryModel new];
    __weak typeof(self) weakSelf = self;
    VC.BusinessVouchersVCBlock = ^(IndustryModel * industryModel){
        weakSelf.goodsModel.industryCouponUserId = @"";
        [_hangyeBtn setTitle:@"使用行业抵用券"forState:0];
        [_hangyeBtn setTitleColor:self.goodsModel.industryCouponUserId.length ==0 ?[UIColor grayColor]: [UIColor redColor]forState:0];
        weakSelf.goodsModel.couponId = industryModel.couponId;
        weakSelf.goodsModel.couponUserId = industryModel.couponUserId;
        weakSelf.goodsModel.industryCouponUserId =@"";
        NSString *AllPrice ;
        NSString * Amount ;
        weakSelf.AllPrice = [NSString stringWithFormat:@"%.2f", weakSelf.goodsModel.discountedPrice*[self.textTf.text intValue]];
        _hangyePrice =self.AllPrice;
        ///1-满减券  2-立减券  3-折扣券
        if (model.couponType == 0)  {
            AllPrice =weakSelf.AllPrice;
        }else  if (model.couponType == 1) {
            Amount = [NSString stringWithFormat:@"-¥%.2f", model.mVaule];
            AllPrice = [NSString stringWithFormat:@"%.2f",[weakSelf.AllPrice floatValue]-model.mVaule];
        }else if (model.couponType == 2)  {            
            if ([weakSelf.AllPrice floatValue]-model.lValue<0) {
                Amount = [NSString stringWithFormat:@"-¥%.2f", model.lValue];
                AllPrice = @"0.00";
            }else{
            Amount = [NSString stringWithFormat:@"-¥%.2f", model.lValue];
            AllPrice = [NSString stringWithFormat:@"%.2f",[weakSelf.AllPrice floatValue]-model.lValue];
            }
        }else  if(industryModel.couponType ==3 ){
            if (model.dValue % 10 == 0) {
                Amount = [NSString stringWithFormat:@"%.0f折", model.dValue / 10.0];
                AllPrice = [NSString stringWithFormat:@"%.2f",[weakSelf.AllPrice floatValue]*model.dValue/100];
            }else {
                Amount = [NSString stringWithFormat:@"%.1f折", model.dValue / 10.0];
                AllPrice = [NSString stringWithFormat:@"%.2f",[weakSelf.AllPrice floatValue]*model.dValue/100];
            }

        }
        [_shangjiaBtn setTitle:weakSelf.goodsModel.couponId.length ==0 ? @"使用商家抵用券": [NSString stringWithFormat:@"%@",Amount]
                                     forState:0];
        [_shangjiaBtn setTitleColor:weakSelf.goodsModel.couponId.length ==0 ?[UIColor grayColor]: [UIColor redColor]
           forState:0];
    weakSelf.AllPrice = weakSelf.goodsModel.couponId.length == 0 ? weakSelf.AllPrice : AllPrice;
     _alltotalLabel.text = [NSString stringWithFormat:@"%@元",AllPrice];
     _hangyePrice =self.AllPrice;
    };
    model.merchantId = self.goodsModel.merchantId;
    model.amount = [NSString stringWithFormat:@"%.2f", weakSelf.goodsModel.discountedPrice*[self.textTf.text intValue]];
    model.couponId = self.goodsModel.couponId;
    VC.industryModel =model;
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 行业
- (IBAction)hangyeBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //Push 跳转
    industryUseVC * VC = [[industryUseVC alloc]initWithNibName:@"industryUseVC" bundle:nil];
    __block IndustryModel * model =[IndustryModel new];
    model.merchantId = self.goodsModel.merchantId;
   model.amount = _hangyePrice ;
   model.industryCouponUserId = self.goodsModel.industryCouponUserId;
    __weak typeof(self) weakSelf = self;
    VC.industryUseVCBlock = ^(IndustryModel * industryModel){
      __block  NSString *AllPrice ;
        AllPrice = [NSString stringWithFormat:@"%.2f", [_hangyePrice floatValue]-[industryModel.amount floatValue]];
        weakSelf.goodsModel.industryCouponUserId = industryModel.industryCouponUserId;
        [_hangyeBtn setTitle:weakSelf.goodsModel.industryCouponUserId.length ==0 ?@"使用行业抵用券": [NSString stringWithFormat:@"-¥%@",industryModel.amount]forState:0];
        [_hangyeBtn setTitleColor:weakSelf.goodsModel.industryCouponUserId.length ==0 ?[UIColor grayColor]: [UIColor redColor]forState:0];
        weakSelf.AllPrice = weakSelf.goodsModel.industryCouponUserId.length == 0 ? _hangyePrice :AllPrice;
        _alltotalLabel.text = [NSString stringWithFormat:@"%@元",weakSelf.goodsModel.industryCouponUserId.length == 0?_hangyePrice:AllPrice];
    };
    VC.industryModel =model;
    [self.navigationController  pushViewController:VC animated:YES];
}
- (IBAction)commitBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self showProgress];
    RequestPayOrder *order = [[RequestPayOrder alloc] init];
    order.goodsId = self.goodsModel.goodsId;
    order.number = [self.textTf.text integerValue];
    order.couponUserId = self.goodsModel.couponUserId;
    order.industryCouponUserId = self.goodsModel.industryCouponUserId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[order yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/GoodsOrder/requestAddGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestPayOrderModel *model = [RequestPayOrderModel yy_modelWithJSON:baseRes.data];
            [self payAction:model];
        }else {
            [self showToast:baseRes.msg];
        }
        [self hideProgress];
    } faild:^(id error) {
        NSLog(@"%@", error);
        [self hideProgress];
    }];
}
- (void)payAction:(RequestPayOrderModel *)model {
    //0-未付款  1-已付款
    if (model.status == 0) {
        PayViewController *payViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayViewController"];
        payViewController.goodsModel = self.goodsModel;
        payViewController.sumPrice = [self.alltotalLabel.text floatValue];
        payViewController.goodsNum = [self.textTf.text integerValue];
        self.goodsModel.goodsNumber = self.textTf.text;
        self.goodsModel.price = model.price;
        payViewController.payOrderModel = model;
        [self.navigationController pushViewController:payViewController animated:YES];
    }else if (model.status == 1) {
        OrderContentViewController *orderController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderContentViewController"];
        orderController.orderNo = model.orderNo;
        orderController.goodsOrderId = model.goodsOrderId;
        orderController.isPayBack = 6;
        [self.navigationController pushViewController:orderController animated:YES];
    }
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end
