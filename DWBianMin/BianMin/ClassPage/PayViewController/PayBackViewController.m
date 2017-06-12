//
//  PayBackViewController.m
//  BianMin
//
//  Created by kkk on 16/5/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PayBackViewController.h"
#import "LBXScanWrapper.h"
#import "OrderContentViewController.h"
@interface PayBackViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImage;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation PayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"支付结果";
    //self.qrImgView.image = [LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@:%@:%@:%@", self.orderNo,self.couponNo,self.goodsOrderId,self.goodsOrderCouponId]
    self.qrImage.image = [LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@", self.payOrderModel.orderNo] size:self.qrImage.bounds.size];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(backRootAction:)];
}

- (void)backRootAction:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)sureBtnAction:(id)sender {
    OrderContentViewController *orderContentC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil ] instantiateViewControllerWithIdentifier:@"OrderContentViewController"];
    [self.navigationController pushViewController:orderContentC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3;
}

- (void)dealloc {
    NSLog(@"支付结果页面释放");
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
