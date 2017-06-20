//
//  DWClassPageViewController.m
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWClassPageViewController.h"
#import "DWMainPageTableViewCell.h"
#import "Masonry.h"
#import "DropDownListView.h"
#import "ShopViewController.h"
#import "RequestMerchantList.h"
#import "RequestMerchantListModel.h"
#import "RequestCateAndBusinessarea.h"
#import "RequestCateAndBusinessareaModel.h"
#import "BusinessareaModel.h"
#import "BMShopContentController.h"
#import "RequestCateAndBusinessareaModel.h"
#import "BmClassModel.h"
#import "ClassLeftCell.h"
#import "GoodsListOneCell.h"
#define Bounds [UIScreen mainScreen].bounds
@interface DWClassPageViewController ()<UITableViewDelegate, UITableViewDataSource,DropDownChooseDelegate,DropDownChooseDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *chooseArray;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *classImages;
@property (nonatomic, strong) NSMutableArray *selectdImage;
@property (nonatomic, assign) NSInteger factorNum;
@property (nonatomic, assign) NSInteger businessIndex;
@property (nonatomic, strong) UITableView *bmTableView;

@property (nonatomic, strong) NSMutableArray *bmClassDataSource;

//测试数据 存储当前选择的分类
@property (nonatomic, assign) NSInteger currClass;
//当前分类对象
@property (nonatomic, strong) RequestCateAndBusinessareaModel *buinessModel;
//存储当前是否有侧边分类 1-有
@property (nonatomic, assign) NSInteger isSide;
//存储小分类下标
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, assign) NSInteger isKind;
@property (nonatomic, assign) NSInteger count;

@end

@implementation DWClassPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取经纬度
    [[DWHelper shareHelper]getloaction];
    [self getClassKind];
    self.currClass = 0;
    self.businessIndex = 0;
    self.factorNum = 1;
    self.count = 1;
    self.cellIndex = 0;
    [self stupTableView];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.isKind = 0;
    if (self.isNewController == 6) {
        self.isSide = 1;
        self.currClass = self.newCount;
        self.isKind = self.newCount;
    }else {
        self.count = 1;
        self.kindClassIndex = 0;
        [self getDataWithKind:0 withSort:self.factorNum withBusiness:self.businessIndex];
    }
    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAdress:) name:@"切换地址" object:nil];
}
- (void)changeAdress:(NSNotification *)sender {
    self.kindClassIndex =0;
    [self.chooseArray removeAllObjects];
    [self getClassKind];
    self.businessIndex = 0;
    self.factorNum = 1;
    self.tableView.frame = CGRectMake(0, 40, Width, Height-64-40);
    [self.bmTableView removeFromSuperview];
    
    [self.dropDownView setTitle:@"全部" inSection:0];
    [self getDataWithKind:0 withSort:self.factorNum withBusiness:self.businessIndex];
}

- (void)getDataWithKind:(NSInteger)kind withSort:(NSInteger)sort withBusiness:(NSInteger)business{
    [self showProgress];
    RequestMerchantList *merchantL = [[RequestMerchantList alloc] init];
    
    merchantL.businessAreaId = business;
    merchantL.merchantCategoryId =[NSString stringWithFormat:@"%ld", (long)kind];
    merchantL.pageCount = 10;
    merchantL.pageIndex = self.count;
    merchantL.regionId = [AuthenticationModel getRegionID];
    merchantL.sort =[NSString stringWithFormat:@"%ld", (long)sort];
    
    DWHelper *helper = [DWHelper shareHelper];
    merchantL.lng = [NSString stringWithFormat:@"%f", helper.coordinate.longitude];
    merchantL.lat = [NSString stringWithFormat:@"%f", helper.coordinate.latitude];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if (self.isLogin) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = merchantL;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            if (self.count == 1) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantListModel *model = [RequestMerchantListModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
            [self hideProgress];
        }else {
            [self hideProgress];
            [self showToast:baseRes.msg];

        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        [self.tableView reloadData];
    } faild:^(id error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideProgress];
    }];
}

- (void)stupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, Bounds.size.width, Bounds.size.height - 104) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.backgroundColor =[UIColor colorWithHexString:kViewBg];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[DWMainPageTableViewCell class] forCellReuseIdentifier:@"HomePageCell"];
    
//    self.tableView.rowHeight = 80;
    self.tableView.rowHeight = Width *0.19;
    [self.tableView tableViewregisterNibArray:@[@"GoodsListOneCell"]];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    
    __weak DWClassPageViewController *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.count = 1;
        if (weakSelf.isSide == 1) {
            if (weakSelf.bmClassDataSource.count == 0) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
                return ;
            }
            BmClassModel *bmModel = weakSelf.bmClassDataSource[weakSelf.cellIndex];
            NSArray *businessArr = weakSelf.chooseArray[1];
            BusinessareaModel *businessModel = businessArr[weakSelf.businessIndex];
            [weakSelf getDataWithKind:[bmModel.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businessModel.businessAreaId];
        }else {
            if (weakSelf.chooseArray.count == 3) {
                NSArray *arr = weakSelf.chooseArray[0];
                NSArray *businessArr = weakSelf.chooseArray[1];
                RequestCateAndBusinessareaModel *model = arr[weakSelf.kindClassIndex];
                BusinessareaModel *businessModel = businessArr[weakSelf.businessIndex];
                [weakSelf getDataWithKind:[model.merchantCategoryId integerValue] withSort:weakSelf.factorNum withBusiness:businessModel.businessAreaId];
            }else {
                NSArray *arr = weakSelf.chooseArray[0];
                RequestCateAndBusinessareaModel *model = arr[weakSelf.kindClassIndex];
                [weakSelf getDataWithKind:[model.merchantCategoryId integerValue] withSort:weakSelf.factorNum withBusiness:0];
            }
        }
    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.count = self.count + 1;
        if (self.chooseArray.count == 3) {
            NSArray *arr = self.chooseArray[0];
            NSArray *businessArr = self.chooseArray[1];
            RequestCateAndBusinessareaModel *model = arr[self.kindClassIndex];
            BusinessareaModel *businessModel = businessArr[self.businessIndex];
            [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businessModel.businessAreaId];
        }else {
            NSArray *arr = self.chooseArray[0];
            RequestCateAndBusinessareaModel *model = arr[self.kindClassIndex];
            [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:0];
        }
    }];
}
#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index{
    self.count = 1;
    if (self.chooseArray.count == 3) {
        if (section == 0) {
            self.cellIndex = 0;
            self.tableView.frame= CGRectMake(0, 40, Width, Height-40-64);
            self.bmTableView.backgroundColor = [UIColor redColor];
            [self.bmTableView removeFromSuperview];
            //选择全部 不显示侧边
            self.isSide = 0;
            NSArray *arr = self.chooseArray[section];
            NSArray *businessArr = self.chooseArray[1];
            self.kindClassIndex = index;
            RequestCateAndBusinessareaModel *model = arr[index];
            BusinessareaModel *businessModel = businessArr[self.businessIndex];
            [self.dataSource removeAllObjects];
            self.model = model;
            if (index == 0) {
                if (self.chooseArray.count == 3) {
                    NSArray *arr = self.chooseArray[0];
                    NSArray *businessArr = self.chooseArray[1];
                    RequestCateAndBusinessareaModel *model = arr[self.kindClassIndex];
                    BusinessareaModel *businessModel = businessArr[self.businessIndex];
                    [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businessModel.businessAreaId];
                }else {
                    NSArray *arr = self.chooseArray[0];
                    RequestCateAndBusinessareaModel *model = arr[self.kindClassIndex];
                    [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:0];
                }
            }else {
                //选择分类 有侧边分类
                self.isSide = 1;
                [self.bmClassDataSource removeAllObjects];
                for (NSDictionary *bmdic in model._child) {
                    BmClassModel *bmModel = [BmClassModel yy_modelWithDictionary:bmdic];
                    [self.bmClassDataSource addObject:bmModel];
                }
                //没有分类 返回nil
                if (self.bmClassDataSource.count == 0) {
                    [self.tableView reloadData];
                    return;
                }
                
                [self.bmTableView removeFromSuperview];
                
                self.tableView.frame = CGRectMake(Width/4, 40, Width-Width/4, Height-40-64);
                self.bmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, Width/4, Height-40-64-44) style:UITableViewStylePlain];
                self.bmTableView.delegate = self;
                self.bmTableView.dataSource = self;
                //self.bmTableView.backgroundColor = [UIColor redColor];
                [self.bmTableView tableViewregisterNibArray:@[@"ClassLeftCell"]];
                
//                [self.bmTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"bmCell"];
                //self.bmTableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
                [self.view addSubview:self.bmTableView];
                self.bmTableView.tableFooterView = [UIView new];
                [self.bmTableView reloadData];
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.bmTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                
                BmClassModel *bmModel = self.bmClassDataSource[0];
                NSArray *businessArr = self.chooseArray[1];
                BusinessareaModel *businessModel = businessArr[self.businessIndex];
                [self getDataWithKind:[bmModel.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businessModel.businessAreaId];
                
            }
        }else if (section == 1) {
            self.businessIndex = index;
//            NSArray *arr = self.chooseArray[0];
            NSArray *businessArr = self.chooseArray[1];
            if (self.isSide == 1) {
                NSLog(@"%@",self.bmClassDataSource);
                RequestCateAndBusinessareaModel *model = self.bmClassDataSource[self.cellIndex];
                BusinessareaModel *businessModel = businessArr[self.businessIndex];
                NSInteger buinessddd = businessModel.businessAreaId;
                [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:buinessddd];
            }else {
                BusinessareaModel *businessModel = businessArr[self.businessIndex];
                NSInteger buinessddd = businessModel.businessAreaId;
                [self getDataWithKind:0 withSort:self.factorNum withBusiness:buinessddd];
            }
            
        }else if (section == 2) {
            self.factorNum = index+1;
            [self.dataSource removeAllObjects];
            if (self.isSide == 1) {
                //有侧边栏
//                NSArray *arr = self.chooseArray[0];
                NSArray *businessArr = self.chooseArray[1];
                RequestCateAndBusinessareaModel *model = self.bmClassDataSource[self.cellIndex];
                BusinessareaModel *businessModel = businessArr[self.businessIndex];
                [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businessModel.businessAreaId];
            }else {
                //无侧边栏
                NSArray *arr = self.chooseArray[0];
                NSArray *businessArr = self.chooseArray[1];
                RequestCateAndBusinessareaModel *model = arr[self.kindClassIndex];
                BusinessareaModel *businessModel = businessArr[self.businessIndex];
                [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businessModel.businessAreaId];
            }
            
        }
    }else if (self.chooseArray.count == 2) {
        if (section == 0) {
            
            NSArray *arr = self.chooseArray[section];
            self.kindClassIndex = index;
            RequestCateAndBusinessareaModel *model = arr[index];
            [self.dataSource removeAllObjects];
            self.model = model;
            [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:0];
        }else if (section == 1) {
            self.factorNum = index+1;
            [self.dataSource removeAllObjects];
            NSArray *arr = self.chooseArray[0];
            RequestCateAndBusinessareaModel *model = arr[self.kindClassIndex];
            [self getDataWithKind:[model.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:0];
        }
    }
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [self.chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =self.chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{   if(section == 0) {
        NSArray *arr = self.chooseArray[section];
        RequestCateAndBusinessareaModel *model = arr[index];
        return model.categoryName;
    }
    NSArray *kingArr = self.chooseArray[section];
    BusinessareaModel *model = kingArr[index];
    return model.name;
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.bmTableView]) {
        self.cellIndex = indexPath.row;
        BmClassModel *bmModel = self.bmClassDataSource[indexPath.row];
        NSArray *businessArr = self.chooseArray[1];
        BusinessareaModel *businessModel = businessArr[self.businessIndex];
        [self getDataWithKind:[bmModel.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businessModel.businessAreaId];
        return;
    }
    
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
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.bmTableView]) {
        return self.bmClassDataSource.count;
    }
    [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount: self.dataSource.count ];
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.bmTableView]) {
        ClassLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassLeftCell" forIndexPath:indexPath];
       // cell.backgroundColor = [UIColor colorWithHexString:kViewBg];
        BmClassModel *bmModel = self.bmClassDataSource[indexPath.row];
//        cell.selectedBackgroundView = [UIView new];
//        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.label.text = bmModel.categoryName;
//        cell.textLabel.font = [UIFont systemFontOfSize:13];
        //cell.textLabel.adjustsFontSizeToFitWidth = YES;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       // cell.textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        return cell;
    }else {
//        DWMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageCell" forIndexPath:indexPath];
//        RequestMerchantListModel *model = self.dataSource[indexPath.row];
//        [cell cellGetDataModel:model WithController:self];
//        return cell;
        GoodsListOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListOneCell" forIndexPath:indexPath];
        RequestMerchantListModel *model = self.dataSource[indexPath.row];
        cell.model = model;
        return cell;

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMerchantCategory:(RequestCateAndBusinessareaModel *)model withIndex:(NSInteger)kindIndex{
    self.title = @"商家";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delayRun:model withIndex:kindIndex];
    });
//    [self performSelector:@selector(delayRun:) withObject:model afterDelay:0.2];
}

- (void)delayRun:(RequestCateAndBusinessareaModel *)model withIndex:(NSInteger)kindIndex{
    [self showBackBtn];
    self.title = @"商家";
//    self.kindClassIndex = kindIndex+1;
    [self.dropDownView setTitle:model.categoryName inSection:0];
//    [self getDataWithKind:model.merchantCategoryId withSort:1 withBusiness:0];
}

- (void)getClassKind {
    RequestCateAndBusinessarea *cate = [[RequestCateAndBusinessarea alloc] init];
    cate.regionId = [AuthenticationModel getRegionID];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.data = cate;
    baseReq.encryptionType = RequestMD5;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestCateAndBusinessarea" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            NSArray *category = baseRes.data[@"category"];
            NSMutableArray *categoryArr = [NSMutableArray arrayWithCapacity:0];
            RequestCateAndBusinessareaModel *firstModel = [[RequestCateAndBusinessareaModel alloc] init];
            firstModel.categoryName = @"全部";
            firstModel.merchantCategoryId = 0;
            [categoryArr addObject:firstModel];
            for (NSDictionary *dic in category) {
                RequestCateAndBusinessareaModel *categoryModel = [RequestCateAndBusinessareaModel yy_modelWithDictionary:dic];
                [categoryArr addObject:categoryModel];
            }
            [self.chooseArray addObject:categoryArr];
            NSMutableArray *arrTwo = [NSMutableArray arrayWithCapacity:0];
            BusinessareaModel *businessModel = [[BusinessareaModel alloc] init];
            businessModel.name = @"全城·热门";
            businessModel.businessAreaId = 0;
            [arrTwo addObject:businessModel];
            NSArray *businessarea = baseRes.data[@"businessarea"];
            for (NSDictionary *dic in businessarea) {
                BusinessareaModel *model = [BusinessareaModel yy_modelWithDictionary:dic];
                [arrTwo addObject:model];
            }
            if (businessarea.count > 0) {
                [self.chooseArray addObject:arrTwo];
            }
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            BusinessareaModel *thirdModel = [[BusinessareaModel alloc] init];
            thirdModel.name = @"按销量";
            thirdModel.businessAreaId = 1;
            [arr addObject:thirdModel];
            BusinessareaModel *fourModel = [[BusinessareaModel alloc] init];
            fourModel.name = @"按距离";
            fourModel.businessAreaId = 2;
            [arr addObject:fourModel];
            [self.chooseArray addObject:arr];
        }
        [self createDorpView];
    } faild:^(id error) {
        
    }];
}

- (void)createDorpView {
    self.dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) dataSource:self delegate:self isNavigation:NO titleColor:kNavigationBgColor];
    self.dropDownView.backgroundColor = [UIColor whiteColor];
    self.dropDownView.mSuperView = self.view;
    self.dropDownView.hightArray = [NSMutableArray arrayWithArray:self.chooseArray];
    
    [self.view addSubview:self.dropDownView];
    
    if (self.isNewController == 6) {
        [self showBackBtn];
        [self delayRun:self.model withIndex:0];
        self.dropDownView.frame = CGRectMake(0, 0, Width, 40);
        
        NSArray *arr = self.chooseArray[0];
//        NSArray *businessArr = self.chooseArray[1];
        
        RequestCateAndBusinessareaModel *model = arr[self.kindClassIndex];
        [self.dataSource removeAllObjects];
        
        [self.bmClassDataSource removeAllObjects];
        for (NSDictionary *bmdic in model._child) {
            BmClassModel *bmModel = [BmClassModel yy_modelWithDictionary:bmdic];
            [self.bmClassDataSource addObject:bmModel];
        }
        //没有分类 返回nil
        if (self.bmClassDataSource.count == 0) {
            [self.tableView reloadData];
            return;
        }
        
        self.tableView.frame = CGRectMake(Width/4, 40, Width-Width/4, Height-40-64);
        self.bmTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, Width/4, Height-40-64) style:UITableViewStylePlain];
        self.bmTableView.delegate = self;
        self.bmTableView.dataSource = self;
//        [self.bmTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"bmCell"];
        [self.bmTableView tableViewregisterNibArray:@[@"ClassLeftCell"]];
        self.bmTableView.backgroundColor = [UIColor  whiteColor];
        [self.view addSubview:self.bmTableView];
        self.bmTableView.tableFooterView = [UIView new];
        [self.bmTableView reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.bmTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        BmClassModel *bmModel = self.bmClassDataSource[0];
        NSArray *busiArray = self.chooseArray[1];
        BusinessareaModel *businModel = busiArray[self.businessIndex];
        [self getDataWithKind:[bmModel.merchantCategoryId integerValue] withSort:self.factorNum withBusiness:businModel.businessAreaId];
        
    }
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (NSMutableArray *)chooseArray {
    if (!_chooseArray) {
        self.chooseArray = [NSMutableArray arrayWithCapacity:0];
        //        self.chooseArray = [NSMutableArray arrayWithArray:@[
        //                                                            @[@"全部",@"便民",@"家政",@"餐饮",@"娱乐",@"酒店", @"其他"],
        //                                                            @[@"按销量",@"按距离"]
        //                                                            ]];
    }
    return _chooseArray;
}

- (NSMutableArray *)selectdImage {
    if (!_selectdImage) {
        self.selectdImage = [NSMutableArray arrayWithObjects:@[@"",@"",@"",@"",@"",@"",@""],@[@"",@""], nil];
    }
    return _selectdImage;
}


- (NSMutableArray *)classImages {
    if (!_classImages) {
        self.classImages = [NSMutableArray arrayWithObjects:@[@"",@"",@"",@"",@"",@"",@""],@[@"",@""], nil];
    }
    return _classImages;
}

- (NSMutableArray *)bmClassDataSource {
    if (!_bmClassDataSource) {
        self.bmClassDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _bmClassDataSource;
}

@end
