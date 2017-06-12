//
//  DWHomePageViewController.m
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWHomePageViewController.h"
#import "Masonry.h"
#import "NJCycleScrollView.h"
#import "DWMainPageTableViewCell.h"
#import "SDCycleScrollView.h"
#import "DWSearchBarView.h"
#import "SearchViewController.h"
#import "Reachability.h"
#import "DWHelper.h"
#import "AdressSelectedController.h"
#import "ShopViewController.h"
#import "HomeAdModel.h"
#import "HomeShopModel.h"
#import "ThreeAdView.h"
#import "DWWebViewController.h"
#import "DWClassPageViewController.h"
#import "GoingOutViewController.h"
#import "MerchantCategoryModel.h"
#import "GovNewsViewController.h"
#import "RequestHomePageAdList.h"
#import "RequestHomePageModel.h"
#import "RequestActiveList.h"
#import "RequestActiveListModel.h"
#import "ActiveViewController.h"
#import "RequestMyTripList.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "RequestRecommendMerchantList.h"
#import "RequestMerchantListModel.h"
#import "RequestVersionUpdate.h"
#import "RequestVersionUpdateModel.h"
#import "PushMessageController.h"
#import "RequestMenuList.h"
#import "RequestCateAndBusinessareaModel.h"
#import "GoOutViewController.h"
#import "BMShopContentController.h"
#import "DropDownListView.h"
#import "TripListController.h"
#import "PublicMessageVC.h"
#import "VerisonModel.h"
#import "SearchHistoryViewController.h"
#import "GoodsListOneCell.h"
#define BoundsWidth [UIScreen mainScreen].bounds.size.width
#define CategoryWidth ([UIScreen mainScreen].bounds.size.width - 3) / 4
#define IOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsIOS7Later !(IOSVersion < 7.0)


@interface DWHomePageViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate,SearchBarViewDelegate,ThreeAdViewDelegate, CLLocationManagerDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NJCycleScrollView *bannerView;
@property (nonatomic, strong)UIPageControl *bannerPageControl;
@property (nonatomic, strong)NSMutableArray *activeImageArray;
//存储分类名称
@property (nonatomic, strong)NSArray *classNameArr;
//存储分类图标
@property (nonatomic, strong)NSArray *classPictureArr;
//判断网络状态
@property (nonatomic, strong)Reachability *conn;
//推荐商家数组
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic ,strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) DWSearchBarView *searchView;
//轮播图片
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, assign) NSInteger pageIndex;
//活动视图
@property (nonatomic, strong) ThreeAdView *threeAdView;
//头视图
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *activeArr;
@property (nonatomic, strong) SDCycleScrollView *cycleScorllView;
@property (nonatomic, strong) NSMutableArray *classKindArr;
//推荐商家类型
@property (nonatomic, copy) NSString *merchantType;//1-团购 2-便民
@end

@implementation DWHomePageViewController

#pragma mark LifeCycle
- (NSMutableArray *)activeArr {
    if (!_activeArr) {
        self.activeArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _activeArr;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublicMessageVC) name:@"跳转到消息中心" object:nil];
    //定位
    [self locationAction];
    //取出是否是在wifi下加载图片
    DWHelper *helper = [DWHelper  shareHelper];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *isNetWorkImage = [userDefault objectForKey:@"isNetWorkImage"];
    if ([isNetWorkImage boolValue]) {
        helper.isWifiOn = YES;
    }else {
        helper.isWifiOn = NO;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    self.pageIndex = 1;
    self.merchantType = @"1";
    [self setupTableView];
    [self setupNavigationItem];
    [self netWorking];
    //获取地址
//    [self getAdressNetWork];
    //获取配置信息
    [self getConfig];
    
}



#pragma mark - init_UI

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DWMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageCell" forIndexPath:indexPath];
//    RequestMerchantListModel *model = self.dataSource[indexPath.row];
//    [cell cellGetDataModel:model WithController:self];
//    return cell;
    GoodsListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListOneCell" forIndexPath:indexPath];
        RequestMerchantListModel *model = self.dataSource[indexPath.row];
    cell.model = model;
        return cell;

    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RequestMerchantListModel *model = self.dataSource[indexPath.row];
    if (model.merchantType == 2) {
        BMShopContentController *bmContentC = [[BMShopContentController alloc] init];
        bmContentC.merchantId = model.merchantId;
        [self.navigationController pushViewController:bmContentC animated:YES];
    }else {
        ShopViewController *shopController = [[ShopViewController alloc]init];
        [shopController setDataSource:[self.dataSource objectAtIndex:indexPath.row]];
        shopController.merchantId = model.merchantId;
        [self.navigationController pushViewController:shopController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Bounds.size.width, 70)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.text = @"推荐商家";
    sectionLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    sectionLabel.font = [UIFont systemFontOfSize:15];
    [sectionView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).with.offset(10);
        make.top.equalTo(sectionView);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [sectionView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sectionView).with.offset(1);
        make.left.right.equalTo(sectionView);
        make.height.mas_equalTo(@(1));
    }];
    
    NSInteger itemW = Width/2;
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1500+i;
        [btn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateHighlighted];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(i*itemW, 30, itemW, 40);
        [sectionView addSubview:btn];
        
        UIView *itemLine = [UIView new];
        [sectionView addSubview:itemLine];
        itemLine.tag = 1600+i;
        [itemLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(sectionView);
            make.centerX.equalTo(btn);
            make.size.mas_equalTo(CGSizeMake(itemW-40, 2));
        }];
        
        if ([self.merchantType integerValue] == 1) {
            if (i == 0) {
                [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
                itemLine.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
                [btn setTitle:@"团购" forState:UIControlStateNormal];
            }else {
                [btn setTitleColor:[UIColor colorWithHexString:kSubTitleColor] forState:UIControlStateNormal];
                itemLine.backgroundColor = [UIColor whiteColor];
                [btn setTitle:@"便民" forState:UIControlStateNormal];
            }
        }else {
            if (i == 0) {
                [btn setTitleColor:[UIColor colorWithHexString:kSubTitleColor] forState:UIControlStateNormal];
                itemLine.backgroundColor = [UIColor whiteColor];
                [btn setTitle:@"团购" forState:UIControlStateNormal];
            }else {
                [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
                itemLine.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
                [btn setTitle:@"便民" forState:UIControlStateNormal];
            }
        }
        
        
    }
    UIView *secondLine = [UIView new];
    secondLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [sectionView addSubview:secondLine];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView);
        make.top.equalTo(sectionView).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    return sectionView;
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{       RequestHomePageModel *model = self.imagesArr[index];
    if (model.type == 1) {
        ShopViewController *shopController = [[ShopViewController alloc] init];
        [shopController setDataSource:model];
        shopController.merchantId = model.merchantId;
        [self.navigationController pushViewController:shopController animated:YES];
    }else {
        DWWebViewController *webView = [[DWWebViewController alloc] init];
        [webView setUrl:model.linkUrl];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark PrivateFun
- (void)itemAction:(UIButton *)sender {
    NSInteger tag = sender.tag;
    self.pageIndex = 1;
    [sender setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    if (tag == 1500) {
        self.merchantType = @"1";
        UIButton *btn = [self.tableView viewWithTag:1501];
        [btn setTitleColor:[UIColor colorWithHexString:kSubTitleColor] forState:UIControlStateNormal];
        UIView *firstLine = [self.tableView viewWithTag:1600];
        UIView *secondLine = [self.tableView viewWithTag:1601];
        firstLine.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        secondLine.backgroundColor = [UIColor whiteColor];
    }else {
        self.merchantType = @"2";
        UIButton *btn = [self.tableView viewWithTag:1500];
        [btn setTitleColor:[UIColor colorWithHexString:kSubTitleColor] forState:UIControlStateNormal];
        UIView *firstLine = [self.tableView viewWithTag:1601];
        UIView *secondLine = [self.tableView viewWithTag:1600];
        firstLine.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        secondLine.backgroundColor = [UIColor whiteColor];
    }
    [self getShopDataWithType:self.merchantType];
}

- (void)didSelect:(RequestActiveListModel *)model {
    ActiveViewController *activeC = [[ActiveViewController alloc] init];
    activeC.model = model;
    [self.navigationController pushViewController:activeC animated:YES];
}

#pragma mark - 定位服务
- (void)locationAction {
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        //位置服务是在设置中禁用
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"你的定位功能是禁用的请在设置中打开" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           // [self VersionUpdate];
            //[self updateVerison];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }else {
        // [self updateVerison];
       // [self VersionUpdate];
    }
    
//    //判断是是7.0 之后还是8.0之后
//    if (!(IOSVersion < 8.0)) {
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
//        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//            [self.locationManager requestAlwaysAuthorization];
//        }
//        [self.locationManager startUpdatingLocation];
//    }else {
//        if ([CLLocationManager locationServicesEnabled]) {
//            [self.locationManager startUpdatingLocation];
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//        }else {
//            OKLog(@"不支持定位");
//        }
//    }
//    

    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
   	//带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        //定位信息
        DWHelper *dwHelper = [DWHelper shareHelper];
        dwHelper.coordinate = location.coordinate;
        double latitude = location.coordinate.latitude;
        double longitude = location.coordinate.longitude;
        [DWCacheManager setPulicCache:[NSNumber numberWithDouble:latitude] :@"latitude"];
        [DWCacheManager setPulicCache:[NSNumber numberWithDouble:longitude] :@"longitude"];
        
        OKLog(@"定位经纬度");
        //逆地理信息
        
        if (regeocode)
        {
            DWHelper *helper = [DWHelper shareHelper];
            helper.adressData = regeocode;
            [DWCacheManager setPulicCache:[regeocode yy_modelToJSONString] :@"adressData"];
        }
    }];
}

#pragma mark - 判断网络状态
- (void)netWorking {
    //    获取当前网络状态
    DWHelper *helper = [DWHelper shareHelper];
    helper.netWorking = [DWHelper networkingStatesFromStatebar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}
- (void)reachabilityChanged:(NSNotification *)sender {
    //     1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        DWHelper *helper = [DWHelper shareHelper];
        helper.netWorking = @"wifi";
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        DWHelper *helper = [DWHelper shareHelper];
        helper.netWorking = @"4G";
    } else { // 没有网络
        NSLog(@"没有网络");
        DWHelper *helper = [DWHelper shareHelper];
        helper.netWorking = @"NO";
    }
}

- (void)setupNavigationItem {
    int width = self.navigationController.navigationBar.frame.size.width;
    self.searchView = [[DWSearchBarView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    self.searchView.backgroundColor = [UIColor clearColor];
    self.searchView.delegate = self;
    self.navigationItem.titleView = self.searchView;
    NSString *regionName = [AuthenticationModel getRegionName];
    if (regionName == nil || regionName == NULL) {
        AdressSelectedController *adressSelected = [[AdressSelectedController alloc] init];
        __weak DWHomePageViewController *weakSelf = self;
        adressSelected.selectdeAdress = ^(NSString *adressStr) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"切换地址" object:@"切换地址" userInfo:@{}];
            weakSelf.pageIndex = 1;
            [weakSelf.searchView.adressBtn setTitle:adressStr forState:UIControlStateNormal];
             [weakSelf.classKindArr removeAllObjects];
            [weakSelf againAchiveData];
            [weakSelf.dataSource removeAllObjects];
            [weakSelf getShopDataWithType:self.merchantType];
        };
        [self.navigationController pushViewController:adressSelected animated:YES];
    }else {
         [self.searchView.adressBtn setTitle:regionName forState:UIControlStateNormal];
    };
   
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"icon_home_xinxi"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.frame = CGRectMake(0, 0, 40  , 40);
    //    messageBtn.backgroundColor = [UIColor redColor];
    [messageBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 5, 0)];
    messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
}
#pragma mark - SearchBarViewDelegate
- (void)searchBarSearchButtonClicked:(DWSearchBarView *)searchBarView {
//    SearchViewController *searchController = [[SearchViewController alloc] init];
//    [self.navigationController pushViewController:searchController animated:YES];
    
    //Push 跳转
    SearchHistoryViewController * VC = [[SearchHistoryViewController alloc]initWithNibName:@"SearchHistoryViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

    
    
    
}
- (void)adressSelected:(id)sender {
    AdressSelectedController *adressSelected = [[AdressSelectedController alloc] init];
    __weak DWHomePageViewController *weakSelf = self;
    adressSelected.selectdeAdress = ^(NSString *adressStr) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"切换地址" object:@"切换地址" userInfo:@{}];
        weakSelf.pageIndex = 1;
        [weakSelf.classKindArr removeAllObjects];
        [weakSelf.searchView.adressBtn setTitle:adressStr forState:UIControlStateNormal];
        [weakSelf againAchiveData];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf getShopDataWithType:self.merchantType];
    };
    [self.navigationController pushViewController:adressSelected animated:YES];
}

- (void)messageAction:(UIButton *)sender {
    if ([self isLogin]) {
        
        //Push 跳转
        PublicMessageVC * VC = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];

        
//        PushMessageController *messageC = [[PushMessageController alloc] init];
//        [self.navigationController pushViewController:messageC animated:YES];
    }else {
        LoginController *loginC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginC animated:YES];
//        LoginController *loginController = [[LoginController alloc] init];
//        DWNavigationController * Nav = [[DWNavigationController alloc]initWithRootViewController:loginController];
//        
//        CATransition *  ansition =[CATransition animation];
//        [ansition setDuration:0.3];
//        [ansition setType:kCAGravityRight];
//        [[[[UIApplication sharedApplication]keyWindow ]layer] addAnimation:ansition forKey:nil];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:Nav animated:YES completion:nil];
    }
}

#pragma mark - createTableView
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.rowHeight = Width *0.19;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[DWMainPageTableViewCell class] forCellReuseIdentifier:@"HomePageCell"];
    
    [self.tableView tableViewregisterNibArray:@[@"GoodsListOneCell"]];
    
    //获取推荐商家数据
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self showProgress];
        self.pageIndex = 1;
        [self.classKindArr removeAllObjects];
        [self againAchiveData];
        [self getShopDataWithType:self.merchantType];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self showProgress];
        self.pageIndex = self.pageIndex + 1;
        [self getShopDataWithType:self.merchantType];
    }];
//    self.dataSource = [FakeData getHomePageShopData];
    
    if ([AuthenticationModel getRegionID] == nil) {
        
    }else {
        [self getShopDataWithType:self.merchantType];
        [self getActiveData:nil];
    }
    
    
}

- (UIView *)headerViewForTableView:(NSMutableArray *)activeArr {
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:249 / 255.0 blue:248 / 255.0 alpha:1.0];
    if (activeArr.count == 0) {
        if (self.classKindArr.count < 3) {
            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, Width*2/5 + Width * 0.5+10 - CategoryWidth);
        }else {
           self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, Width*2/5 + Width * 0.5+10);
        }
    }else {
        if (self.classKindArr.count < 3) {
            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 132 + Width*2/5 + Width * 0.5+10 - CategoryWidth);
        }else {
            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 132 + Width*2/5 + Width * 0.5+10);
        }
    }

    self.cycleScorllView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Bounds.size.width, Bounds.size.width * 2 /5) delegate:self placeholderImage:[UIImage imageNamed:@"bg_zaijia_5-2"]];
    self.cycleScorllView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleScorllView.currentPageDotColor = [UIColor whiteColor];
    
    
    [self.headerView addSubview:self.cycleScorllView];
    [self getPageAdList:self.cycleScorllView];
    [self createClassView:self.headerView scrollView:self.cycleScorllView];
    [self createActivity:self.headerView with:self.activeArr];
    return self.headerView;
}

//创建分类
- (void)createClassView:(UIView *)sender scrollView:(SDCycleScrollView *)scrollView{
    NSInteger classCount = self.classKindArr.count;
    if (classCount < 3) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), Width, CategoryWidth)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.headerView addSubview:bgView];
        
        int count = 0;
        for (int i = 0; i < 2 + classCount; i ++) {
            UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(i * (CategoryWidth + 1), CGRectGetMaxY(scrollView.frame) , CategoryWidth, CategoryWidth)];
            classView.backgroundColor = [UIColor whiteColor];
            UIImageView *classImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.classPictureArr objectAtIndex:count]]];
            classImage.layer.masksToBounds = YES;
            classImage.layer.cornerRadius = 10;
            classImage.userInteractionEnabled = YES;
            [classView addSubview:classImage];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesClass:)];
            [classImage addGestureRecognizer:tap];
            UILabel *className = [UILabel new];
            className.textColor = [UIColor colorWithHexString:kTitleColor];
            className.font = [UIFont systemFontOfSize:13];
            
            className.textAlignment = NSTextAlignmentCenter;
            [classView addSubview:className];
            [classImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(classView.mas_centerX);
                make.top.equalTo(classView.mas_top).with.offset(18);
                make.left.equalTo(classView.mas_left).with.offset(23);
                make.right.equalTo(classView.mas_right).with.offset(-23);
                make.bottom.equalTo(className.mas_top).with.offset(-8);
            }];
            [className mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(classView.mas_centerX);
                make.left.equalTo(classView.mas_left).with.offset(10);
                make.right.equalTo(classView.mas_right).with.offset(-10);
                make.top.equalTo(classImage.mas_bottom).with.offset(8);
                make.bottom.equalTo(classView.mas_bottom);
                make.height.mas_equalTo(@(20));
            }];
            
            if (i == 0 || i == 1) {
                className.text = self.classNameArr[i];
                classImage.image = [UIImage imageNamed:self.classPictureArr[i]];
                classImage.tag = 100+i;
            }else {
                RequestCateAndBusinessareaModel *model = self.classKindArr[count];
                [self loadImageWithView:classImage urlStr:model.icon];
                classImage.tag = 10000 + count;
                
                className.text = model.categoryName;
                count ++;
            }
            [sender addSubview:classView];
        }
    }else if (classCount > 2 && classCount < 7) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), Width, CategoryWidth*2)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.headerView addSubview:bgView];
        
        
        int count = 0;
        for (int i = 0; i < 2; i++) {
            NSInteger index = 0;
            if (i == 0) {
                index = 4;
            }else {
                index = classCount - 2;
            }
            for (int j = 0; j < index; j++) {
                RequestCateAndBusinessareaModel *model = self.classKindArr[count];
                UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(j * (CategoryWidth + 1), CGRectGetMaxY(scrollView.frame) + i * (CategoryWidth + 1), CategoryWidth, CategoryWidth)];
                classView.backgroundColor = [UIColor whiteColor];
                UIImageView *classImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.classPictureArr objectAtIndex:count]]];
                classImage.layer.masksToBounds = YES;
                classImage.layer.cornerRadius = 10;
                classImage.userInteractionEnabled = YES;
                classImage.tag = 10000 + count;
                [classView addSubview:classImage];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesClass:)];
                [classImage addGestureRecognizer:tap];
                UILabel *className = [UILabel new];
                className.textColor = [UIColor colorWithHexString:kTitleColor];
                className.font = [UIFont systemFontOfSize:13];
                className.text = model.categoryName;
                className.textAlignment = NSTextAlignmentCenter;
                [classView addSubview:className];
                [classImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(classView.mas_centerX);
                    make.top.equalTo(classView.mas_top).with.offset(18);
                    make.left.equalTo(classView.mas_left).with.offset(23);
                    make.right.equalTo(classView.mas_right).with.offset(-23);
                    make.bottom.equalTo(className.mas_top).with.offset(-8);
                }];
                [className mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(classView.mas_centerX);
                    make.left.equalTo(classView.mas_left).with.offset(10);
                    make.right.equalTo(classView.mas_right).with.offset(-10);
                    make.top.equalTo(classImage.mas_bottom).with.offset(8);
                    make.bottom.equalTo(classView.mas_bottom);
                    make.height.mas_equalTo(@(20));
                }];
                if (i== 0) {
                    if (j==0 || j==1) {
                        className.text = self.classNameArr[j];
                        classImage.image = [UIImage imageNamed:self.classPictureArr[j]];
                        classImage.tag = 100 + j;
                    }else {
                        [self loadImageWithView:classImage urlStr:model.icon];
                        classImage.tag = 10000 + count;
                        count++;
                    }
                }else {
                    [self loadImageWithView:classImage urlStr:model.icon];
                    count++;
                }
                [sender addSubview:classView];
            }
        }
    }else if (classCount > 6) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), Width, CategoryWidth*2)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.headerView addSubview:bgView];
        
        int count = 0;
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 4; j++) {
                RequestCateAndBusinessareaModel *model = self.classKindArr[count];
                UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(j * (CategoryWidth + 1), CGRectGetMaxY(scrollView.frame) + i * (CategoryWidth + 1), CategoryWidth, CategoryWidth)];
                classView.backgroundColor = [UIColor whiteColor];
                UIImageView *classImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.classPictureArr objectAtIndex:count]]];
                classImage.layer.masksToBounds = YES;
                classImage.layer.cornerRadius = 10;
                classImage.userInteractionEnabled = YES;
                classImage.tag = 10000 + count;
                [classView addSubview:classImage];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesClass:)];
                [classImage addGestureRecognizer:tap];
                UILabel *className = [UILabel new];
                className.textColor = [UIColor colorWithHexString:kTitleColor];
                className.font = [UIFont systemFontOfSize:13];
                className.text = model.categoryName;
                className.textAlignment = NSTextAlignmentCenter;
                [classView addSubview:className];
                [classImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(classView.mas_centerX);
                    make.top.equalTo(classView.mas_top).with.offset(18);
                    make.left.equalTo(classView.mas_left).with.offset(23);
                    make.right.equalTo(classView.mas_right).with.offset(-23);
                    make.bottom.equalTo(className.mas_top).with.offset(-8);
                }];
                [className mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(classView.mas_centerX);
                    make.left.equalTo(classView.mas_left).with.offset(10);
                    make.right.equalTo(classView.mas_right).with.offset(-10);
                    make.top.equalTo(classImage.mas_bottom).with.offset(8);
                    make.bottom.equalTo(classView.mas_bottom);
                    make.height.mas_equalTo(@(20));
                }];
                if (i== 0) {
                    if (j==0 || j==1) {
                        className.text = self.classNameArr[j];
                        classImage.image = [UIImage imageNamed:self.classPictureArr[j]];
                        classImage.tag = 100+j;
                    }else {
                        [self loadImageWithView:classImage urlStr:model.icon];
                        classImage.tag = 10000 + count;
                        count++;
                    }
                }else {
                    [self loadImageWithView:classImage urlStr:model.icon];
                    count++;
                }
                [sender addSubview:classView];
            }
        }
    }
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [sender addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sender);
        make.top.equalTo(scrollView.mas_bottom);
        make.height.mas_equalTo(@(5));
    }];
    
}

//创建活动视图
- (void)createActivity:(UIView *)sender with:(NSMutableArray *)activeArr {
    self.threeAdView = [[ThreeAdView alloc] initWithFrame:CGRectMake(0, Width*2/5+Width*0.5, Width, 140)];
    if (self.classKindArr.count < 3) {
        self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.25, Width, 140);
    }else {
         self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.5, Width, 140);
    }
    if (activeArr.count == 0) {
        self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.25, Width, 0);
        self.threeAdView.hidden = YES;
    }else {
        self.threeAdView.hidden = NO;
        self.threeAdView.delegate = self;
        [sender addSubview:self.threeAdView];
        [self.threeAdView setDataSource:activeArr withController:self];
    }
}


- (void)touchesClass:(UITapGestureRecognizer *)sender {
    long count = sender.view.tag;
    if (count == 100 || count == 101) {
      if(count == 100) {
         //   if ([self isLogin]) {
       TripListController *goOutController =      [[TripListController alloc] init];
                
         goOutController.date =[NSString weekdayStringFromDate:[NSDate date]];
                goOutController.dateStr = [NSString timeStringFromDate:[NSDate date]];
                goOutController.startPlace= @"";
                goOutController.endPlace= @"";
                
               
                
        [self.navigationController pushViewController:goOutController animated:YES];
//            }else {
//                LoginController *loginController = [[LoginController alloc] init];
//                [self.navigationController pushViewController:loginController animated:YES];
//            }
        }else if(count == 101) {
            GovNewsViewController *newsController = [[GovNewsViewController alloc] init];
            [self.navigationController pushViewController:newsController animated:YES];
        }
    }else {
        RequestCateAndBusinessareaModel *model = self.classKindArr[count-10000];
        DWClassPageViewController *classController = [[DWClassPageViewController alloc] init];
        classController.isNewController = 6;
        classController.kindClassIndex = count-10000+1;
        classController.model = model;
        [self.navigationController pushViewController:classController animated:YES];
        
    }
    
//    if (count == 5) {
//        if ([self isLogin]) {
//            GoingOutViewController *goOutController = [[GoingOutViewController alloc] init];
//            [self.navigationController pushViewController:goOutController animated:YES];
//        }else {
//            LoginController *loginController = [[LoginController alloc] init];
//            [self.navigationController pushViewController:loginController animated:YES];
//        }
//       
//    }else if (count == 6){
//        GovNewsViewController *newsController = [[GovNewsViewController alloc] init];
//        [self.navigationController pushViewController:newsController animated:YES];
//    }else {
//        DWClassPageViewController *classController = [[DWClassPageViewController alloc] init];
//        classController.isNewController = 6;
//        classController.newCount = count+1;
//        [classController setMerchantCategory:nil];
//        [self.navigationController pushViewController:classController animated:YES];
//    }
//    
}
#pragma mark - init_data
- (void)getAdressNetWork {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = [NSArray array];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Region/requestServiceReigonList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
    } faild:^(id error) {
    }];
}

- (void)getActiveData:(ThreeAdView *)activeView {
    RequestActiveList *activeList = [[RequestActiveList alloc] init];
    activeList.regionId = [AuthenticationModel getRegionID];
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.data = activeList;
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestActiveList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestActiveListModel *model = [RequestActiveListModel yy_modelWithDictionary:dic];
                [self.activeArr addObject:model];
            }
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self getShopKindData];
    } faild:^(id error) {
        
    }];
}

#pragma mark - 获取轮播广告位
- (void)getPageAdList:(SDCycleScrollView *)scrollView {
    RequestHomePageAdList *homePage = [[RequestHomePageAdList alloc] init];
    homePage.position = 2;
    homePage.regionId = [AuthenticationModel getRegionID];
    BaseRequest *baseRequest = [[BaseRequest alloc] init];
    baseRequest.encryptionType = RequestMD5;
    baseRequest.data = homePage;
    [[DWHelper shareHelper] requestDataWithParm:[baseRequest yy_modelToJSONString] act:@"act=Api/Home/requestHomePageAdList" sign:[[baseRequest.data yy_modelToJSONString]MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSMutableArray *urlArr = [NSMutableArray arrayWithCapacity:0];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestHomePageModel *model = [RequestHomePageModel yy_modelWithDictionary:dic];
                [self.imagesArr addObject:model];
                [urlArr addObject:model.originUrl];
            }
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        self.cycleScorllView.localizationImageNamesGroup = urlArr;
    } faild:^(id error) {
    }];
}
//获取推荐商家
- (void)getShopDataWithType:(NSString *)merchantType {
      
    RequestRecommendMerchantList *shopReq = [[RequestRecommendMerchantList alloc] init];
    shopReq.merchantType = merchantType;
    shopReq.pageIndex = self.pageIndex;
    shopReq.pageCount = 10;
    shopReq.regionId = [AuthenticationModel getRegionID];
    shopReq.lat = [AuthenticationModel getlatitude];
    shopReq.lng = [AuthenticationModel getlongitude];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = shopReq;
    [self showProgress];

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestRecommendMerchantList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantListModel *model = [RequestMerchantListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
        }
        [self hideProgress];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideProgress];
    }];
}

#pragma mark - 刷新区头上的数据
//- (void)viewDidLayoutSubviews {
//    
//    [self againAchiveData];
//}
- (void)againAchiveData {
    RequestActiveList *activeList = [[RequestActiveList alloc] init];
    activeList.regionId = [AuthenticationModel getRegionID];
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.data = activeList;
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestActiveList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self.activeArr removeAllObjects];
            for (NSDictionary *dic in baseRes.data) {
                RequestActiveListModel *model = [RequestActiveListModel yy_modelWithDictionary:dic];
                [self.activeArr addObject:model];
            }
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self getShopKindData];
        [self.tableView reloadData];
    } faild:^(id error) {
        [self hideProgress];
    }];
    
}

//- (void)againView {
//    self.headerView.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:249 / 255.0 blue:248 / 255.0 alpha:1.0];
//    if (self.activeArr.count == 0) {
//        if (self.classKindArr.count < 2) {
//            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, Width*2/5 + Width * 0.5+10 - CategoryWidth);
//            self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.25, Width, 0);
//        }else {
//            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, Width*2/5 + Width * 0.5+10);
//            self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.5, Width, 0);
//        }
//    }else {
//        self.threeAdView.hidden = NO;
//        self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.25, Width, 140);
//        if (self.classKindArr.count < 2) {
//            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 132 + Width*2/5 + Width * 0.5+10 - CategoryWidth);
//            self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.25, Width, 0);
//        }else {
//            self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 132 + Width*2/5 + Width * 0.5+10);
//            self.threeAdView.frame = CGRectMake(0, Width*2/5+Width*0.5, Width, 0);
//        }
//    }
//    for (UIView *view in self.threeAdView.subviews) {
//        [view removeFromSuperview];
//    }
//   
//    
//    [self.cycleScorllView removeFromSuperview];
//    self.cycleScorllView = nil;
//    
//    self.cycleScorllView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Bounds.size.width, Bounds.size.width * 2 /5) delegate:self placeholderImage:[UIImage imageNamed:@"bg_zaijia_5-2"]];
//    self.cycleScorllView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//    self.cycleScorllView.currentPageDotColor = [UIColor whiteColor];
//    
//    [self.headerView addSubview:self.cycleScorllView];
//    [self getPageAdList:self.cycleScorllView];
//    
//    [self.headerView addSubview:self.threeAdView];
//    [self.threeAdView setDataSource:self.activeArr withController:self];
//    self.tableView.tableHeaderView = self.headerView;
//}

- (void)getShopKindData {
    RequestMenuList *list = [[RequestMenuList alloc] init];
    list.regionId = [AuthenticationModel getRegionID];
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = list;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestMenuList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"----%@",response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestCateAndBusinessareaModel *model = [RequestCateAndBusinessareaModel yy_modelWithDictionary:dic];
                [self.classKindArr addObject:model];
            }
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        self.tableView.tableHeaderView = [self headerViewForTableView:self.activeArr];
    } faild:^(id error) {
        [self hideProgress];
    }];
}
//获取系统配置信息
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
//检测版本
- (void)VersionUpdate {
    RequestVersionUpdate *update = [[RequestVersionUpdate alloc] init];
    update.os = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = update;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestVersionUpdate" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestVersionUpdateModel *model = [RequestVersionUpdateModel yy_modelWithJSON:baseRes.data];
            //            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *appStoreVersion = model.lastVersion;
            NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
            //设置版本号，主要是为了区分不同的版本，比如有1.2.1、1.2、1.31各种类型
            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (currentVersion.length==2) {
                currentVersion  = [currentVersion stringByAppendingString:@"0"];
            }else if (currentVersion.length==1){
                currentVersion  = [currentVersion stringByAppendingString:@"00"];
            }
            appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            if (appStoreVersion.length==2) {
                appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
            }else if (appStoreVersion.length==1){
                appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
            }
            
            //4当前版本号小于商店版本号,就更新
            if([currentVersion floatValue] < [appStoreVersion floatValue])
            {
                UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:@"版本有更新" message:@"检测到新版本,是否前往更新?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //此处加入应用在app store的地址，方便用户去更新，一种实现方式如下
                    NSURL *url = [NSURL URLWithString:model.downloadUrl];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alercConteoller addAction:actionYes];
                [alercConteoller addAction:actionNo];
                [self presentViewController:alercConteoller animated:YES completion:nil];
            }else{
                NSLog(@"版本号好像比商店大噢!检测到不需要更新");
            }
        }
    } faild:^(id error) {
        
    }];
}


- (NSMutableArray *)classKindArr {
    if (!_classKindArr) {
        self.classKindArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _classKindArr;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化管理器
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}


- (NSMutableArray *)activeImageArray {
    if (!_activeImageArray) {
        self.activeImageArray = [NSMutableArray arrayWithObjects:@"bg_home_banner1",@"bg_home_banner2",@"bg_home_banner3",nil];
    }
    return _activeImageArray;
}

- (NSArray *)classNameArr {
    if (!_classNameArr) {
        self.classNameArr = [NSArray arrayWithObjects:@"出行",@"政务",@"娱乐",@"酒店",@"出行",@"政务",@"其他", nil];
    }
    return _classNameArr;
}
- (NSArray *)classPictureArr {
    if (!_classPictureArr) {
        self.classPictureArr = [NSArray arrayWithObjects:@"出行-1",@"政务-1",@"icon_home_yule",@"icon_home_jiudian",@"icon_home_chuxing",@"icon_home_zhengwu",@"icon_my_qita", nil];
    }
    return _classPictureArr;
}
- (NSMutableArray *)imagesArr {
    if (!_imagesArr) {
        self.imagesArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesArr;
}





#pragma mark - 推送跳转到消息中心
-(void)PublicMessageVC{
    
    if ([self isLogin]) {
        
   
    // 否则，跳转到我的消息
    PublicMessageVC *message = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
    UIViewController * viewControllerNow = [self currentViewController];
    if ([viewControllerNow  isKindOfClass:[PublicMessageVC class]]) {   //如果是页面XXX，则执行下面语句
        [message getDataList];
    }else{
        
        //        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:message];
        //
        //        CATransition *  ansition =[CATransition animation];
        //        [ansition setDuration:0.3];
        //        [ansition setType:kCAGravityRight];
        //        [[[[UIApplication sharedApplication]keyWindow ]layer] addAnimation:ansition forKey:nil];
        //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:Nav animated:YES completion:nil];
        [viewControllerNow.navigationController pushViewController:message animated:YES];
    }
    
    }else{
        
        LoginController *loginC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginC animated:YES];
    }
    
}

-(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

-(UIViewController*) currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}





#pragma mark - 版本更新
-(void)updateVerison{
    //获得build号：
    NSString *buildStr =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    
    int build= [buildStr intValue];
    NSLog(@"build=====%d",build);
    //代码实现获得应用的Verison号：
    NSString *oldVerison =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    int oldOne=  [[oldVerison substringWithRange:NSMakeRange(0,1)]intValue];
    int oldTwo = [[oldVerison substringWithRange:NSMakeRange(2,1)]intValue];
    int oldThree = [[oldVerison  substringWithRange:NSMakeRange(4,1)]intValue];
    
    //NSLog(@"oldOne----%d\noldTwo----%d\noldThree----%d",oldOne ,oldTwo,oldThree);
    VerisonModel *model = [[VerisonModel alloc]init];
    model.os = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
//    if ([self isLogin]) {
//        baseReq.token = [AuthenticationModel getLoginToken];
//    }
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data  = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Version/requestLastVersion" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET  success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
         NSLog(@"检测----%@",response);
        if (baseRes.resultCode == 1) {
            NSDictionary * dic = response[@"data"];
            VerisonModel *model = [VerisonModel yy_modelWithJSON:dic];
            int newOne=  [[model.versionName substringWithRange:NSMakeRange(0,1)]intValue];
            int newTwo = [[model.versionName  substringWithRange:NSMakeRange(2,1)]intValue];
            int newThree = [[model.versionName  substringWithRange:NSMakeRange(4,1)]intValue];
            NSString *newbuildStr;
            if (model.versionName.length>6) {
                newbuildStr =[model.versionName substringFromIndex:6];
                
            }
            int newbuild = [newbuildStr intValue];
            NSLog(@"NewOne----%d\nNewTwo----%d\nNewThree----%d\nnewbuild----%d ",newOne ,newTwo,newThree,newbuild);
            if ([model.isMustUpdate isEqualToString:@"1"]) {
                if (oldOne<newOne) {
                    //强制跟新
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }
                else if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree&&build < newbuild){
                    [weakself addMandatoryAlertAction:model];
                    return;
                }
                else{
                    NSLog(@"休息休息");
                }
                
            }else{
                
                if (oldOne<newOne) {
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addAlertAction:model];
                    return ;
                }
                else
                    if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree && build < newbuild){
                        [weakself addAlertAction:model];
                        return;
                    }
                    else
                    {
                        NSLog(@"不用强制更新");
                        
                    }
                
            }
        }else{
            [weakself showToast:response[@"msg"]];
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - 强制更新
-(void)addMandatoryAlertAction:(VerisonModel*)model{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //Push 跳转
        //        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
        //        VC.url = model.url;
        // NSLog(@"我要去升级--%@",VC.url);
        // [weakSelf presentViewController:VC animated:YES completion:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadUrl]];
        [weakSelf addMandatoryAlertAction:model];
    }];
    [alertC addAction:OK];
    [self presentViewController:alertC animated:NO completion:nil];
}
#pragma mark - 不强制更新
-(void)addAlertAction:(VerisonModel*)model{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //Push 跳转
        //        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
        //        VC.url = model.url;
        //        // NSLog(@"我要去升级--%@",VC.url);
        //        [weakSelf presentViewController:VC animated:YES completion:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadUrl]];
        
    }];
    [alertC addAction:cancel];
    [alertC addAction:OK];
    [self presentViewController:alertC animated:YES completion:nil];
}



@end
