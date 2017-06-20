//
//  SearchHistoryViewController.m
//  搜索
//
//  Created by 席亚坤 on 16/12/23.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "SearchHistoryCell.h"
#import "SearchHistoryCellTwo.h"
#import "PopoverView.h"
#import "UIButton+LXMImagePosition.h"
//#import "SearchHistoryView.h"
#import "GoodsListVC.h"
#import "UIView+Toast.h"

@interface SearchHistoryViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
typedef enum : NSUInteger {
    HistoryData,
    NetWorkData,
} SearchData;
@property (weak, nonatomic) IBOutlet UIButton *PopoverViewBtn;
@property (nonatomic, strong)NSMutableArray    *PopoverViewArr;
///数据源类型
@property(nonatomic,assign)SearchData searchData;
///历史数据
@property (nonatomic,strong)NSMutableArray * HistoryArray;
///网络数据
@property (nonatomic,strong)NSMutableArray * dataArray;
//1-商家，2-团购套餐，3-便民服务
@property(nonatomic,strong)NSString * serchType;


@end

@implementation SearchHistoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.searchData = HistoryData;
    [self.HistoryArray removeAllObjects];
    self.HistoryArray = [NSMutableArray arrayWithArray:[self GetHistoryData]];
    [self.tableView reloadData];
    

//    ReceiveIndustry* VC = [[ReceiveIndustry alloc]initWithNibName:@"ReceiveIndustry" bundle:nil];
//    
//    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    [self presentViewController:VC animated:YES completion:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    [self SET_UI];
    [self SET_Data];


    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - SET_Data
-(void)SET_Data{
    //NSArray *ZWLanguageListArr=[NSArray arrayWithObjects:@"宝贝",@"团购",@"便民" ,nil];
    //1-商家，2-团购套餐，3-便民服务
    self.serchType = @"1";
    self.PopoverViewArr=[NSMutableArray arrayWithCapacity:0];
    [self.PopoverViewArr addObject:@{@"title":@"  商 家 ",@"hidID":@"1"}];
    [self.PopoverViewArr addObject:@{@"title":@"团购套餐",@"hidID":@"2"}];
    [self.PopoverViewArr addObject:@{@"title":@"便民服务",@"hidID":@"3"}];
    
    
}

#pragma mark - SET_UI
-(void)SET_UI{
    [self.PopoverViewBtn setImagePosition:LXMImagePositionRight spacing:15];
    _bottomView.layer.masksToBounds = YES;
    _bottomView.layer.cornerRadius = 14.5;
//注册
    //[self.tableView tableViewregisterNibArray:@[@"SearchHistoryCell",@"SearchHistoryCellTwo"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:nil] forCellReuseIdentifier:@"SearchHistoryCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"SearchHistoryCellTwo" bundle:nil] forCellReuseIdentifier:@"SearchHistoryCellTwo"];
    self.tableView.tableFooterView = [UIView new];
    //输入框
    [self.searchHisToryTF becomeFirstResponder];
    [self.searchHisToryTF addTarget:self action:@selector(searchHisToryTFEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
}
- (IBAction)PopoverViewBtnAction:(UIButton*)sender {
    [self.view endEditing:NO];
    //点击按钮的响应事件；
    NSMutableArray *tmp=[NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    for (int i=0; i<self.PopoverViewArr.count; i++) {
        NSDictionary * dic = self.PopoverViewArr[i];
        
        PopoverAction *action = [PopoverAction actionWithTitle:dic[@"title"] hidID:dic[@"hidID"] handler:^(PopoverAction *action) {
            [sender setTitle:action.title forState:0];
            NSLog(@"----%@",action.hidID);
            weakSelf.serchType = action.hidID;
        }];
        [tmp addObject:action];

//        PopoverAction *action = [PopoverAction actionWithImage:[UIImage imageNamed:dic[@"title"]] title:dic[@"title"] hidID:dic[@"hidID"] handler:^(PopoverAction *action) {
//            [sender setTitle:action.title forState:0];
//            NSLog(@"----%@",action.hidID);
//            weakSelf.serchType = action.hidID;
//            
//        }];
       // [tmp addObject:action];
    }
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.showShade = NO;
    [popoverView showToView:sender withActions:[NSArray arrayWithArray:tmp]];
    
}


#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    switch (self.searchData) {
        case HistoryData:
        {
            
            return 2;
        }
            break;
        case NetWorkData:
        {
            return 1;
            
        }
            break;
        default:{
            return 0;
        }
            break;
    }

}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.searchData) {
        case HistoryData:
        {
            if (section==0) {
                return self.HistoryArray.count;
            }else{
                return self.HistoryArray.count !=0 ? 1:0;
            }
            
           
            
        }
            break;
        case NetWorkData:
        {
            return self.dataArray.count;

        }
            break;
        default:{
            return 0;
        }
            break;
    }

}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    switch (self.searchData) {
        case HistoryData:
        {
            if (indexPath.section==0) {
                 SearchHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell" forIndexPath:indexPath];
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.label.text = self.HistoryArray[indexPath.row];

                return cell;

            }else{
                SearchHistoryCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCellTwo" forIndexPath:indexPath];
                [cell.ClearBtn addTarget:self action:@selector(ClearhistoryAction:) forControlEvents:(UIControlEventTouchUpInside)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            
        }
            break;
        case NetWorkData:
        {
            SearchHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = self.dataArray[indexPath.row];
            
            return cell;

        }
            break;
        default:{
        }
            break;
    }
    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.searchData) {
        case HistoryData:
        {
            if (indexPath.section==0) {
                return 44;
            }else{
                return 80;
            }
            
        }
            break;
        case NetWorkData:
        {
            return 44;
        }
            break;
        default:{
            return 44;

        }
            break;
    }

}

#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.searchData) {
        case HistoryData:
        {   //第一分区
            if (indexPath.section==0) {
                
                if (indexPath.row !=0) {
                    //Push 跳转
                    GoodsListVC * VC = [[GoodsListVC alloc]initWithNibName:@"GoodsListVC" bundle:nil];
                    VC.keyword = self.HistoryArray[indexPath.row];
                    VC.serchType =self.serchType;
                    __weak typeof(self) weakSelf = self;
                    VC.GoodsListVCBlock = ^(NSString * keyword){
                        weakSelf.searchHisToryTF.text = keyword;
                        
                    };
                    NSLog(@"textField.text;--%@\n---merchantCategoryId :%@",self.HistoryArray[indexPath.row],self.serchType);

                    [self.navigationController  pushViewController:VC animated:YES];
                }
            }

        }
            break;
        case NetWorkData:
        {
            
        }
            break;
        default:{
        }
            break;
    }

}


#pragma mark - 返回事件
- (IBAction)CancelAction:(UIButton *)sender {
    [self.view endEditing:NO];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - searchHisToryTFEditingChanged
-(void)searchHisToryTFEditingChanged:(UITextField*)sender{
    if ([sender.text isEqualToString:@""]) {
        self.searchData = HistoryData;
        [self.HistoryArray removeAllObjects];
        self.HistoryArray = [NSMutableArray arrayWithArray:[self GetHistoryData]];
        [self.tableView reloadData];
        
    }else{
         self.searchData = NetWorkData;
#warning 网络请求 待定
         //[self.tableView reloadData];

    }
    
}
#pragma mark - 清除输入框
- (IBAction)ClearTFAction:(UIButton *)sender {
    _searchHisToryTF.text = @"";
    [self.dataArray removeAllObjects];
    self.searchData = HistoryData;
    self.HistoryArray = [NSMutableArray arrayWithArray:[self GetHistoryData]];
    [self.tableView reloadData];
    
    
    
}
#pragma mark - 列表滚动键盘回收
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchHisToryTF resignFirstResponder];
}
#pragma mark - 点击键盘return键
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if (textField.text.length !=0) {
        //保存历史记录
        [self  HistoryDataSave];
//        self.searchData = NetWorkData ;
//        [self.dataArray removeAllObjects];
//        [self.tableView reloadData];
        //    //Push 跳转
        GoodsListVC * VC = [[GoodsListVC alloc]initWithNibName:@"GoodsListVC" bundle:nil];
        VC.keyword = textField.text;
        VC.serchType = self.serchType;
        __weak typeof(self) weakSelf = self;
        VC.GoodsListVCBlock = ^(NSString * keyword){
            weakSelf.searchHisToryTF.text = keyword;
        };
        [self.navigationController  pushViewController:VC animated:YES];

    }else{
        [self.view hideToastActivity];
        [self.view makeToast:@"请输入搜索内容" duration:1.5 position:CSToastPositionCenter];

    }
    #warning 添加网络搜索------
    
   
    return YES;
 
   

}

#pragma mark - 清除历史
-(void)ClearhistoryAction:(UIButton*)sender
{    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SearchHistory"];
    [self.HistoryArray removeAllObjects];
    [self.dataArray removeAllObjects];
    self.searchData = NetWorkData;
    [self.tableView reloadData];

    
}


#pragma mark - 保存历史记录
-(void)HistoryDataSave
{
    NSUserDefaults * UserDefault = [NSUserDefaults standardUserDefaults];
    NSArray * SearchArr = [UserDefault objectForKey:@"SearchHistory"];
    if (SearchArr.count==0) {
     [UserDefault setObject: [NSArray arrayWithObjects:@"历史搜索",self.searchHisToryTF.text,nil] forKey:@"SearchHistory"];
    }else{
        NSMutableArray * AfterMArray = [NSMutableArray arrayWithArray:SearchArr];
        //插入数据到第二位
        [AfterMArray insertObject:self.searchHisToryTF.text atIndex:1];
        //去重
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in AfterMArray) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        [UserDefault setObject:[NSArray arrayWithArray:listAry] forKey:@"SearchHistory"];
    }
    [UserDefault synchronize];
   

    
}
#pragma mark - 取出历史记录
-(NSArray*)GetHistoryData{
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"];
}

-(NSMutableArray *)HistoryArray{
    if (!_HistoryArray) {
        self.HistoryArray = [NSMutableArray arrayWithCapacity:1];
    }return _HistoryArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
