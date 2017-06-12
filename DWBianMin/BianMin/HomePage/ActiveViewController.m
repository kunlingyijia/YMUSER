//
//  ActiveViewController.m
//  BianMin
//
//  Created by kkk on 16/6/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ActiveViewController.h"
#import "DWMainPageTableViewCell.h"
#import "RequestActiveInfo.h"
#import "RequestActiveInfoModel.h"
#import "RequestMerchantListModel.h"
#import "RequestActiveListModel.h"
#import "ShopViewController.h"
#import "GoodsListOneCell.h"
@interface ActiveViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ActiveViewController

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
    self.title = self.model.title;
    [self showBackBtn];
    [self createTabelView];

}

- (void)createTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = Width *0.19;
    [self.tableView tableViewregisterNibArray:@[@"GoodsListOneCell"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[DWMainPageTableViewCell class] forCellReuseIdentifier:@"DWMainPageTableViewCell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getData:nil];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getData:nil];
    }];
    [self createHeaderView];
}

- (void)createHeaderView {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*2/5)];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*2/5)];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.clipsToBounds = YES;
    [self loadImageWithView:imageV urlStr:self.model.logoUrl];
    [headerV addSubview:imageV];
    self.tableView.tableHeaderView = headerV;
    [self getData:imageV];
}


- (void)getData:(UIImageView *)imageV {
    RequestActiveInfo *info = [[RequestActiveInfo alloc] init];
    info.activeId = self.model.activeId;
    info.pageCount = 10;
    info.pageIndex = self.pageIndex;
    info.lat = [AuthenticationModel getlatitude];
    info.lng = [AuthenticationModel getlongitude];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    
    baseReq.data = info;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestActiveInfo" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantListModel *goodsModel = [RequestMerchantListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:goodsModel];
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}


#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestMerchantListModel *model = self.dataSource[indexPath.row];
    ShopViewController *shopController = [[ShopViewController alloc] init];
//    [shopController setDataSource:model];
    shopController.merchantId = model.merchantId;
    [self.navigationController pushViewController:shopController animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DWMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWMainPageTableViewCell" forIndexPath:indexPath];
//    RequestMerchantListModel *model = self.dataSource[indexPath.row];
//    [cell cellGetDataModel:model WithController:self];
//    return cell;
    
    GoodsListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListOneCell" forIndexPath:indexPath];
    RequestMerchantListModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;

    
    
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
