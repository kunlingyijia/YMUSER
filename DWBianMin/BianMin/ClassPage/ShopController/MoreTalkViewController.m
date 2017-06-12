//
//  MoreTalkViewController.m
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MoreTalkViewController.h"
#import "ThirdShopCell.h"
#import "RequestMerchantCommentListModel.h"
#import "FourShopCell.h"
#import "RequestMerchantCommentList.h"
@interface MoreTalkViewController ()<UITableViewDataSource, UITableViewDelegate,ThirdShopCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *talkArr;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MoreTalkViewController

- (NSMutableArray *)talkArr {
    if (!_talkArr) {
        self.talkArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _talkArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.pageIndex = 1;
    [self showBackBtn];
    [self createTableView];
    [self getTalkData];
}
- (void)getTalkData {
    RequestMerchantCommentList *talkList = [[RequestMerchantCommentList alloc] init];
    talkList.pageCount = 10;
    talkList.pageIndex = self.pageIndex;
    talkList.merchantId = self.merchantId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    if (self.goodsID == nil || self.goodsID == NULL) {
        talkList.goodsId = self.goodsID;
    }
    baseReq.data = talkList;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantCommentList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSDictionary *data = baseRes.data;
        NSDictionary *datalist = data[@"datalist"];
        if (baseRes.resultCode == 1) {
            if (self.pageIndex == 1) {
                [self.talkArr removeAllObjects];
            }
            for (NSDictionary *dic in datalist) {
                RequestMerchantCommentListModel *talkModel = [RequestMerchantCommentListModel yy_modelWithDictionary:dic];
                [self.talkArr addObject:talkModel];
            }
        }else {
             [self showToast:baseRes.msg];//[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:Bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight =  (Bounds.size.width - 40)/3 * 1 +130;
    [self.tableView registerClass:[ThirdShopCell class] forCellReuseIdentifier:@"thirdShopCell"];
    [self.tableView registerClass:[FourShopCell class] forCellReuseIdentifier:@"fourShopCell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getTalkData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getTalkData];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.talkArr.count];
    return self.talkArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestMerchantCommentListModel *talkModel = self.talkArr[indexPath.row];
    if (talkModel.images.count == 0) {
        FourShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourShopCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell cellGetDataWith:talkModel withController:self];
        return cell;
    }else {
        ThirdShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdShopCell" forIndexPath:indexPath];
        [cell.pictureArray removeAllObjects];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.pictureArray removeAllObjects];
        [cell.pictureArray addObjectsFromArray:talkModel.images];
        [cell talkImageData:nil];
        [cell cellGetDataWith:talkModel withController:self];
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestMerchantCommentListModel *talkModel = self.talkArr[indexPath.row];
    CGFloat textHeight = [talkModel.content getTextHeightWithFont:[UIFont systemFontOfSize:12] withMaxWith:Width-20];
    if (talkModel.images.count == 0) {
        return 40 + textHeight;
    }else {
        return 40 + textHeight + (Bounds.size.width - 40)/3;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchPhotoImage:(id)sender {
    OKLog(@"点击头像");
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
