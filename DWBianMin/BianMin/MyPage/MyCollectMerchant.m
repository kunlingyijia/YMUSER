//
//  MyCollectMerchant.m
//  BianMin
//
//  Created by z on 16/5/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyCollectMerchant.h"
#import "FakeData.h"
#import "HomeShopModel.h"
#import "ShopViewController.h"
#import "RequestMyTripList.h"
#import "RequestMerchantListModel.h"
#import "DWMainPageTableViewCell.h"
#import "MyCollectCell.h"
#import "RequestCollectMerchant.h"
#import "BMShopContentController.h"
@interface MyCollectMerchant()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fakeData;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MyCollectMerchant

- (NSMutableArray *)fakeData {
    if (!_fakeData) {
        self.fakeData = [NSMutableArray arrayWithCapacity:0];
    }
    return _fakeData;
}


- (void)viewDidLoad{
    [super viewDidLoad];

    [self showBackBtn];
    self.pageIndex = 1;
    self.title = @"我的收藏";
    
    [self initWithCustomView];
    [self getDataList];
}

- (void)getDataList {
    RequestMyTripList *list = [[RequestMyTripList alloc] init];
    list.pageCount = 10;
    list.pageIndex = self.pageIndex;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[list yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestCollectMerchantList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.fakeData removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantListModel *model = [RequestMerchantListModel yy_modelWithDictionary:dic];
                [self.fakeData addObject:model];
            }
        }else {
            
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } faild:^(id error) {
        
    }];
}



#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.fakeData.count];
    return self.fakeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString *identifier = @"UITableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 60)];
//        imageView.tag = 1000;
//        [cell addSubview:imageView];
//        
//        UILabel *merchantName = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, Width - 160, 30)];
//        merchantName.font = [UIFont systemFontOfSize:14];
//        merchantName.tag = 1001;
//        merchantName.textColor = [UIColor colorWithHexString:kTitleColor];
//        [cell addSubview:merchantName];
//        
//        UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        collectBtn.frame = CGRectMake(Width - 40, 30, 20, 20);
//        collectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [collectBtn setImage:[UIImage imageNamed:@"btn_class_xiangqing_shoucang_press"] forState:UIControlStateNormal];
//        collectBtn.tag = 1002;
//        [cell addSubview:collectBtn];
//    }
//
//    UIImageView *icon = (UIImageView *)[cell viewWithTag:1000];
//    UILabel *merchantName = (UILabel *)[cell viewWithTag:1001];
//    
//    HomeShopModel *merch = [self.fakeData objectAtIndex:indexPath.row];
//    [icon sd_setImageWithURL:[NSURL URLWithString:merch.iconUrl]];
//    
//    merchantName.text = merch.merchantName;
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCollectCell" forIndexPath:indexPath];
    RequestMerchantListModel *model = self.fakeData[indexPath.row];
    [cell cellGetData:model withController:self];
//    [cell cellGetDataModel:model WithController:self];
    __weak MyCollectMerchant *weakSelf = self;
    cell.blockAction = ^(NSString *str) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消收藏" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf collectWithType:2 withBtn:model];
            
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [weakSelf presentViewController:alertC animated:YES completion:nil];
    };
    
    return cell;
}

- (void)collectWithType:(NSInteger)type withBtn:(RequestMerchantListModel *)model{
    __weak MyCollectMerchant *weakSelf = self;
    RequestCollectMerchant *merchant = [[RequestCollectMerchant alloc] init];
    merchant.type = type;
    merchant.merchantId = model.merchantId;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[merchant yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestCollectMerchant" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakSelf againDataList];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}

- (void)againDataList {
    __weak MyCollectMerchant *weakSelf = self;
    RequestMyTripList *list = [[RequestMyTripList alloc] init];
    list.pageCount = 10;
    list.pageIndex = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[list yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestCollectMerchantList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakSelf.fakeData removeAllObjects];
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantListModel *model = [RequestMerchantListModel yy_modelWithDictionary:dic];
                [weakSelf.fakeData addObject:model];
            }
        }else {
            
        }
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}



#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestMerchantListModel *model = self.fakeData[indexPath.row];
    //1-普通用户 2-便民

    if (model.merchantType	==	1) {
        ShopViewController *shopController = [[ShopViewController alloc] init];
        //    [shopController setDataSource:model];
        shopController.merchantId = model.merchantId;
        [self.navigationController pushViewController:shopController animated:YES];
    }else if (model.merchantType ==	2){
        BMShopContentController *bmContentC = [[BMShopContentController alloc] init];
        bmContentC.merchantId = model.merchantId;
        [self.navigationController pushViewController:bmContentC animated:YES];
    }
    
}

- (void)initWithCustomView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCollectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"myCollectCell"];
    
    [self.view addSubview:self.tableView];

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    
    self.tableView.tableFooterView = bgView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getDataList];
    }];
}

@end
