//
//  MyCouponList.m
//  BianMin
//
//  Created by z on 16/5/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyCouponList.h"
#import "MyCouponCell.h"
#import "RequestMyCouponList.h"
#import "RequestMyCouponListModel.h"
@interface MyCouponList()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *fakeData;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger type;

@end

@implementation MyCouponList

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        self.btnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.pageIndex = 1;
    self.type = 0;
    [self showBackBtn];
    self.title = @"我的抵用券";
    self.fakeData = [FakeData getHomePageShopData];
    [self initWithCustomView];
    [self creatBtn];
}

- (void)creatBtn {
     CGFloat btnW = (Width - 3)/4;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.lineV.frame = CGRectMake(10, 35,btnW - 20, 2);
    [bgView addSubview:self.lineV];
    NSArray *nameArr = @[@"全部",@"已使用",@"未使用",@"已过期"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((btnW + 1) * i, 0, btnW, 35);
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
        [bgView addSubview:btn];
        [self.btnArray addObject:btn];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
        }
        UIView *forLine = [UIView new];
        [bgView addSubview:forLine];
        forLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
        [forLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).with.offset(5);
            make.left.equalTo(btn.mas_right);
            make.bottom.equalTo(bgView).with.offset(-5);
            make.width.equalTo(@(2));
        }];
    }
}

-(void)btnAction:(UIButton *)sender {
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton *btn = self.btnArray[i];
        [btn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.lineV.frame = CGRectMake(sender.frame.origin.x + 10, self.lineV.frame.origin.y, self.lineV.frame.size.width, 2);
    }];
    if ([sender.titleLabel.text isEqualToString:@"全部"]) {
        self.pageIndex = 1;
        [self.dataSource removeAllObjects];
        self.type = 0;
        [self getDataList];
    }else if ([sender.titleLabel.text isEqualToString:@"已使用"]) {
        self.pageIndex = 1;
        [self.dataSource removeAllObjects];
        self.type = 2;
        [self getDataList];
    }else if ([sender.titleLabel.text isEqualToString:@"未使用"]) {
        self.pageIndex = 1;
        [self.dataSource removeAllObjects];
        self.type = 1;
        [self getDataList];
    }else if ([sender.titleLabel.text isEqualToString:@"已过期"]) {
        self.pageIndex = 1;
        [self.dataSource removeAllObjects];
        self.type = 3;
        [self getDataList];
    }
}

#pragma mark TabelViewDataSource
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    //分区个数
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCouponCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RequestMyCouponListModel *model = self.dataSource[indexPath.section];
    [cell cellGetDataModel:model withController:self];
    return cell;
}

#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;


}
//iOS 8.0 后才有的方法
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    RequestMyCouponListModel *model= self.dataSource[indexPath.section];
        __weak typeof(self) weakSelf = self;
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [weakSelf alertWithTitle:@"是否删除?" message:nil OKWithTitle:@"删除" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                NSString *Token =[AuthenticationModel getLoginToken];
                __weak typeof(self) weakself = self;
                if (Token.length!= 0) {
                    BaseRequest *baseReq = [[BaseRequest alloc] init];
                    baseReq.token = [AuthenticationModel getLoginToken];
                    baseReq.encryptionType = AES;
                    baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
                    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestDeleteMyCoupon" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                        NSLog(@"删除抵用券----%@",response);
                        if ([response[@"resultCode"] isEqualToString:@"1"]) {
                            [weakSelf.dataSource removeObjectAtIndex:indexPath.section];
                            [weakSelf.tableView reloadData];
                        }else{
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                            [weakself showToast:response[@"msg"]];
                        }
                        
                    } faild:^(id error) {
                        NSLog(@"%@", error);
                    }];
                }
            } withCancel:^(UIAlertAction *cancelaction) {
                
            }];
        }];
        return @[delete];
   
    
    
    
    
}








- (void)initWithCustomView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, Width, Height-40-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCouponCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"myCouponCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getDataList];
    }];
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView = bgView;
    [self getDataList];
}

- (void)getDataList {
    RequestMyCouponList *couponList = [[RequestMyCouponList alloc] init];
    couponList.pageCount = 10;
    couponList.pageIndex = self.pageIndex;
    couponList.status = self.type;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[couponList yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestMyCouponList" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMyCouponListModel *model = [RequestMyCouponListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }else {
             [self showToast:baseRes.msg];//[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
    
}



@end
