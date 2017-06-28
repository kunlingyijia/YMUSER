//
//  DWMyViewController.m
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWMyViewController.h"
#import "DWHelper.h"
#import "UMSocial.h"
#import "MyCenterCell.h"
#import "Masonry.h"
#import "LoginController.h"
#import "SettingController.h"
#import "IntegralViewController.h"
#import "OrderViewController.h"
#import "DWWebViewController.h"
#import "MerchantSettle.h"
#import "MyCollectMerchant.h"
#import "MyCouponList.h"
#import "SettingMessageController.h"
#import "SignInViewController.h"
#import "RequestUserInfo.h"
#import "AuthenticationModel.h"
#import "UserModel.h"
#import "RequestMyGoodsOrderNumberModel.h"
#import "BmOrderController.h"
#import "GoOutOrderController.h"
#import "RequestWallet.h"
#import "RequestWalletModel.h"
#import "WebLoginController.h"
#import "RequestLogin.h"
#import "LoginResponse.h"
#import "NewMerchantEnterController.h"
#import "TravelOrderVC.h"
#import "IndustryListVC.h"
#import "ReceiveIndustry.h"
#import "IndustryModel.h"
@interface DWMyViewController ()<UMSocialUIDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *nameArray;
//名字
@property (nonatomic, strong)NSMutableArray *myArray;
@property (nonatomic, strong)NSMutableArray *myArrayImages;
@property (nonatomic, strong)NSMutableArray *cellImages;
//签到按钮
@property (nonatomic, strong)UIButton *signInBtn;
//头像
@property (nonatomic, strong)UIImageView *photoImage;
//登录文字
@property (nonatomic, strong) UILabel *loginLabel;
//名字
@property (nonatomic, strong) UILabel *nameLabel;
//登录后的说明
@property (nonatomic, strong) UILabel *signNameLabel;
//是否登录
@property (nonatomic, assign) BOOL IsLogin;
@property (nonatomic, strong) NSMutableArray *numberLabelArr;
@property (nonatomic, strong) UserModel *userModel;
@end



@implementation DWMyViewController
- (NSMutableArray *)numberLabelArr {
    if (!_numberLabelArr) {
        self.numberLabelArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _numberLabelArr;
}

- (NSMutableArray *)cellImages {
    if (!_cellImages) {
        self.cellImages = [NSMutableArray arrayWithObjects:@[@"icon_home_bianmin",@"拼车"],@[@"icon_my_wodeshoucang", @"icon_mydiyongquan",@"行业抵用券0"],@[@"icon_my_jifenshangcheng"],@[@"icon_my_lianxikefu"],@[@"icon_my_woyaohezuo"], nil];
    }
    return _cellImages;
}

- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        self.nameArray = [NSMutableArray arrayWithObjects:@[@"便民订单",@"出行订单"],@[@"我的收藏",@"抵用券",@"行业抵用券"],@[ @"易民钱包"],@[@"联系客服"], nil];
    }
    return _nameArray;
}
- (NSMutableArray *)myArray {
    if (!_myArray) {
        self.myArray = [NSMutableArray arrayWithObjects:@"待付款",@"待使用",@"待评价",@"退款/售后", nil];
    }
    return _myArray;
}

- (NSMutableArray *)myArrayImages {
    if (!_myArrayImages) {
        self.myArrayImages = [NSMutableArray arrayWithObjects:@"icon_my_daifukuan",@"icon_my_daishiyong",@"icon_my_daipingjia",@"icon_my_shouhou", nil];
    }
    return _myArrayImages;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.navigationController.navigationBar.translucent = NO;
    [self getOrderNumber];

    //去掉底部的黑线
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];

   
    self.title = @"我的";
    [self createTableView];
    [self setupNavigationItem];
    //获取系统配置信息
    [self getConfig];
    //接受登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogin:) name:@"登录成功" object:nil];
    //退出账号
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitLoginAction:) name:@"退出账号" object:nil];
    //签到成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signSuccessAction:) name:@"签到成功" object:@"签到成功"];
    
}
//程序运行时 判断是不是运行过 自动登录
- (void)isloginAction {
    [self loginAction];
}
//登录成功后执行的方法
- (void)successLogin:(NSNotification *)sender {
    [self netWorkUserMessage];
}
- (void)signSuccessAction:(NSNotification *)sender {
     [self.signInBtn setImage:[UIImage imageNamed:@"btn_my_yidenglu_qiandao"] forState:UIControlStateNormal];
}


//请求个人信息

- (void)loginAction {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSString *passWord = [userDefaults objectForKey:@"passWord"];
    RequestLogin *login = [[RequestLogin alloc] init];
    login.mobile = name;
    login.password = [passWord MD5Hash];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.data = [login yy_modelToJSONObject];
    baseReq.encryptionType = RequestMD5;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestLogin" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        LoginResponse *registResq = [LoginResponse yy_modelWithJSON:response];
        
        LoginResponse *registData = [LoginResponse yy_modelWithJSON:[registResq.data yy_modelToJSONString]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:registData.key forKey:@"loginKey"];
        [userDefaults setObject:registData.token forKey:@"loginToken"];
        if (registResq.resultCode == 1) {
            [userDefaults setObject:@(1) forKey:@"isLogin"];
            DWHelper *helper =  [DWHelper shareHelper];
            helper.isLogin = @(1);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"登录成功" object:@"登录成功" userInfo:@{}];
            [self netWorkUserMessage];
        }else {
            [userDefaults setObject:@(0) forKey:@"isLogin"];
            DWHelper *helper =  [DWHelper shareHelper];
            helper.isLogin = @(0);
        }
    } faild:^(id error) {
        
    }];
}
#pragma mark - 用户信息
- (void)netWorkUserMessage {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    NSLog(@"%@",[AuthenticationModel getLoginToken]);
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUserInfo" sign:[baseReq.data  MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseResponse = [BaseResponse yy_modelWithJSON:response];
        UserModel *innerModel = [UserModel yy_modelWithJSON:response];
        self.userModel = [UserModel yy_modelWithJSON:innerModel.data];
        if (baseResponse.resultCode == 1) {
            NSLog(@"%@", self.userModel.userId);
            [JPUSHService setAlias:self.userModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.userModel.userId forKey:@"userID"];
            [self loginView];
            self.nameLabel.text = self.userModel.userName;
            self.signNameLabel.text = self.userModel.signature;
            NSLog(@"%ld", (long)self.userModel.isSign);
            if (self.userModel.isSign == 1) {
                [self.signInBtn setImage:[UIImage imageNamed:@"btn_my_yidenglu_qiandao"] forState:UIControlStateNormal];
            }else {
                [self.signInBtn setImage:[UIImage imageNamed:@"btn_my_yidenglu_weiqiandao"] forState:UIControlStateNormal];
            }
            if (self.userModel.avatarUrl == nil || self.userModel.avatarUrl == NULL) {
                self.photoImage.image = [UIImage imageNamed:@"def_my_zhuye_touxiang"];
            }else {
                [self loadImageWithView:self.photoImage urlStr:self.userModel.avatarUrl];
            }
            [self getOrderNumber];
        }else if (baseResponse.resultCode == 10) {
            
        }else {
            [self showToast:baseResponse.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseResponse viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}

- (void)callPhoneNumber {
    
}

- (void)getOrderNumber {
    if ([self isLogin ]) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyGoodsOrderNumber" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                for (NSDictionary *dic in baseRes.data) {
                    RequestMyGoodsOrderNumberModel *orderModel = [RequestMyGoodsOrderNumberModel yy_modelWithDictionary:dic];
                    if (orderModel.orderStatus == 1) {
                        UILabel *label = self.numberLabelArr[0];
                        if ([orderModel.number isEqualToString:@"0"]) {
                            label.hidden = YES;
                        }else {
                            label.text = orderModel.number;
                            label.hidden = NO;
                        }
                    }else if (orderModel.orderStatus == 2) {
                        UILabel *label = self.numberLabelArr[1];
                        if ([orderModel.number isEqualToString:@"0"]) {
                            label.hidden = YES;
                        }else {
                            label.text = orderModel.number;
                            label.hidden = NO;
                        }
                    }else if (orderModel.orderStatus == 3) {
                        UILabel *label = self.numberLabelArr[2];
                        if ([orderModel.number isEqualToString:@"0"]) {
                            label.hidden = YES;
                        }else {
                            label.text = orderModel.number;
                            label.hidden = NO;
                        }
                    }else if (orderModel.orderStatus == 4) {
                        UILabel *label = self.numberLabelArr[3];
                        if ([orderModel.number isEqualToString:@"0"]) {
                            label.hidden = YES;
                        }else {
                            label.text = orderModel.number;
                            label.hidden = NO;
                        }
                    }
                }
            }else {
               // [self showToast:baseRes.msg];
            }
           
        } faild:^(id error) {
            
        }];
 
    }
   }

- (void)loginView {
    self.IsLogin = YES;
    self.photoImage.frame = CGRectMake((Width-60)/2, 10, 60, 60);
    self.nameLabel.hidden = NO;
    self.signNameLabel.hidden = NO;
    self.signInBtn.hidden = NO;
    self.loginLabel.hidden = YES;
}

//退出成功后执行的方法
- (void)quitLoginAction:(NSNotification *)sender {
    self.IsLogin = NO;
    self.photoImage.frame = CGRectMake(10, 10, 60, 60);
    self.photoImage.image = [UIImage imageNamed:@"def_my_zhuye_touxiang"];
    self.loginLabel.frame = CGRectMake(80, 30, 100, 20);
    self.nameLabel.hidden = YES;
    self.signNameLabel.hidden = YES;
    self.signInBtn.hidden = YES;
    self.loginLabel.hidden = NO;
    for (int i = 0; i < self.numberLabelArr.count; i++) {
        UILabel *numberLabel = self.numberLabelArr[i];
        numberLabel.hidden = YES;
    }
    [self getOrderNumber];

}


#pragma mark - NavigationItemView
- (void)setupNavigationItem {

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"icon_my_shezhi"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [backBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;

}
- (void)settingAction:(UIButton *)sender {
    SettingController *settingController = [[SettingController alloc] init];
    settingController.qqToken = self.userModel.qqToken;
    settingController.wechaToken = self.userModel.wechaToken;
    __weak DWMyViewController *weakSelf = self;
    settingController.backAction = ^(NSString *str) {
        [weakSelf netWorkUserMessage];
    };
    [self.navigationController pushViewController:settingController animated:YES];
    OKLog(@"设置");
}

- (void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.rowHeight = Width/8;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCenterCell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview: self.tableView];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView = footView;
    [self createHeaderView];
    
    [self Refresh];
    
   
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self isLogin]) {
            [self getOrderNumber];
        }

        //进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
    
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([self isLogin]) {
            [self getOrderNumber];
        }        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
- (void)createHeaderView {
    
    self.headerView = [[UIView alloc] init];
    if (Height == 736) {
        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.height /3 + 40 - 30);
    }else if(Height == 480) {
        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.height /3 + 40 - 30+55);
    }else {
        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.height /3 + 40 - 10);
    }
    self.headerView.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    //头像
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction:)];
    self.photoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"def_my_zhuye_touxiang"]];
    self.photoImage.userInteractionEnabled = YES;
    [self.photoImage addGestureRecognizer:photoTap];
    self.photoImage.frame = CGRectMake(10, 10, 60, 60);
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 30;
    [self.headerView addSubview:self.photoImage];
    //提示登录
    self.loginLabel = [UILabel new];
    self.loginLabel.text = @"请点击登录";
    self.loginLabel.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(loginAction:)];
    self.loginLabel.userInteractionEnabled = YES;
    [self.loginLabel addGestureRecognizer:tap];
    self.loginLabel.font = [UIFont systemFontOfSize:15];
    [self.headerView addSubview:self.loginLabel];
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.photoImage);
        make.left.mas_equalTo(self.photoImage.mas_right).with.offset(10);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(100));
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.headerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoImage.mas_bottom).with.offset(50);
        make.left.equalTo(self.headerView);
        make.bottom.mas_equalTo(self.headerView.mas_bottom);
        make.width.mas_equalTo(@(Bounds.size.width));
    }];
    
    //我的订单部分
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, Bounds.size.width, 30)];
    orderView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:orderView];
    UITapGestureRecognizer *orderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderAction:)];
    [orderView addGestureRecognizer:orderTap];
    
    UIImageView *pictureImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    pictureImage.image = [UIImage imageNamed:@"icon_my_wodedingdan"];
    [orderView addSubview:pictureImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pictureImage.frame)+15, 5, 100, 20)];
    nameLabel.text = @"我的订单";
    
    nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [orderView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *showLabel = [UILabel new];
    showLabel.text = @"查看全部订单";
    showLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    showLabel.font = [UIFont systemFontOfSize:10];
    showLabel.textColor = [UIColor grayColor];
    showLabel.textAlignment = NSTextAlignmentRight;
    [orderView addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(orderView);
        make.right.mas_equalTo(orderView.mas_right).with.offset(-25);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(100));
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"图层-66"]];
    [orderView addSubview:rightArrow];
    rightArrow.contentMode = UIViewContentModeScaleAspectFit;
    
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(showLabel.mas_centerY);
        make.right.mas_equalTo(orderView.mas_right).with.offset(-12);
        make.width.mas_equalTo(@(12));
        make.height.mas_equalTo(@(12));
    }];
    
    //待付款部分
    UIView *fourView = [UIView new];
    fourView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:fourView];
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderView.mas_bottom);
        make.bottom.mas_equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.headerView);
        make.width.mas_equalTo(@(Width));
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 1, Bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [fourView addSubview:lineView];
    float pading = 48;
    float itemWidth = (Bounds.size.width - pading*5)/4;
    float itWidth = (Bounds.size.width)/4;
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * ((Bounds.size.width)/4) , 10, itWidth, itemWidth);
        [btn setImage:[UIImage imageNamed:self.myArrayImages[i]] forState:UIControlStateNormal];
        btn.tag = 110 + i;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [fourView addSubview:btn];
        
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.layer.masksToBounds = YES;
        numberLabel.layer.cornerRadius = 15/2.0;
        numberLabel.layer.borderColor = [UIColor redColor].CGColor;
        numberLabel.layer.borderWidth = 0.5;
        numberLabel.text = @"10";
        numberLabel.hidden = YES;
        numberLabel.textColor = [UIColor redColor];
        numberLabel.font = [UIFont systemFontOfSize:8];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.numberLabelArr addObject:numberLabel];
        [fourView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.imageView).with.offset(-5);
            make.left.equalTo(btn.imageView.mas_right).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        UILabel *imageLabel = [[UILabel alloc] init];
//        imageLabel.backgroundColor = [UIColor greenColor];
        imageLabel.textAlignment = NSTextAlignmentCenter;
        imageLabel.text = self.myArray[i];
        imageLabel.font = [UIFont systemFontOfSize:10];
        imageLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
        [fourView addSubview:imageLabel];
        [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom);
            make.centerX.equalTo(btn);
            make.size.mas_equalTo(CGSizeMake((Bounds.size.width - 200)/4 + 30, 15));
        }];
    }
//    登录之后的显示的控件
    self.signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signInBtn.frame = CGRectMake(0, 0, 50, 30);
    self.signInBtn.hidden = YES;
    
    self.signInBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.signInBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.signInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.signInBtn addTarget:self action:@selector(signInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.signInBtn];
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"";
    self.nameLabel.hidden = YES;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.headerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.photoImage.mas_centerX);
        make.top.equalTo(self.photoImage.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(Width-20, 20));
    }];
    
    self.signNameLabel = [UILabel new];
    self.signNameLabel.hidden = YES;
    self.signNameLabel.text = @"";
    self.signNameLabel.textAlignment = NSTextAlignmentCenter;
    self.signNameLabel.textColor = [UIColor whiteColor];
    self.signNameLabel.font = [UIFont systemFontOfSize:12];
    [self.headerView addSubview:self.signNameLabel];
    [self.signNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.centerX.equalTo(self.photoImage.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    self.tableView.tableHeaderView = self.headerView;
    
    
    //判断是否登录过
    DWHelper *helper =  [DWHelper shareHelper];
    if ([helper.isLogin integerValue]==1) {
        self.IsLogin = YES;
        self.photoImage.frame = CGRectMake((Width-60)/2, 10, 60, 60);
        self.nameLabel.hidden = NO;
        self.signNameLabel.hidden = NO;
        self.signInBtn.hidden = NO;
        self.loginLabel.hidden = YES;

        
        [self isloginAction];
    }else {
        self.IsLogin = NO;
        self.photoImage.frame = CGRectMake(10, 10, 60, 60);
        self.photoImage.image = [UIImage imageNamed:@"def_my_zhuye_touxiang"];
        self.loginLabel.frame = CGRectMake(80, 30, 100, 20);
        self.nameLabel.hidden = YES;
        self.signNameLabel.hidden = YES;
        self.signInBtn.hidden = YES;
        self.loginLabel.hidden = NO;
    }

    
    
}

#pragma mark - 签到
- (void)signInBtnAction:(UIButton *)sender {
    OKLog(@"签到");
    SignInViewController *signController = [[SignInViewController alloc] init];
    __weak DWMyViewController *weakSelf = self;
    signController.backAction = ^(NSString *str) {
        [weakSelf netWorkUserMessage];
    };
    [self.navigationController pushViewController:signController animated:YES];
}


#pragma mark - 登录按钮
- (void)loginAction:(id)sender {
    if (self.IsLogin == YES) {
        SettingMessageController *settingMessageController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingMessageController"];
        settingMessageController.userModel = self.userModel;
        
        __weak DWMyViewController *weakSelf = self;
        settingMessageController.messageBlock = ^(UserModel *model) {
            [weakSelf netWorkUserMessage];
        };
        [self.navigationController pushViewController:settingMessageController animated:YES];
    }else {
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
        OKLog(@"登录");

    }
}

- (void)orderAction:(UITapGestureRecognizer *)sender {
    OKLog(@"查看全部订单");
    if ([self isLogin]) {
        OrderViewController *orderVC = [[OrderViewController alloc] init];
        [orderVC setTitle:@"全部"];
        [self.navigationController pushViewController:orderVC animated:YES];
    }else {
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
    }
}
- (void)btnAction:(UIButton *)sender {
    if ([self isLogin]) {
        OrderViewController *orderVC = [[OrderViewController alloc] init];
        orderVC.isNew = @"6";
        orderVC.newKind = sender.tag - 110;
        [orderVC setTitle:self.myArray[sender.tag - 110]];
        [self.navigationController pushViewController:orderVC animated:YES];
    }else {
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
    }
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = self.nameArray[indexPath.section][indexPath.row];
     if ([self isLogin]) {
    if ([title isEqualToString:@"便民订单"]) {
        BmOrderController *bmC = [[BmOrderController alloc] init];
        [self.navigationController pushViewController:bmC animated:YES];
    }
    if ([title isEqualToString:@"出行订单"]) {
        //Push 跳转
        TravelOrderVC * VC = [[TravelOrderVC alloc]initWithNibName:@"TravelOrderVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }
    if ([title isEqualToString:@"我的收藏"]) {
             MyCollectMerchant *m = [[MyCollectMerchant alloc] init];
             [self.navigationController pushViewController:m animated:YES];
    }
    if ([title isEqualToString:@"抵用券"]) {
             [self.navigationController pushViewController:[[MyCouponList alloc] init] animated:YES];
    }
    if ([title isEqualToString:@"行业抵用券"]) {
//        //Push 跳转
        IndustryListVC * VC = [[IndustryListVC alloc]initWithNibName:@"IndustryListVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];

    }
    if ([title isEqualToString:@"易民钱包"]) {
             [self webAction];
    }
    if ([title isEqualToString:@"联系客服"]) {
             DWHelper *helper = [DWHelper shareHelper];
             [self alertWithTitle:@"温馨提示" message:@"是否拨客服电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
                 
                 NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",helper.configModel.plat_kfmobile];
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                 
             } withCancel:^(UIAlertAction *cancelaction) {
             }];
         }

    }else{
        
        if ([title isEqualToString:@"联系客服"]) {
            DWHelper *helper = [DWHelper shareHelper];
            [self alertWithTitle:@"温馨提示" message:@"是否拨客服电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",helper.configModel.plat_kfmobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            } withCancel:^(UIAlertAction *cancelaction) {
                
            }];
        }else{
         LoginController *loginController = [[LoginController alloc] init];
         [self.navigationController pushViewController:loginController animated:YES];
        }
     }
    
    
    
    
    
    
//    
//    if ([self isLogin]) {
//        if (indexPath.section == 1) {
//            if (indexPath.row == 0) {
//                MyCollectMerchant *m = [[MyCollectMerchant alloc] init];
//                [self.navigationController pushViewController:m animated:YES];
//            }else if(indexPath.row == 1){
//               [self.navigationController pushViewController:[[MyCouponList alloc] init] animated:YES];
//            }else{
//                
//            }
//        }
//        if (indexPath.section == 2) {
//            if (indexPath.row == 0) {
//
//                 [self webAction];
//            }
//        }
//        if (indexPath.section == 3) {
//            if (indexPath.row == 0) {
//                DWHelper *helper = [DWHelper shareHelper];
//                [self alertWithTitle:@"温馨提示" message:@"是否拨客服电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
//                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",helper.configModel.plat_kfmobile];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//                   
//                } withCancel:^(UIAlertAction *cancelaction) {
//                    
//                }];
//            }
//        }
//        if (indexPath.section == 4) {
//            NewMerchantEnterController *merchatSettle = [[NewMerchantEnterController alloc] initWithNibName:@"NewMerchantEnterController" bundle:nil];
//            [self.navigationController pushViewController:merchatSettle animated:YES];
//        }
//        
//        if (indexPath.section == 0) {
//            if (indexPath.row == 0) {
//                BmOrderController *bmC = [[BmOrderController alloc] init];
//                [self.navigationController pushViewController:bmC animated:YES];
//            }else {
//
//                //Push 跳转
//                TravelOrderVC * VC = [[TravelOrderVC alloc]initWithNibName:@"TravelOrderVC" bundle:nil];
//                [self.navigationController  pushViewController:VC animated:YES];
//            }
//        }
//    }else {
//        if (indexPath.section == 3) {
//            if (indexPath.row == 0) {
//                __weak typeof(self) weakSelf = self;
//                DWHelper *helper = [DWHelper shareHelper];
//                [self alertWithTitle:@"温馨提示" message:@"是否拨客服电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
//                                
//                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",helper.configModel.plat_kfmobile];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//                    
//                } withCancel:^(UIAlertAction *cancelaction) {
//                    
//                }];
//            }
//        }else{
//            LoginController *loginController = [[LoginController alloc] init];
//            [self.navigationController pushViewController:loginController animated:YES];
//
//        }
//
//       
//    }
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.nameArray[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCenterCell" forIndexPath:indexPath];
    NSArray *nameArr = self.nameArray[indexPath.section];
    NSArray *imagesArr = self.cellImages[indexPath.section];
    UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@",  imagesArr[indexPath.row]]];
    CGSize itemSize = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = nameArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%lu", (unsigned long)self.nameArray.count);
    return self.nameArray.count;
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.userModel.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    
    
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://0599114"]];
    }
}

- (void)webAction{
    DWHelper *helper = [DWHelper shareHelper];
    WebLoginController *webLogin = [[WebLoginController alloc] init];
    webLogin.registUrl = helper.configModel.referralUrl;
    [webLogin setUrl:helper.configModel.referralUrl];
    [self.navigationController pushViewController:webLogin animated:YES];
}




- (void)UMShareAction:(id)sender {
    
//    NSString *appName = @"BianMin";
//    NSString *urlScheme = @"";
//    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,111.11213, 165.0575] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",12456.04, 11324.1,15646.41,1135465.4] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
//    
//    //
//    
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
//    [[DWHelper shareHelper] UMShare:self];
    
    
}


 #pragma mark -  //获取系统配置信息
- (void)getConfig {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @[];
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestConfig" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode ==1) {
            RequestConfigModel *model = [RequestConfigModel yy_modelWithJSON:baseRes.data];
            DWHelper *helper = [DWHelper shareHelper];
            helper.configModel = model;
        }else{
            [weakSelf showToast:baseRes.msg];
        }
    } faild:^(id error) {
        
    }];
}

@end
