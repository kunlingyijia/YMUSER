//
//  OrderViewController.m
//  BianMin
//
//  Created by z on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderViewCell.h"
#import "OrderContentViewController.h"
#import "TalkController.h"
#import "UserOrderViewController.h"
#import "DropDownListView.h"
#import "PayViewController.h"
#import "RequestMyGoodsOrderList.h"
#import "RequestMyGoodsOrderListModel.h"
#import "RequestMerchantGoodsListModel.h"
#import "ShopContentViewController.h"
#import "RequestMerchantDetailModel.h"
#import "RefundContentViewController.h"
#import "RequestPayOrderModel.h"
#import "RequestRefundGoodsOrderDetail.h"
@interface OrderViewController()<UITableViewDelegate, UITableViewDataSource,DropDownChooseDelegate,DropDownChooseDataSource>

@property (nonatomic, assign) OrderStatus currentStatus;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *menuData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderImages;
@property (nonatomic, strong) DropDownListView *dropView;
@property (nonatomic, strong) NSMutableArray *orderData;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageKind;
@end

@implementation OrderViewController
- (NSMutableArray *)orderData {
    if (!_orderData) {
        self.orderData = [NSMutableArray arrayWithCapacity:0];
    }
    return _orderData;
}
- (NSMutableArray *)orderImages {
    if (!_orderImages) {
        self.orderImages = [NSMutableArray arrayWithObjects:@"icon_my_dingdanshaxuan_daifukuan_normal",@"icon_my_dingdanshaxuan_daishiyong_normal",@"icon_my_dingdanshaxuan_daipingjia_normal",@"icon_my_dingdanshaxuan_tuikuan_normal",@"icon_my_dingdanshaxuan_tuikuan_normal", nil];
    }
    return _orderImages;
}

- (NSMutableArray *)menuData {
    if (!_menuData) {
        self.menuData = [NSMutableArray arrayWithObjects:@"待付款", @"待使用",@"待评价", @"退款/售后",@"全部", nil];
    }
    return _menuData;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.pageKind = 0;
    self.pageIndex = 1;
    [self showBackBtn];
    [self createTableView];
    [self creatrNavigationDrop];
    //接收推送信息  刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataOrderMessage) name:@"刷新订单" object:nil];
}

- (void)updataOrderMessage {
    self.pageIndex = 1;
    [self getOrderData];
}

- (void)creatrNavigationDrop {
    self.dropView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, 0, 80,40) dataSource:self delegate:self isNavigation:YES titleColor:@"#FFFFFF"];
    self.dropView.isNewC = 6;
    [self.dropView.sectionBtnIv setImage:[UIImage imageNamed:@"下拉箭"]];
    self.dropView.sectionBtnIv.contentMode = UIViewContentModeScaleAspectFit;
    self.dropView.backgroundColor = [UIColor clearColor];
    self.dropView.mSuperView = self.view;
    self.dropView.hightArray = self.menuData;
    self.dropView.sectionBtnIv.frame = CGRectMake(35, 28, 10, 10);
    self.navigationItem.titleView = self.dropView;
}



- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 172.5;
    [self.tableView registerClass:[OrderViewCell class] forCellReuseIdentifier:@"orderCell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getOrderData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getOrderData];
    }];
    if ([self.isNew isEqualToString:@"6"]) {
        if (self.newKind == 0) {
            self.pageKind = 1;
            [self getOrderData];
        }else if (self.newKind == 1) {
            self.pageKind = 2;
            [self getOrderData];
        }else if (self.newKind == 2) {
            self.pageKind = 3;
            [self getOrderData];
        }else if (self.newKind == 3) {
            self.pageKind = 4;
            [self getOrderData];
        }
    }else {
        [self getOrderData];
    }
    
}

#pragma mark - 网络请求
- (void)getOrderData {
    RequestMyGoodsOrderList *orderList = [[RequestMyGoodsOrderList alloc] init];
    orderList.orderStatus = self.pageKind;
    orderList.pageIndex = self.pageIndex;
    orderList.pageCount = 10;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[orderList yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyGoodsOrderList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.orderData removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMyGoodsOrderListModel *model = [RequestMyGoodsOrderListModel yy_modelWithDictionary:dic];
                [self.orderData addObject:model];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}

- (void)cancelOrderAction:(RequestMyGoodsOrderListModel *)model {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消订单" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RequestRefundGoodsOrderDetail *cancelOrder = [[RequestRefundGoodsOrderDetail alloc] init];
        cancelOrder.orderNo = model.orderNo;
        cancelOrder.goodsOrderId = model.goodsOrderId;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = AES;
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.data = [AESCrypt encrypt:[cancelOrder yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestCancelGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [self getOrderData];
            }else {
            [self showToast:baseRes.msg];//     [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            }
        } faild:^(id error) {
            
        }];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
}


#pragma mark - DropDownChooseDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index {
    NSLog(@"选择");
    switch (index) {
        case 0:
            self.pageKind = 1;
            [self.orderData removeAllObjects];
            [self getOrderData];
            break;
        case 1:
            self.pageKind = 2;
            [self.orderData removeAllObjects];
            [self getOrderData];
            break;
        case 2:
            self.pageKind = 3;
            [self.orderData removeAllObjects];
            [self getOrderData];
            break;
        case 3:
            self.pageKind = 4;
            [self.orderData removeAllObjects];
            [self getOrderData];
            break;
        case 4:
            self.pageKind = 0;
            [self.orderData removeAllObjects];
            [self getOrderData];
            break;
        default:
            break;
    }
}
#pragma mark - DropDownChooseDataSource
-(NSInteger)numberOfSections {
    return 1;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.menuData.count;
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index {
    return self.menuData[index];
}
-(NSInteger)defaultShowSection:(NSInteger)section {
    return 0;
}
-(NSString *)PictureInSection:(NSInteger)section index:(NSInteger) index {
    return self.orderImages[index];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestMyGoodsOrderListModel *model = self.orderData[indexPath.row];
    OrderContentViewController *orderController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderContentViewController"];
    orderController.orderNo = model.orderNo;
    orderController.goodsOrderId = model.goodsOrderId;
    [self.navigationController pushViewController:orderController animated:YES];

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self.tableView tableViewDisplayWitimage:@"暂无订单" ifNecessaryForRowCount:self.orderData.count];
    return self.orderData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    RequestMyGoodsOrderListModel *model = self.orderData[indexPath.row];
    [cell cellGetDataWithModel:model WithController:self];
    __weak OrderViewController *weakSelf = self;
    if (model.status == 0) {
        [cell.payOrTalkBtn setTitle:@"付款" forState:UIControlStateNormal];
        cell.isOrNotPay.text = @"未付款";
        cell.cancelBtn.hidden = NO;
        cell.cancelAction = ^(NSString *str) {
            [weakSelf cancelOrderAction:model];
        };
//        [cell.payOrTalkBtn setTitle:@"评价" forState:UIControlStateNormal];
    }else if (model.status == 1) {
        [cell.payOrTalkBtn setTitle:@"使用" forState:UIControlStateNormal];
        cell.isOrNotPay.text = @"未使用";
        cell.cancelBtn.hidden = YES;
    }else if (model.status == 2) {
        [cell.payOrTalkBtn setTitle:@"退款详情" forState:UIControlStateNormal];
        cell.isOrNotPay.text = @"退款中";
        cell.cancelBtn.hidden = YES;
    }else if (model.status == 3) {
        [cell.payOrTalkBtn setTitle:@"去评价" forState:UIControlStateNormal];
        cell.cancelBtn.hidden = YES;
        cell.isOrNotPay.text = @"未评价";
    }else if (model.status == 4) {
        [cell.payOrTalkBtn setTitle:@"已退款" forState:UIControlStateNormal];
        cell.isOrNotPay.text = @"已退款";
        cell.cancelBtn.hidden = YES;
    }else if (model.status == 5) {
        [cell.payOrTalkBtn setTitle:@"订单取消" forState:UIControlStateNormal];
        cell.isOrNotPay.text = @"已取消";
        cell.cancelBtn.hidden = YES;
    }else if (model.status == 6) {
        [cell.payOrTalkBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        cell.isOrNotPay.text = @"已完成";
        cell.cancelBtn.hidden = YES;
    }else if (model.status == 8) {
        [cell.payOrTalkBtn setTitle:@"退款详情" forState:UIControlStateNormal];
        cell.isOrNotPay.text = @"退款中";
        cell.cancelBtn.hidden = YES;
    }
    
    cell.talkBlock = ^(OrderViewCell * sender) {
        if ([sender.payOrTalkBtn.titleLabel.text isEqualToString:@"使用"]) {
            OrderContentViewController *orderController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderContentViewController"];
            orderController.orderNo = model.orderNo;
            orderController.goodsOrderId = model.goodsOrderId;
            [self.navigationController pushViewController:orderController animated:YES];
        }else if ([sender.payOrTalkBtn.titleLabel.text isEqualToString:@"去评价"]) {
            TalkController *talkController = [[TalkController alloc] init];
            talkController.model = model;
            [weakSelf.navigationController pushViewController:talkController animated:YES];
        }else if ([sender.payOrTalkBtn.titleLabel.text isEqualToString:@"付款"]){
            PayViewController *payController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayViewController"];
            payController.goodsNum = [model.goodsNumber integerValue];
            payController.sumPrice = model.payAmount;
            RequestPayOrderModel *payModel = [RequestPayOrderModel yy_modelWithJSON:[model yy_modelToJSONString]];
            RequestMerchantGoodsListModel *goodsModel = [RequestMerchantGoodsListModel yy_modelWithJSON:[model yy_modelToJSONString]];
            payController.goodsModel = goodsModel;
            payController.payOrderModel = payModel;
            [weakSelf.navigationController pushViewController:payController animated:YES];
        }else if ([sender.payOrTalkBtn.titleLabel.text isEqualToString:@"退款详情"]) {
            RefundContentViewController *refundContentC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"RefundContentViewController"];
            refundContentC.orderNo = model.orderNo;
            refundContentC.goodsOrderId = model.goodsOrderId;
            [weakSelf.navigationController pushViewController:refundContentC animated:YES];
        }else if ([sender.payOrTalkBtn.titleLabel.text isEqualToString:@"已退款"]) {
            [weakSelf showToast:@"已退款"];
        }else if ([sender.payOrTalkBtn.titleLabel.text isEqualToString:@"查看详情"]) {
//            [weakSelf showToast:@"订单已完成"];
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            RequestMyGoodsOrderListModel *model = self.orderData[indexPath.row];
            OrderContentViewController *orderController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderContentViewController"];
            orderController.orderNo = model.orderNo;
            orderController.goodsOrderId = model.goodsOrderId;
            [self.navigationController pushViewController:orderController animated:YES];
        }else if ([sender.payOrTalkBtn.titleLabel.text isEqualToString:@"订单取消"]) {
            [weakSelf showToast:@"订单已取消"];
        }
    };
    return cell;
}





- (void)setTitle:(NSString *)str {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dropView setTitle:str inSection:0];
    });
}

- (void)getCurrentStatus:(OrderStatus)status{
    self.currentStatus = status;
}

@end
