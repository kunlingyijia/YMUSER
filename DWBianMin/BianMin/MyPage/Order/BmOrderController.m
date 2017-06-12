//
//  BmOrderController.m
//  BianMin
//
//  Created by kkk on 16/8/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BmOrderController.h"
#import "BmOrderCell.h"
#import "OrderDetailView.h"
#import "OrderDetailViewController.h"
#import "RequestMyBminorderList.h"
#import "RequestMyBminorderListModel.h"
#import "RequestBminCancelOrder.h"
#import "RequestBminUrge.h"
@interface BmOrderController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation BmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"便民订单";
    self.pageIndex = 1;
    [self createTabelView];
}

- (void)createTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-50) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150;
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.tableView registerNib:[UINib nibWithNibName:@"BmOrderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BmOrderCell"];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getdataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getdataList];
    }];
    [self getdataList];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BmOrderCell" forIndexPath:indexPath];
    RequestMyBminorderListModel *model = self.dataSource[indexPath.section];
    __weak BmOrderController *weakSelf = self;
    cell.cancelOrderBlock = ^(NSString *orderNo, NSString *typeStr ,NSString *bminOrderId) {
        if ([typeStr isEqualToString:@"取消订单"]) {
            [weakSelf cancelOrderAction:orderNo bminOrderId:bminOrderId];
        }else if ([typeStr isEqualToString:@"支付"]) {
            RequestMyBminorderListModel *model = weakSelf.dataSource[indexPath.section];
            OrderDetailViewController *orderDetaiC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
            orderDetaiC.orderNo = model.orderNo;
            orderDetaiC.bminOrderId = model.bminOrderId;
            orderDetaiC.backBlockAction = ^(NSString *str) {
                weakSelf.pageIndex = 1;
                [weakSelf getdataList];
            };
            [weakSelf.navigationController pushViewController:orderDetaiC animated:YES];
        }else if ([typeStr isEqualToString:@"催单"]) {
            [weakSelf urgeOrderWithOrderNo:orderNo bminOrderId:bminOrderId];
        }
    };
    cell.secondBtnAction = ^(NSString *orderNo, NSString *bminOrderId) {
        [weakSelf urgeOrderWithOrderNo:orderNo bminOrderId:bminOrderId];
    };
    [cell cellGetDataWithModel:model];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [self.tableView tableViewDisplayWitimage:@"暂无订单" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestMyBminorderListModel *model = self.dataSource[indexPath.section];
    OrderDetailViewController *orderDetaiC = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    orderDetaiC.orderNo = model.orderNo;
    orderDetaiC.bminOrderId = model.bminOrderId;
    __weak BmOrderController *weakSelf = self;
    orderDetaiC.backBlockAction = ^(NSString *str) {
        weakSelf.pageIndex = 1;
        [weakSelf getdataList];
    };
    [self.navigationController pushViewController:orderDetaiC animated:YES];
}

#pragma mark - networking
//取消订单
- (void)cancelOrderAction:(NSString *)orderNo bminOrderId:(NSString*)bminOrderId{
    [self showProgress];
    RequestBminCancelOrder *order = [[RequestBminCancelOrder alloc] init];
    order.orderNo = orderNo;
    order.bminOrderId = bminOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data= [AESCrypt encrypt:[order yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestBminCancelOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.pageIndex = 1;
            [self getdataList];
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self hideProgress];
    } faild:^(id error) {
        [self hideProgress];
    }];
}
//催单
- (void)urgeOrderWithOrderNo:(NSString *)orderNo bminOrderId:(NSString*)bminOrderId{
    RequestBminUrge *urge = [[RequestBminUrge alloc] init];
    urge.orderNo = orderNo;
    urge.bminOrderId = bminOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[urge yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestBminUrge" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self showToast:@"催单成功"];
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}
#pragma mark -  便民订单列表
- (void)getdataList {
    RequestMyBminorderList *list = [[RequestMyBminorderList alloc] init];
    list.pageCount = 10;
    list.pageIndex = self.pageIndex;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[list yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyBminorderList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@" 便民订单列表----%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMyBminorderListModel *model = [RequestMyBminorderListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }else {
            
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
    
    }];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
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
