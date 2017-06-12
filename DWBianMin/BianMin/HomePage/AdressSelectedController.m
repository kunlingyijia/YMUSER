//
//  AdressSelectedController.m
//  BianMin
//
//  Created by kkk on 16/4/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AdressSelectedController.h"
#import "AFNetworking.h"
#import "DWHelper.h"
#import "BATableView.h"
#import "RegionModel.h"

@interface AdressSelectedController ()<UITableViewDelegate, UITableViewDataSource,BATableViewDelegate,UISearchBarDelegate,AMapLocationManagerDelegate>
//数据存储请求的数据
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) BATableView *tableView;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *keyArray;
@property (nonatomic, strong) NSMutableDictionary *addressContainer;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) NSMutableArray *adressArray;
@property (nonatomic, strong) NSMutableArray *hotCityArray;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) NSMutableArray *searchData;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic ,strong) AMapLocationManager *locationManager;
@end

@implementation AdressSelectedController
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化管理器
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}
- (NSMutableArray *)searchData {
    if (!_searchData) {
        self.searchData = [NSMutableArray arrayWithCapacity:0];
    }
    return _searchData;
}
- (NSMutableArray *)searchArr {
    if (!_searchArr) {
        self.searchArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _searchArr;
}
- (NSMutableArray *)adressArray {
    if (!_adressArray) {
        self.adressArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _adressArray;
}

- (NSMutableArray *)hotCityArray {
    if (!_hotCityArray) {
        self.hotCityArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotCityArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     [self getAdressData];
    self.title = @"选择城市";
    [self selfShowBackBtn];
    [self createTableView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self locationAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.tableView. mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself locationAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.tableView. mj_header endRefreshing];
        
    }];

}

- (void)selfShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(selfDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)selfDoBack:(id)sender{
    NSString *regionName = [AuthenticationModel getRegionName];
    if (regionName == nil || regionName == NULL) {
        
        
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"还未选择地址,请选择" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    };

   
}

- (void)getAdressData {
     self.addressContainer = [NSMutableDictionary dictionary];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = [NSArray array];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Region/requestServiceReigonList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseRequest *baseReq = [BaseRequest yy_modelWithJSON:response];
        for (NSDictionary *dic in baseReq.data) {
            RegionModel *model = [RegionModel yy_modelWithDictionary:dic];
            [self.adressArray addObject:model];
            if ([model.isHot isEqualToString:@"1"]) {
                [self.hotCityArray addObject:model];
            }
        }
        UIView *headView = [[UIView alloc] init];
        if (self.hotCityArray.count > 3) {
            headView.frame = CGRectMake(0, 0, Width, 210);
        }else if(self.hotCityArray.count == 0){
            headView.frame = CGRectMake(0, 0, Width, 130);
        }else if(self.hotCityArray.count < 4) {
             headView.frame = CGRectMake(0, 0, Width, 170);
        }
        headView.backgroundColor = [UIColor colorWithHexString:kViewBg];
        self.tableView.tableView.tableHeaderView = headView;
        
//        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
//        searchView.backgroundColor = [UIColor colorWithHexString:@"#CCCDD2"];
//        [headView addSubview:searchView];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"输入城市名字" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithHexString:kSubTitleColor]forState:UIControlStateNormal];
//        btn.frame = CGRectMake(10, 5, Width - 20, 30);
//        [btn setBackgroundColor:[UIColor whiteColor]];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 4;
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
        searchBar.delegate = self;
        
        
        [headView addSubview:searchBar];
        
        UILabel *locationBgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, Width, 20)];
        locationBgView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        locationBgView.text = @"   定位城市";
        locationBgView.font = [UIFont systemFontOfSize:14];
        [headView addSubview:locationBgView];
        
        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 0, 30)];
        
        self.currentLabel.textAlignment = NSTextAlignmentCenter;
        //self.currentLabel.backgroundColor = [UIColor colorWithHexString:@"#DFE0E1"];
        self.currentLabel.backgroundColor = [UIColor clearColor];
        DWHelper *helper = [DWHelper shareHelper];
        NSLog(@"%@", helper.adressData.city);
        if (helper.adressData.city == nil || [helper.adressData.city isEqualToString:@"(null)"]) {
            self.currentLabel.text = @"定位失败,点击重新定位";
        }else {
            self.currentLabel.text = [NSString stringWithFormat:@" %@ %@", helper.adressData.city, helper.adressData.district];
        }
        CGFloat currentW = [self.currentLabel.text getSingleLineTextWidthWithFont:[UIFont systemFontOfSize:14] withMaxWith:Width];
        self.currentLabel.frame = CGRectMake(20, 64, currentW+10, 30);
        self.currentLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        self.currentLabel.font = [UIFont systemFontOfSize:14];
        [headView addSubview:self.currentLabel];
        
        UITapGestureRecognizer *currentLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getLocation)];
        self.currentLabel.userInteractionEnabled = YES;
        [self.currentLabel addGestureRecognizer:currentLabelTap];
        
        
        
        
        UILabel *hotCityBgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, Width, 20)];
        hotCityBgView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        hotCityBgView.text = @"   热门城市";
        hotCityBgView.font = [UIFont systemFontOfSize:14];
        [headView addSubview:hotCityBgView];
        
//        NSArray *data = [NSArray arrayWithObjects:@"浦城", @"邵武", @"建瓯",@"建阳",@"德化",@"延平区",  nil];
        NSLog(@"%lu", (unsigned long)self.hotCityArray.count);
        if (self.hotCityArray.count > 3) {
            NSInteger count = 0;
            for ( int i = 0; i < 2; i++) {
                for (int j = 0; j < 3; j++) {
                    if (count == self.hotCityArray.count) {
                        break;
                    }
                    RegionModel *model = self.hotCityArray[count];
                    float padding = 20;
                    float btnWidth = (Width - padding*4)/3;
                    float btnHeight = 30;
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 100 + count;
                    [btn addTarget:self action:@selector(selectedAdress:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setBackgroundColor:[UIColor colorWithHexString:@"#DFE0E1"]];
                    [btn setTitleColor:[UIColor colorWithHexString:kTitleColor]forState:UIControlStateNormal];
                    [btn setTitle:model.regionName forState:UIControlStateNormal];
                    
                    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    btn.frame = CGRectMake(padding*(j+1)+j*btnWidth, 130 + (10*i)+btnHeight*i, btnWidth, btnHeight);
                    [headView addSubview:btn];
                    count = count + 1;
                }
            }
        }else if (self.hotCityArray.count < 4) {
            for (int j = 0; j < self.hotCityArray.count; j++) {
                RegionModel *model = self.hotCityArray[j];
                float padding = 20;
                float btnWidth = (Width - padding*4)/3;
                float btnHeight = 30;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 100 + j;
                [btn addTarget:self action:@selector(selectedAdress:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundColor:[UIColor colorWithHexString:@"#DFE0E1"]];
                [btn setTitleColor:[UIColor colorWithHexString:kTitleColor]forState:UIControlStateNormal];
                NSLog(@"%@", model.regionName);

                [btn setTitle:model.regionName forState:UIControlStateNormal];
                
                btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                btn.frame = CGRectMake(padding*(j+1)+j*btnWidth, 130 + (10*0)+btnHeight*0, btnWidth, btnHeight);
                [headView addSubview:btn];
            }
        }else {
            NSInteger count = 0;
            for ( int i = 0; i < 2; i++) {
                for (int j = 0; j < self.hotCityArray.count - 3; j++) {
                    RegionModel *model = self.hotCityArray[count];
                    float padding = 20;
                    float btnWidth = (Width - padding*4)/3;
                    float btnHeight = 30;
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 100 + count;
                    [btn addTarget:self action:@selector(selectedAdress:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setBackgroundColor:[UIColor colorWithHexString:@"#DFE0E1"]];
                    [btn setTitleColor:[UIColor colorWithHexString:kTitleColor]forState:UIControlStateNormal];
                    [btn setTitle:model.regionName forState:UIControlStateNormal];
                    NSLog(@"%@", model.regionName);

                    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
                    btn.frame = CGRectMake(padding*(j+1)+j*btnWidth, 130 + (10*i)+btnHeight*i, btnWidth, btnHeight);
                    [headView addSubview:btn];
                    count = count +1;
                }
            }
        }
        [self.addressContainer addEntriesFromDictionary:[self processDataModle:self.adressArray]];
        [self.tableView reloadData];
        
    } faild:^(id error) {
        
    }];
}


- (void)selectedAdress:(UIButton *)sender {
    RegionModel *model = self.hotCityArray[sender.tag - 100];
    DWHelper *helper = [DWHelper shareHelper];
    helper.adressID = model.regionId;
    NSUserDefaults *userDefaul = [NSUserDefaults standardUserDefaults];
    [userDefaul setObject:model.regionId forKey:@"regionId"];
    [userDefaul setObject:model.regionName forKey:@"regionName"];
    self.selectdeAdress(model.regionName);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSArray *)sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    return self.keyArray;
}

#pragma mark UITabelViewDatasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.keyArray objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableView.tableView]) {
        return self.keyArray.count;
    }else if([tableView isEqual:self.tableView]){
        return self.searchArr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if ([tableView isEqual:self.tableView.tableView]) {
        NSString *key = [self.keyArray objectAtIndex:section];
        NSArray *innerArray = [self.addressContainer objectForKey:key];
        return innerArray.count;
    }else if([tableView isEqual:self.tableView]){
        [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.searchArr.count];
        return self.searchArr.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self.tableView.tableView]) {
        static NSString *cellIdentifier = @"ContactPeopleCell";
        NSString *key = [self.keyArray objectAtIndex:indexPath.section];
        NSArray *innerArray = [self.addressContainer objectForKey:key];
        
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Width, 40)];
            textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
            textLabel.tag = 1000;
            textLabel.font = [UIFont systemFontOfSize:12];
            [cell addSubview:textLabel];
        }
        
        RegionModel *modle = [innerArray objectAtIndex:indexPath.row];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1000];
        titleLabel.text = modle.regionName;
        return cell;
    }else if ([tableView isEqual: self.searchTableView] ){
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
       cell. textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        if (self.searchArr.count!=0) {
            cell.textLabel.text = self.searchArr[indexPath.row];
        }
        
        return cell;
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.textLabel.text = @"有没有";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView.tableView]) {
        NSString *key = [self.keyArray objectAtIndex:indexPath.section];
        NSArray *innerArray = [self.addressContainer objectForKey:key];
        RegionModel *modle = [innerArray objectAtIndex:indexPath.row];
        DWHelper *helper = [DWHelper shareHelper];
        helper.adressID = modle.regionId;
        NSUserDefaults *userDefaul = [NSUserDefaults standardUserDefaults];
        [userDefaul setObject:modle.regionId forKey:@"regionId"];
        [userDefaul setObject:modle.regionName forKey:@"regionName"];
        self.selectdeAdress(modle.regionName);
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSString *adress = self.searchArr[indexPath.row];
        RegionModel *adressModel = nil;
        for (RegionModel *model in self.searchData) {
            if ([model.regionName isEqualToString:adress]) {
                adressModel = model;
            }
        }
        DWHelper *helper = [DWHelper shareHelper];
        helper.adressID = adressModel.regionId;
        NSUserDefaults *userDefaul = [NSUserDefaults standardUserDefaults];
        [userDefaul setObject:adressModel.regionId forKey:@"regionId"];
        [userDefaul setObject:adressModel.regionName forKey:@"regionName"];
        self.selectdeAdress(adressModel.regionName);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}


#pragma mark TabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView.tableView]) {
        return 20;
    }
    return 0;
}

- (void)createTableView {

   
//    
//    NSMutableArray *array = [NSMutableArray array];
//    
//    RegionModel *region1 = [[RegionModel alloc] init];
//    region1.regionName = @"浦城";
//    region1.regionId = @"100";
//    region1.regionCode = @"353000";
//    [array addObject:region1];
//    
//    RegionModel *region2 = [[RegionModel alloc] init];
//    region2.regionName = @"建瓯";
//    region2.regionId = @"1010";
//    region2.regionCode = @"353000";
//    [array addObject:region2];
//    
//    
//    RegionModel *region3 = [[RegionModel alloc] init];
//    region3.regionName = @"顺昌";
//    region3.regionId = @"1010";
//    region3.regionCode = @"353000";
//    [array addObject:region3];
//    
//    RegionModel *region4 = [[RegionModel alloc] init];
//    region4.regionName = @"建阳";
//    region4.regionId = @"1010";
//    region4.regionCode = @"353000";
//    [array addObject:region4];
//    
//    RegionModel *region5 = [[RegionModel alloc] init];
//    region5.regionName = @"德化";
//    region5.regionId = @"1010";
//    region5.regionCode = @"353000";
//    [array addObject:region5];
//    
//    
//    RegionModel *region6 = [[RegionModel alloc] init];
//    region6.regionName = @"邵武";
//    region6.regionId = @"1010";
//    region6.regionCode = @"353000";
//    [array addObject:region6];
    

    self.tableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    self.tableView.tableView.backgroundColor =[UIColor colorWithHexString:kViewBg];
    self.tableView.tableView.tableFooterView = nil;
    [self showHeaderView];
    
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+64, Width, Height-40) style:UITableViewStylePlain];
    [self.view addSubview:self.searchTableView];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    [self.searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCell"];
    self.searchTableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.searchTableView.tableFooterView = [UIView new];
    self.searchTableView.hidden = YES;
    
    
}

#pragma  mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   
    if (searchText.length == 0) {
        self.searchTableView.hidden = YES;
    }else {
        self.searchTableView.hidden = NO;
    }
    [self.searchArr removeAllObjects];
    NSMutableArray *adressArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in self.keyArray) {
        NSArray *innerArray = [self.addressContainer objectForKey:key];
        for (RegionModel *model in innerArray) {
            [self.searchData addObject:model];
            [adressArr addObject:model.regionName];
        }
    }
    
    //存储输入的内容
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"self contains%@",searchText];
    //查找和输入内容相似 的存入arr
   // NSLog(@"%ld", adressArr.count);
    
    self.searchArr = [NSMutableArray arrayWithArray:[adressArr filteredArrayUsingPredicate:pre]];
     NSLog(@"%@",self.searchArr);
    [self.searchTableView reloadData];
    //刷新数据
    [self.tableView reloadData];
}

- (void)showHeaderView{

    
}

- (NSDictionary *)processDataModle:(NSArray *)contact{
    NSArray *data = contact;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < data.count ; i++) {
        RegionModel *model = [data objectAtIndex:i];
        NSString *firstLetter = [self firstCharactor:model.regionName];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:model forKey:firstLetter];
        [resultArray addObject:dict];
    }
    
    NSMutableDictionary *charDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *otherDict = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in resultArray) {
        NSString *key = [[dict allKeys] objectAtIndex:0];
        NSInteger assic = [key characterAtIndex:0];
        RegionModel *model = [dict objectForKey:key];
        if (assic >= 65 && assic <= 90) {
            for (NSString *innerKey in charDict.allKeys) {
                if ([innerKey isEqualToString:key]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[charDict objectForKey:innerKey]];
                    [array addObject:model];
                    [charDict setObject:array forKey:key];
                    goto jump;
                }
            }
            [charDict setObject:[NSArray arrayWithObject:model] forKey:key];
        jump:;
            
        }else{
            NSMutableArray *array = [NSMutableArray arrayWithArray:[otherDict objectForKey:@"#"]];
            [array addObject:model];
            [otherDict setObject:array forKey:@"#"];
        }
    }
    
    NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
    [finalDict addEntriesFromDictionary:charDict];
    [finalDict addEntriesFromDictionary:otherDict];
    
    [self setKeyDict:finalDict];
    return finalDict;
}

- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

- (void)setKeyDict:(NSMutableDictionary *)keyDict{
    NSArray *resultArray = [keyDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        
        NSInteger char1 = [obj1 characterAtIndex:0];
        NSInteger char2 = [obj2 characterAtIndex:0];
        if([obj1 isEqualToString:@"#"]){
            char1+=200;
        }
        if([obj2 isEqualToString:@"#"]){
            char2+=200;
        }
        NSNumber *number1 = [NSNumber numberWithInteger:char1];
        NSNumber *number2 = [NSNumber numberWithInteger:char2];
        NSComparisonResult result = [number1 compare:number2];
        return result == NSOrderedDescending; // 升序
    }];
    self.keyArray = [NSMutableArray arrayWithArray:resultArray];
    
}

- (void)getLocation {
    if ([self.currentLabel.text isEqualToString:@"定位失败,点击重新定位"]) {
        [self locationAction];
    }else {
//        DWHelper *helper = [DWHelper shareHelper];
//        self.selectdeAdress(helper.adressData.city);
       // NSLog(@"%@",helper.adressData.city);
       // [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 定位服务
- (void)locationAction {
    [self showProgress];
        if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
            &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
            //位置服务是在设置中禁用
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"你的定位功能是禁用的请在设置中打开" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }]];

            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
            
        }else {
            
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
            [self hideProgress];
            if (error)
            {
                [self showToast:@"定位失败"];
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
                if (helper.adressData.city == nil || [helper.adressData.city isEqualToString:@"(null)"]) {
                    self.currentLabel.text = @"定位失败,点击重新定位";
                }else {
                    self.currentLabel.text = [NSString stringWithFormat:@" %@ %@", regeocode.city, helper.adressData.district];
                }
                CGFloat currentW = [self.currentLabel.text getSingleLineTextWidthWithFont:[UIFont systemFontOfSize:14] withMaxWith:Width];
                self.currentLabel.frame = CGRectMake(20, 64, currentW+10, 30);
            }
        }];
}


@end
