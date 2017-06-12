//
//  TripListController.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripListController.h"
#import "TripSearchLineController.h"
#import "TripListCell.h"
#import "TripModel.h"
#import "ServiceDetailsVC.h"
#import "TripPayVC.h"
#import "UserOrderViewController.h"
#import "TripPayVC.h"

@interface TripListController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation TripListController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
   // [self showBackBtn];
    __weak typeof(self) weakSelf = self;

    [self showBackBtn:^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.title = @"出行列表";
    //设置右上角"搜索"的按钮样式
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.contentMode = UIViewContentModeRight;
    //把按钮添加在导航框右边
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //设置TableView自定义注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TripListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TripListCell"];
    self.tableView.rowHeight = 0.4*Width+10;
    //设置tableViewCell之间的那条线隐藏掉
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置隐藏tableView多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];

    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    self.pageIndex = 1;
    [self requestTravelPlanList];
    [self Refresh];
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.pageIndex =1 ;
        [weakself requestTravelPlanList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        // weakself.navigationView.hidden = NO;
        
        [weakself requestTravelPlanList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 车次列表/搜索

-(void)requestTravelPlanList{
    NSLog(@"%@",self.date);
        NSString *Token =[AuthenticationModel getLoginToken];
    NSLog(@"-------%@",self.dateStr);
    NSString * regionId = [AuthenticationModel getRegionID];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic  = [@{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"startPlace":self.startPlace,@"endPlace":self.endPlace,@"regionId":regionId,@"date":self.dateStr}mutableCopy];
        NSLog(@"%@",dic);
        __weak typeof(self) weakself = self;
      //  if (Token.length!= 0) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = RequestMD5;
    
          baseReq.data = [dic yy_modelToJSONObject];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelPlan/requestTravelPlanList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response)  {
                
                NSLog(@" 车次列表/搜索----%@",response);
                if ([response[@"resultCode"] isEqualToString:@"1"]) {
                    if (weakself.pageIndex == 1) {
                        [weakself.dataArray removeAllObjects];
                    }
                    NSArray *arr = response[@"data"];
                    for (NSDictionary *dicdata in arr) {
                        TripModel *model = [TripModel yy_modelWithJSON:dicdata];
                        [weakself.dataArray addObject:model];
                    }
                    //刷新
                    [weakself.tableView reloadData];
                }else{
                    [weakself showToast:response[@"msg"]];
                    
                }
                
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];
            
       // }
//else {
//            
//        }
//        
//        

    
    
}

//"搜索"的按钮事件
- (void)searchBtnAction:(UIButton *)button {
    TripSearchLineController *tripSearchLineController = [[TripSearchLineController alloc] init];
    [self.navigationController pushViewController:tripSearchLineController animated:YES];
    
    
}

#pragma mark - UITableViewDataSource
//设置cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripListCell" forIndexPath:indexPath];
    [cell CellGetData: self.dataArray[indexPath.row]];
    //设置点击cell不会变成灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
//设置每个cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转至去拼车的界面......
    //Push 跳转
    ServiceDetailsVC * VC = [[ServiceDetailsVC alloc]initWithNibName:@"ServiceDetailsVC" bundle:nil];
    VC.tripModel = self.dataArray[indexPath.row];
    [self.navigationController  pushViewController:VC animated:YES];
    
   

    
//    //Push 跳转
//
//    TripPayVC
//   * VC1 = [[TripPayVC alloc]initWithNibName:@"TripPayVC" bundle:nil];
//    [self.navigationController  pushViewController:VC1 animated:YES];


}
@end
