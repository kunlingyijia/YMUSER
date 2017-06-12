//
//  TravelOrderVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TravelOrderVC.h"
#import "TravelOrderCell.h"
#import "TripModel.h"
#import "TOrderDetailsVC.h"
#import "DWHomePageViewController.h"
#import "DWMyViewController.h"

@interface TravelOrderVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation TravelOrderVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self requestTripOrderList];
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
//    [self showBackBtn];
    [self showBackBtn:^{
        for (BaseViewController *tempVC in self.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[DWHomePageViewController class]]) {
                [self.navigationController popToViewController:tempVC  animated:YES];
                return ;
            }
            if ([tempVC isKindOfClass:[DWMyViewController class]]) {
                [self.navigationController popToViewController:tempVC  animated:YES];
                return ;
            }
        }
    }];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    self.title = @"订单列表";
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"TravelOrderCell"]];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.pageIndex = 1;
   
    [self Refresh];
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.pageIndex =1 ;
        [weakself requestTripOrderList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        // weakself.navigationView.hidden = NO;
        
        [weakself requestTripOrderList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 我的出行订单列表
-(void)requestTripOrderList{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrder/requestMyOrderList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@" 我的出行订单列表----%@",response);
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
        
    }else {
        
    }
    
    
    
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
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    TravelOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TravelOrderCell" forIndexPath:indexPath];
    [cell CellGetData:self.dataArray[indexPath.row]];
    
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TripModel *model = self.dataArray[indexPath.row];
    //Push 跳转
    TOrderDetailsVC * VC = [[TOrderDetailsVC alloc]initWithNibName:@"TOrderDetailsVC" bundle:nil];
    VC.orderId = model.orderId;
    VC.orderNo = model.orderNo;
    [self.navigationController  pushViewController:VC animated:YES];

}

#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.4*Width+10;
    
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
