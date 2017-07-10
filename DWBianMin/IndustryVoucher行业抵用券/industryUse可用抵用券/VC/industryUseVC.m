//
//  industryUseVC.m
//  BianMin
//
//  Created by 席亚坤 on 2017/6/20.
//  Copyright © 2017年 bianming. All rights reserved.
//
#import "industryUseVC.h"
#import "industryUseOneCell.h"
#import "IndustryModel.h"
@interface industryUseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation industryUseVC
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark -  载入完成
- (void)viewDidLoad {
    [super viewDidLoad];
    //关于UI
    [self SET_UI];
    //关于数据
    [self  SET_DATA];
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"选择行业抵用券";
    [self setUpTableView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBg];
    
    
    
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Width*0.125+20, Width, Height-64-Width*0.125-20) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    _tableView.tableFooterView = [UIView new];
    _tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"industryUseOneCell"]];
}
#pragma mark - 关于数据
-(void)SET_DATA{
     self.ChoseBtn.selected = self.industryModel.industryCouponUserId.length==0 ?YES :NO;
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
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"companyId":self.industryModel.companyId.length ==0? @"":self.industryModel.companyId,@"merchantId":self.industryModel.merchantId.length ==0? @"":self.industryModel.merchantId,@"amount":self.industryModel.amount}mutableCopy];
        __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/IndustryCouponUser/requestSelectIndustryCouponList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            NSLog(@"%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            if (baseRes.resultCode ==1) {
                NSMutableArray *arr = baseRes.data;
                for (NSDictionary *dicData in arr) {
                    IndustryModel *model = [IndustryModel yy_modelWithJSON:dicData];
                    model.selected = [weakself.industryModel.industryCouponUserId isEqualToString:model.industryCouponUserId] ? YES : NO;
                    [weakself.dataArray addObject:model];
                }
                //刷新
                [weakself.tableView reloadData];
            }else{
                [weakself showToast:baseRes.msg];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
    }else {
        
    }
}
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [tableView tableViewDisplayWitimage:@"列表为空-1" ifNecessaryForRowCount:self.dataArray.count];
    //分区个数
    return self.dataArray.count;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section>self.dataArray.count-1||self.dataArray.count==0) {
            return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        }else{
    industryUseOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"industryUseOneCell" forIndexPath:indexPath];
    //cell 赋值
    cell.model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
    // cell 其他配置
    return cell;
    
     }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
   IndustryModel*  model = indexPath.section >= self.dataArray.count ? nil :self.dataArray[indexPath.section];
    //string	1-可选择，2-不可选择
    if ([model.selectStatus isEqualToString:@"1"]) {
        self.ChoseBtn.selected = NO;
        self.industryModel.industryCouponUserId = model.industryCouponUserId;
        self.industryModel.amount = model.faceAmount;
        for (IndustryModel*  model in self.dataArray) {
            model.selected = [self.industryModel.industryCouponUserId isEqualToString:model.industryCouponUserId] ? YES : NO;
        }
        self.industryUseVCBlock(self.industryModel);
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.25*Width;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (IBAction)ChoseBtnAction:(UIButton *)sender {
    sender.selected = YES;
    self.industryModel.industryCouponUserId = @"";
    for (IndustryModel*  model in self.dataArray) {
        model.selected =  NO;
    }
    [self.tableView reloadData];
    self.industryUseVCBlock(self.industryModel);
     [self.navigationController popViewControllerAnimated:YES];
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
