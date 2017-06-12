//
//  GoodsListVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/6/1.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "GoodsListVC.h"
#import "GoodsListOneCell.h"
#import "RequestMerchantListModel.h"
#import "RequestMerchantList.h"
#import "BMShopContentController.h"
#import "ShopViewController.h"
@interface GoodsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchHisToryTF;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation GoodsListVC
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
#pragma mark -  载入完成
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //关于UI
    [self SET_UI];
    //关于数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    _bottomView.layer.masksToBounds = YES;
    _bottomView.layer.cornerRadius = 14.5;
    //self.title = @"标题";
    //[self showBackBtn];
    [self setUpTableView];
    
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    
    
   
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"GoodsListOneCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.searchHisToryTF.text = self.keyword;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
    [self requestAction];
    //上拉刷新下拉加载
    [self Refresh];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 网络请求
-(void)requestAction{
    RequestMerchantList *merchantL = [[RequestMerchantList alloc] init];
    //    merchantL.categoryId = kind;
    merchantL.pageCount = 10;
    merchantL.keyword = self.keyword;
    merchantL.serchType = self.serchType ;
    merchantL.pageIndex = self.pageIndex;
    merchantL.regionId = [AuthenticationModel getRegionID];
    //    merchantL.sort = sort;
    DWHelper *helper = [DWHelper shareHelper];
    merchantL.lng = [NSString stringWithFormat:@"%f", helper.coordinate.longitude];
    merchantL.lat = [NSString stringWithFormat:@"%f", helper.coordinate.latitude];
 
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if (self.isLogin) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = merchantL;
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestSearchList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (weakSelf.pageIndex == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantListModel *model = [RequestMerchantListModel yy_modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
        }else{
            [weakSelf showToast:baseRes.msg];
        }
       
        
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    //tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    }else{
        
                GoodsListOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListOneCell" forIndexPath:indexPath];
                //cell 赋值
                cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.row];
                // cell 其他配置
                return cell;
        
    }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RequestMerchantListModel *model = self.dataArray[indexPath.row];
    if (model.merchantType == 2) {
        BMShopContentController *bmContentC = [[BMShopContentController alloc] init];
        bmContentC.merchantId = model.merchantId;
        [self.navigationController pushViewController:bmContentC animated:YES];
    }else {
        ShopViewController *shopController = [[ShopViewController alloc]init];
        [shopController setDataSource:[self.dataArray objectAtIndex:indexPath.row]];
        shopController.merchantId = model.merchantId;
        [self.navigationController pushViewController:shopController animated:YES];
    }
    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Width *0.19;
    
    
    
}

- (IBAction)BackAction:(UIButton *)sender {
    self.GoodsListVCBlock(sender.tag==10001 ?@"": self.keyword);
    [self.navigationController popViewControllerAnimated:sender.tag==10001 ?YES :NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end
