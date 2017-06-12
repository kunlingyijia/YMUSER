//
//  OrderDetailView.m
//  0816
//
//  Created by 月美 刘 on 16/8/15.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "OrderDetailView.h"
#import "BMShopContentController.h"
@interface OrderDetailView ()

@end

@implementation OrderDetailView

//声明一个订单处理的方法
- (IBAction)orderProcessing:(id)sender {
    BMShopContentController *bmC = [[BMShopContentController alloc] init];
    [self.navigationController pushViewController:bmC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 导航
    self.title = @"订单详情";
    [self showBackBtn];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 4;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
