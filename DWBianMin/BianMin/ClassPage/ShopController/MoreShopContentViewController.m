//
//  MoreShopContentViewController.m
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MoreShopContentViewController.h"
#import "ShopViewCell.h"
#import "RequestMerchantGoodsList.h"
#import "ShopContentViewController.h"
#import "RequestMerchantGoodsListModel.h"
@interface MoreShopContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *goodsArr;

@property (nonatomic, assign) NSInteger pageIndex;


@end

@implementation MoreShopContentViewController

- (NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        self.goodsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _goodsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    [self showBackBtn];
    [self createTabeleView];
}

- (void)createTabeleView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[ShopViewCell class] forCellReuseIdentifier:@"shopViewCell"];
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
    RequestMerchantGoodsList *goodsList = [[RequestMerchantGoodsList alloc] init];
    goodsList.pageIndex = self.pageIndex;
    goodsList.pageCount = 10;
    goodsList.merchantId = self.merchantId;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.data = goodsList;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantGoodsList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.goodsArr removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantGoodsListModel *model = [RequestMerchantGoodsListModel yy_modelWithDictionary:dic];
                [self.goodsArr addObject:model];
            }
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
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
    RequestMerchantGoodsListModel *goodsModel = [self.goodsArr objectAtIndex:indexPath.row];
    ShopContentViewController *shopController = [[ShopContentViewController alloc] init];
    shopController.shopModel = self.shopModel;
    shopController.goodsId = goodsModel.goodsId;
    shopController.title = @"套餐详情";
    [self.navigationController pushViewController: shopController animated:YES];
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.goodsArr.count];
    return self.goodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopViewCell" forIndexPath:indexPath];
    RequestMerchantGoodsListModel *model = self.goodsArr[indexPath.row];
    [cell cellGetData:model WithController:self];
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
