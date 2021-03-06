//
//  NewsViewController.m
//  BianMin
//
//  Created by kkk on 16/5/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GovNewsViewController.h"
#import "GovNewsCell.h"
#import "FakeData.h"
#import "GovModel.h"
#import "DWWebViewController.h"
#import "RequestGovAffairsList.h"
#import "RequestGovAffairsListModel.h"

@interface GovNewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation GovNewsViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    [self showBackBtn];
    self.title = @"政务";
    
    [self createTableView];
}



- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[GovNewsCell class] forCellReuseIdentifier:@"newsCell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView = footView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getDataList];
    }];
    
    [self getDataList];
}

- (void)getDataList {
    RequestGovAffairsList *govList = [[RequestGovAffairsList alloc] init];
    govList.pageCount = 10;
    govList.pageIndex = self.pageIndex;
    govList.regionId = [AuthenticationModel getRegionID];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self isLogin]) {
       baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = govList;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestGovAffairsList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestGovAffairsListModel *model = [RequestGovAffairsListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
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
    
    RequestGovAffairsListModel *model = [self.dataSource objectAtIndex:indexPath.row];
    DWWebViewController *webVC = [[DWWebViewController alloc] init];
    webVC.title = @"网页";
    NSLog(@"%@",model.targetUrl);
    
    //后台返回html代码 反编译
    
    
    [webVC setUrl:[model.targetUrl  HtmlToString]];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GovNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    
    [cell setDataSource:[self.dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
