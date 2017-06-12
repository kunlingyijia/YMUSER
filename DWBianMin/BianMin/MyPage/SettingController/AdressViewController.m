//
//  AdressViewController.m
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AdressViewController.h"
#import "AdressCell.h"
#import "AdressModel.h"
#import "AddAdressViewController.h"
#import "RequestListAddress.h"
#import "RequestDeleteAddress.h"
@interface AdressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AdressViewController


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收货地址";
    //self.view.backgroundColor = [UIColor whiteColor];
   
    [self showBackBtn];
    [self createView];
}

- (void)getAdressDataList {
    
    RequestListAddress *reqListAdress = [[RequestListAddress alloc] init];
    reqListAdress.pageCount = 10;
    reqListAdress.pageIndex = 1;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[reqListAdress yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.token = [AuthenticationModel getLoginToken];
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestListAddress" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"------%@",response);
        __weak typeof(self) weakSelf = self;
   
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakSelf.dataSource removeAllObjects];
            for (NSDictionary *dic in baseRes.data) {
                AdressModel *model = [AdressModel yy_modelWithDictionary:dic];
                [weakSelf.dataSource addObject:model];
            }
            [weakSelf.tableView reloadData];

        }else{
            [weakSelf showToast:baseRes.msg];
            
        }
       
    } faild:^(id error) {
        NSLog(@"%@",error);
    }];
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64 - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.rowHeight = 60;
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[AdressCell class] forCellReuseIdentifier:@"adressCell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    
    
    UIButton *addAdressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAdressBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addAdressBtn addTarget:self action:@selector(addAdressAction:) forControlEvents:UIControlEventTouchUpInside];
    addAdressBtn.layer.masksToBounds = YES;
    addAdressBtn.layer.cornerRadius = 2;
    addAdressBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    addAdressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [addAdressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:addAdressBtn];
    [addAdressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(20);
        make.height.mas_offset(@(Width/10));
    }];
    
     [self getAdressDataList];
    
}

#pragma mark - 添加新地址事件
- (void)addAdressAction:(UIButton *)sender {
    OKLog(@"添加新地址");
    AddAdressViewController *addController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAdressViewController"];
    addController.amendAdressBlock = ^(AdressModel *model) {
        [self.dataSource removeAllObjects];
        [self getAdressDataList];
    };
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.isSelectedAdress integerValue] == 8) {
        //从便民订单进入
        AdressModel *model = self.dataSource[indexPath.row];
        self.selectedAdress(model);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
//    AddAdressViewController *addController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAdressViewController"];
//    
//    addController.amendAdressBlock = ^(AdressModel *model) {
//        [self.dataSource removeAllObjects];
//        [self getAdressDataList];
//        
//    };
//    
//    [self.navigationController pushViewController:addController animated:YES];
    AdressModel *model = self.dataSource[indexPath.row];
    if (![self.isSelectedAdress isEqualToString:@"6"]) {
        AddAdressViewController *addC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddAdressViewController"];
        addC.amendAdressBlock = ^(AdressModel *model) {
            [self.dataSource removeAllObjects];
            [self getAdressDataList];
        };
        addC.isChange = @"6";
        addC.model = model;
        NSLog(@"%@\n%@\n%@", model.address,model.zone,model.street);
        [self.navigationController pushViewController:addC animated:YES];
    }else {
        RequestDeleteAddress *delete = [[RequestDeleteAddress  alloc] init];
        AdressModel *model = self.dataSource[indexPath.row];
        delete.addressId = model.addressId;
        BaseRequest *baseReq = [BaseRequest alloc];
        baseReq.data = [AESCrypt encrypt:[delete yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requesSetDefaultAddress" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [self.dataSource removeAllObjects];
                [self getAdressDataList];
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.isSelectedAdress isEqualToString:@"6"]) {
                    self.selectedAdress(model);
                }
            }else {
                [self showToast:baseRes.msg];
                //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            }
        } faild:^(id error) {
        }];
    }
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adressCell" forIndexPath:indexPath];
    AdressModel *model = self.dataSource[indexPath.row];
    [cell cellGetData:model];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        OKLog(@"删除地址");
        //删除数据源
        RequestDeleteAddress *delete = [[RequestDeleteAddress  alloc] init];
        AdressModel *model = self.dataSource[indexPath.row];
        if (model.isDefault == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"这是默认地址 不能删除" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertC animated:YES completion:nil];
        }else {
            delete.addressId = model.addressId;
            BaseRequest *baseReq = [BaseRequest alloc];
            baseReq.data = [AESCrypt encrypt:[delete yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            __weak typeof(self) weakSelf = self;

            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestDeleteAddress" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
                    //[weakSelf.dataSource removeAllObjects];
                    [weakSelf getAdressDataList];
                }else{
                    [weakSelf showToast:baseRes.msg];
                    
                }
                NSLog(@"%@", response);
            } faild:^(id error) {
                
            }];

        }
    }
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
