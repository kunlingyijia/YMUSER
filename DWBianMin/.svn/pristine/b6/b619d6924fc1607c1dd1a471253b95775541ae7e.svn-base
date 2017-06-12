//
//  SearchViewController.m
//  BianMin
//
//  Created by kkk on 16/4/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomSearchBar.h"
#import "RequestMerchantList.h"
#import "RequestMerchantListModel.h"
#import "DWMainPageTableViewCell.h"
#import "ShopViewController.h"
#import "BMShopContentController.h"
#define BtnWidth (Width - 20)/3
#define LineW 1
#define Bounds [UIScreen mainScreen].bounds

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *searchTabelView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSArray *historyArr;
@end

@implementation SearchViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyArr = [NSArray arrayWithArray:[self readArrayBySandBox]];
    self.pageIndex = 1;
    [self newShowBackBtn];
    
    [self createSearchBar];
    [self createView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController.navigationBar endEditing:YES];
}

- (void)createSearchBar {
    CustomSearchBar *searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(-50, 0, Width-110 , 25)];
//    searchBar.backgroundColor = [UIColor redColor];
    __weak SearchViewController *weakSelf = self;
    [searchBar getBlockFromOutSpace:^(UITextField *textField) {
        if (textField.text.length == 0) {
            [textField endEditing:YES];
            [self showToast:@"请输入要搜索的内容"];
        }else {
            [weakSelf writeArrayToPath:textField.text];
            weakSelf.searchTabelView.hidden = NO;
            [weakSelf.searchBtn setTitle:@"取消" forState:UIControlStateNormal];
            [weakSelf searchData:1 withSort:1 withTextField:textField];
        }
    }];
    
    searchBar.beginSearch = ^(UITextField *textField) {
        weakSelf.textField = textField;
        [weakSelf.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    };
    searchBar.endSearch = ^(NSString *str) {
        
    };
    
    self.navigationItem.titleView = searchBar;
}

- (void)newShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
//    backBtn.backgroundColor = [UIColor redColor];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"icon_arrows_left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(newDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)newDoBack:(id)sender{
    [self.navigationController.navigationBar endEditing:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)searchData:(NSInteger)kind withSort:(NSInteger)sort withTextField:(UITextField *)textField {
    RequestMerchantList *merchantL = [[RequestMerchantList alloc] init];
//    merchantL.categoryId = kind;
    merchantL.pageCount = 10;
    merchantL.keyword = textField.text;
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
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.searchTabelView reloadData];
        [self.textField endEditing:YES];
        [self.tableView reloadData];
    } faild:^(id error) {
       
    }];
}


- (void)getBlockFromOutSpace:(ReturnBlock)block {

}

- (void)createView {
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.searchBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
    
    self.searchBtn.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    UILabel *hotSearch = [UILabel new];
    hotSearch.text = @"热门搜索";
    [self.view addSubview:hotSearch];
    hotSearch.textColor = [UIColor colorWithHexString:kTitleColor];
    hotSearch.font = [UIFont systemFontOfSize:12];
    [hotSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 0));
    }];
    
//    for (int i = 0; i < 3; i++) {
//        for (int j = 0; j < 3; j++) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.backgroundColor = [UIColor whiteColor];
//            btn.titleLabel.font = [UIFont systemFontOfSize:12];
//            [btn setTitle:@"辣煌尚" forState:UIControlStateNormal];
//            btn.layer.borderColor = [UIColor grayColor].CGColor;
//            btn.layer.borderWidth = LineW;
//            [btn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
//            [self.view addSubview:btn];
//            btn.frame = CGRectMake(10 + j * (BtnWidth-LineW ), 110 + i * (30-LineW), BtnWidth, 30);
//        }
//    }
    
    UILabel *historyLabel = [UILabel new];
    historyLabel.text = @"历史搜索";
    [self.view addSubview:historyLabel];
    historyLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    historyLabel.font = [UIFont systemFontOfSize:12];
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.top.equalTo(hotSearch.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"historyCell"];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 30)];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAcrion:)];
    [label addGestureRecognizer:tap];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"清除历史搜索";
    label.textColor = [UIColor colorWithHexString:kTitleColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = label;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(historyLabel.mas_bottom);
    }];
    
    self.searchTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    self.searchTabelView.delegate = self;
    self.searchTabelView.dataSource = self;
    self.searchTabelView.hidden = YES;
    self.searchTabelView.rowHeight = 80;
        [self.searchTabelView registerClass:[DWMainPageTableViewCell class] forCellReuseIdentifier:@"HomePageCell"];
//    self.searchTabelView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.searchTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"historyCell"];
    [self.view addSubview:self.searchTabelView];
    self.searchTabelView.tableFooterView =[UIView new];
}

#pragma mark - 清楚搜索历史
- (void)clearAcrion:(UITapGestureRecognizer *)sender {
    [self clearAcrion];
}

- (void)clearAcrion{
    NSString *filePath = [self getFilePathByFileName:@"historyArray.txt"];
    NSArray *array = @[];
    BOOL isWrite = [array writeToFile:filePath atomically:YES];
    NSLog(isWrite ? @"数组写入成功":@"数组写入失败");
    self.historyArr = nil;
    [self.tableView reloadData];
    
}

- (void)searchAction:(UIButton *)sender {
    if (self.textField.text.length == 0) {
        [self.textField endEditing:YES];
        [self showToast:@"请输入要搜索的内容"];
    }else {
        if ([sender.titleLabel.text isEqualToString:@"搜索"]) {
            [sender setTitle:@"取消" forState:UIControlStateNormal];
            [self searchData:1 withSort:1 withTextField:self.textField];
            self.searchTabelView.hidden = NO;
            //搜索历史 存入沙盒
            [self writeArrayToPath:self.textField.text];
        }else {
            [sender setTitle:@"搜索" forState:UIControlStateNormal];
            self.searchTabelView.hidden = YES;
            //        NSLog(@"%@", [self readArrayBySandBox]);
            self.historyArr = [NSArray arrayWithArray:[self readArrayBySandBox]];
            [self.tableView reloadData];
        }
    }
}

- (void)writeArrayToPath:(NSString *)str {
    NSString *filePath = [self getFilePathByFileName:@"historyArray.txt"];
    self.historyArr = [self readArrayBySandBox];
    for (NSString *searchStr in self.historyArr) {
        if ([searchStr isEqualToString:str]) {
            return;
        }
    }
    if (str != nil) {
        NSString *filePath = [self getFilePathByFileName:@"historyArray.txt"];
        NSArray *array = [self readArrayBySandBox];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (NSString *string in array) {
            [arr addObject:string];
        }
        [arr addObject:str];
        BOOL isWrite = [arr writeToFile:filePath atomically:YES];
        NSLog(isWrite ? @"数组写入成功":@"数组写入失败");
    }
}
- (NSArray *)readArrayBySandBox {
    NSString *filePath = [self getFilePathByFileName:@"historyArray.txt"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    return array;
}
- (NSString *)getFilePathByFileName:(NSString *)name {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:name];
    return filePath;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.searchTabelView]) {
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
    }else {
        NSString *str = self.historyArr[indexPath.row];
        self.textField.text = str;
        [self.searchBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self searchData:1 withSort:1 withTextField:self.textField];
        self.searchTabelView.hidden = NO;
    }
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.historyArr.count;
    }
        return self.dataSource.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
//        UIImage *icon = [UIImage imageNamed:@"icon_home_chuxing_shijian"];
//        CGSize itemSize = CGSizeMake(15, 15);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [icon drawInRect:imageRect];
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *str = self.historyArr[indexPath.row];
        cell.textLabel.text = str;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor  colorWithHexString:kTitleColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        return cell;
    }
        DWMainPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageCell" forIndexPath:indexPath];
        RequestMerchantListModel *model = self.dataSource[indexPath.row];
        [cell cellGetDataModel:model WithController:self];
        return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}





@end
