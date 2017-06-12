//
//  MoreCouponViewController.m
//  BianMin
//
//  Created by kkk on 16/7/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MoreCouponViewController.h"
#import "MyCouponCell.h"
#import "RequestMerchantCouponList.h"
#import "RequestMerchantCouponListModel.h"
#import "CouponMessageViewController.h"
@interface MoreCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MoreCouponViewController
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    [self showBackBtn];
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 110;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCouponCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"myCouponCell1"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getCouponListData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getCouponListData];
    }];
    [self getCouponListData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCouponCell1" forIndexPath:indexPath];
    RequestMerchantCouponListModel *model = self.dataSource[indexPath.row];
    [cell cellGetCouponModel:model withController:self];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (void)getCouponListData {
    RequestMerchantCouponList *list = [[RequestMerchantCouponList alloc] init];
    list.merchantId = self.merchantId;
    list.pageIndex = self.pageIndex;
    list.pageCount = 10;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = list;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantCouponList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantCouponListModel *model = [RequestMerchantCouponListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }else {
           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
    }];
    
}




#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestMyCouponListModel *model = self.dataSource[indexPath.row];
    CouponMessageViewController *coupM = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CouponMessageViewController"];
    
    coupM.title = self.title;
    RequestMerchantCouponListModel *couponModel = [RequestMerchantCouponListModel yy_modelWithJSON:[model yy_modelToJSONString]];
    coupM.model = couponModel;
    __weak MoreCouponViewController *weakSelf = self;
    coupM.balckBlock = ^(NSString *str) {
        [weakSelf.dataSource removeAllObjects];
        weakSelf.pageIndex = 1;
        [weakSelf getCouponListData];
    };
    [self.navigationController pushViewController:coupM animated:YES];

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
