//
//  ShopViewController.m
//  BianMin
//
//  Created by kkk on 16/4/29.
//  Copyright © 2016年 bianming. All rights reserved.
//
#import "ShopViewController.h"
#import "Masonry.h"
#import "CWStarRateView.h"
#import "ShopViewCell.h"
#import "SecondShopCell.h"
#import "ThirdShopCell.h"
#import "ShopContentViewController.h"
#import "CouponView.h"
#import "FootMoreCell.h"
#import "CommentMoreCell.h"
#import "MerchantModel.h"
#import "MoreTalkViewController.h"
#import "NSString+DWString.h"
#import "GoodsModel.h"
#import "FourShopCell.h"
#import "MoreShopContentViewController.h"
#import "MoreTalkViewController.h"
#import "SDPhotoBrowser.h"
#import <UIButton+LXMImagePosition.h>
#import "MyCenterViewController.h"
#import "RequestMerchantDetail.h"
#import "RequestMerchantDetailModel.h"
#import "RequestCollectMerchant.h"
#import "RequestMerchantGoodsList.h"
#import "RequestMerchantGoodsListModel.h"
#import "RequestMerchantListModel.h"
#import "RequestMerchantCouponList.h"
#import "RequestMerchantCouponListModel.h"
#import "CouponMessageViewController.h"
#import "RequestMerchantCommentList.h"
#import "RequestMerchantCommentListModel.h"
#import "MoreCouponViewController.h"
#import "RequestAgreementLinksModel.h"
#define Bounds [UIScreen mainScreen].bounds
#define ImageWidth (Bounds.size.width - 70)/3
#define ImageHeight (ImageWidth)*3/5
@interface ShopViewController ()<UITableViewDelegate, UITableViewDataSource, ThirdShopCellDelegate, CouponViewDelegate, SDPhotoBrowserDelegate, UIActionSheetDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)MerchantModel *merchantModel;
@property (nonatomic, strong) RequestMerchantDetailModel *shopModel;
//存放展示组图的数组
@property (nonatomic, strong) NSMutableArray *pictureArr;
//展示组图的中介
@property (nonatomic, strong) UIImageView *showImage;
@property (nonatomic, strong) NSNumber *isCollect;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NSMutableArray *couponArr;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *talkArr;
@property (nonatomic, copy) NSString *allTalkCount;
@property (nonatomic, strong) CouponView *couponView;
@property (nonatomic, strong) UILabel *collectLabel;
@end

@implementation ShopViewController
- (NSMutableArray *)talkArr {
    if (!_talkArr) {
        self.talkArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _talkArr;
}
- (NSMutableArray *)couponArr {
    if (!_couponArr) {
        self.couponArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _couponArr;
}
- (NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        self.goodsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _goodsArr;
}

- (NSMutableArray *)pictureArr {
    if (!_pictureArr) {
        self.pictureArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _pictureArr;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithArray:[FakeData getMerchantData]];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self showBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getHeaderData];
//    [self creatrTableView];
//    [self createShareBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCouponAction:) name:@"领取成功" object:nil];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)getCouponAction:(NSNotification *)sender {
    RequestMerchantCouponList *list = [[RequestMerchantCouponList alloc] init];
    list.merchantId = self.merchantId;
    list.pageIndex = 1;
    list.pageCount = 15;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = list;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantCouponList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self.couponArr removeAllObjects];
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantCouponListModel *model = [RequestMerchantCouponListModel yy_modelWithDictionary:dic];
                [self.couponArr addObject:model];
            }
            for (id tempView in self.couponView.subviews) {
                [tempView removeFromSuperview];
            }
            [self.couponView createView:self.couponArr];
        }else {
           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
    }];

    OKLog(@"领取成功");
}

- (void)createShareBtn {
    UIButton *shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"btn_class_xiangqing_fenxiang"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    shareBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark - 分享
- (void)shareAction:(UIButton *)sender {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = [NSArray array];
    self.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestAgreementLinks" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestAgreementLinksModel *model = [RequestAgreementLinksModel yy_modelWithJSON:baseRes.data];
            weakSelf. view.userInteractionEnabled = YES;
            [[DWHelper shareHelper] UMShareWithController:self WithText:model.shareTitle WithPictureUrl:model.shareImage WithContentUrl:model.shareLink];
        }else {
            weakSelf. view.userInteractionEnabled = YES;

           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        weakSelf. view.userInteractionEnabled = YES;

    }];

}


- (void)creatrTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Bounds.size.width, Bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ShopViewCell class] forCellReuseIdentifier:@"firstShopCell"];
    [self.tableView registerClass:[SecondShopCell class] forCellReuseIdentifier:@"secondShopCell"];
    [self.tableView registerClass:[ThirdShopCell class] forCellReuseIdentifier:@"thirdShopCell"];
    [self.tableView registerClass:[FootMoreCell class] forCellReuseIdentifier:@"footMoreCell"];
    [self.tableView registerClass:[CommentMoreCell class] forCellReuseIdentifier:@"commentMoreCell"];
    [self.tableView registerClass:[FourShopCell class] forCellReuseIdentifier:@"fourShopCell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    [self createHeaderView:self.shopModel];
    
}

- (void)createHeaderView:(RequestMerchantDetailModel *)model {

    self.headerView = [UIView new];
    
    if (self.couponArr.count == 0) {
        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2+106 + 25 - 3);
    }else if (self.couponArr.count <4) {
        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2+106 + ImageHeight +50 - 3);
    }else if (self.couponArr.count == 6){
        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2+106 + 15 + ImageHeight*2+50 - 3);
    }else {
        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2+106 + 15 + ImageHeight*2+80 - 3);
    }
//    else if (self.couponArr.count > 6 && self.couponArr.count < 10){
//        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2+106 + 15 + ImageHeight*3+25);
//    }else if (self.couponArr.count > 8 && self.couponArr.count < 13){
//        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2+106 + 15 + ImageHeight*4+25);
//    }else {
//        self.headerView.frame = CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2+106 + 15 + ImageHeight*5+25);
//    }
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    //图片
    UIImageView *pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Bounds.size.width, Bounds.size.width/5*2)];
    [pictureView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    [self.headerView addSubview:pictureView];
    
    //组图
    self.showImage = [UIImageView new];
    self.showImage.frame = CGRectMake(-10, -10, 1, 1);
    [self.headerView addSubview:self.showImage];
    UIButton *showImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSLog(@"%lu", (unsigned long)model.images.count);
    [showImageBtn setTitle:[NSString stringWithFormat:@"%lu张", (unsigned long)model.images.count] forState:UIControlStateNormal];
    [showImageBtn setImage:[UIImage imageNamed:@"icon_class_banner_zhaopian"] forState:UIControlStateNormal];
    if (model.images.count == 0) {
        
    }else {
        [showImageBtn addTarget:self action:@selector(showImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    showImageBtn.alpha = 0.8;
    showImageBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [showImageBtn setImagePosition:LXMImagePositionTop spacing:0];
    showImageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    showImageBtn.backgroundColor = [UIColor blackColor];
    showImageBtn.layer.masksToBounds = YES;
    showImageBtn.layer.cornerRadius = 35/2;
    [self.headerView addSubview:showImageBtn];
    [showImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(pictureView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    //店名
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = model.merchantName;
    [self.headerView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pictureView.mas_bottom).with.offset(5);
        make.left.mas_equalTo(pictureView.mas_left).with.offset(10);
        make.height.mas_equalTo(@(30));
        make.width.mas_equalTo(@(Bounds.size.width/2));
    }];
    //星星评价
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pictureView.frame)+35, Bounds.size.width/5, 15) ];
    [starRateView setNumberOfStarts:5];
    int star = [model.star intValue];
    CGFloat subStar = [model.star floatValue] -star;
    if (subStar<0.25) {
      starRateView.scorePercent = star*0.2;
        
    }else if(subStar>0.75){
        starRateView.scorePercent = (star+1)*0.2;
    }else{
       starRateView.scorePercent = (star+0.5)*0.2;
        
    }

    //starRateView.scorePercent = [model.star floatValue] * 0.2;
    starRateView.hasAnimation = NO;
    starRateView.userInteractionEnabled = NO;
    [self.headerView addSubview:starRateView];
    
    //收藏
    self.collectLabel = [UILabel new];
    self.collectLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.collectLabel.font = [UIFont systemFontOfSize:13];
    self.collectLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.collectLabel];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([model.isCollect integerValue] == 1) {
        self.isCollect = @(1);
        [collectBtn setImage:[UIImage imageNamed:@"btn_class_xiangqing_shoucang_press"] forState:UIControlStateNormal];
        self.collectLabel.text = @"已收藏";
    }else {
        self.isCollect = @(0);
        [collectBtn setImage:[UIImage imageNamed:@"btn_class_xiangqing_shoucang_normal"] forState:UIControlStateNormal];
        self.collectLabel.text = @"收藏";
    }
    collectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pictureView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.collectLabel);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(20));
    }];
    [self.collectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).with.offset(-5);
        make.top.mas_equalTo(collectBtn.mas_bottom);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(50));
    }];
    //热度
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(starRateView.frame)+5, Bounds.size.width/5, 20)];
    hotLabel.textColor = [UIColor colorWithHexString:@"#ff9712"];
    hotLabel.text = [NSString stringWithFormat:@"热度:%@", model.hotValue];

    hotLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    hotLabel.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:hotLabel];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(hotLabel.frame)+5, Bounds.size.width-20, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.headerView addSubview:lineView];
    
    UIImageView *adressPicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+12, 20, 20)];
    adressPicture.image = [UIImage imageNamed:@"btn_class_xiangqing_gps"];
    adressPicture.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerView addSubview:adressPicture];

    UILabel *adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(lineView.frame)+3, Bounds.size.width - 70, 40)];
    adressLabel.font = [UIFont systemFontOfSize:13];
    adressLabel.numberOfLines =2;
   // adressLabel.backgroundColor= [UIColor redColor];
    adressLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapAction:)];
    [adressLabel addGestureRecognizer:mapTap];
    adressLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    adressLabel.text = model.address;
    [self.headerView addSubview:adressLabel];
    //电话
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setImage:[UIImage imageNamed:@"btn_class_xiangqing_call"] forState:UIControlStateNormal];
    phoneBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [phoneBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(12);
        make.right.mas_equalTo(self.headerView.mas_right).with.offset(-20);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(20));
    }];
    
    
    self.couponView = [CouponView new];
    if (self.couponArr.count == 0) {
        self.couponView.frame = CGRectMake(0, CGRectGetMaxY(adressLabel.frame)+2, Bounds.size.width, 0);
    }else if (self.couponArr.count < 4) {
        self.couponView.frame = CGRectMake(0, CGRectGetMaxY(adressLabel.frame)+2, Bounds.size.width, 15+ImageHeight);
    }else {
        self.couponView.frame = CGRectMake(0, CGRectGetMaxY(adressLabel.frame)+2, Bounds.size.width, 25+2*(ImageHeight + 2.5));
    }
//    else if (self.couponArr.count > 6 && self.couponArr.count < 10) {
//        couponView.frame = CGRectMake(0, CGRectGetMaxY(adressLabel.frame)+2, Bounds.size.width, 25+3*(ImageHeight + 5));
//    }else if (self.couponArr.count > 9 && self.couponArr.count < 13){
//        couponView.frame = CGRectMake(0, CGRectGetMaxY(adressLabel.frame)+2, Bounds.size.width, 25+4*(ImageHeight + 5));
//    }else {
//        couponView.frame = CGRectMake(0, CGRectGetMaxY(adressLabel.frame)+2, Bounds.size.width, 25+5*(ImageHeight + 5));
//    }
    [self.couponView createView:self.couponArr];
    self.couponView.delegate = self;
    [self.headerView addSubview:self.couponView];
    self.couponView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.tableView reloadData];
    if (self.couponArr.count > 6) {
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setTitle:@"更多优惠券" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreBtn addTarget:self action:@selector(moreCouponeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.couponView.mas_bottom);
            make.height.mas_equalTo(@(30));
        }];
    }
}
- (void)moreCouponeAction:(UIButton *)sender {
    MoreCouponViewController *moreCoupon = [[MoreCouponViewController alloc] init];
    moreCoupon.merchantId = self.merchantId;
    moreCoupon.title = self.title;
    [self.navigationController pushViewController:moreCoupon animated:YES];
    
}
#pragma mark - 网络请求
- (void)getHeaderData {
    [self showProgress];
    RequestMerchantDetail *detail = [[RequestMerchantDetail alloc] init];
    detail.merchantId = self.merchantId;
    detail.lat = [AuthenticationModel getlatitude];
    detail.lng = [AuthenticationModel getlongitude];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = detail;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantDetail" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        [self hideProgress];
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.shopModel = [RequestMerchantDetailModel yy_modelWithJSON:baseRes.data];
            self.title = self.shopModel.merchantName;
            for (NSDictionary *dic in self.shopModel.images) {
                [self.pictureArr addObject:dic[@"originUrl"]];
            }
        }else {
            [self hideProgress];
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self getCouponListData:self.shopModel];
        
    } faild:^(id error) {
       [self hideProgress];
    }];
}

- (void)getTalkData {
    RequestMerchantCommentList *talkList = [[RequestMerchantCommentList alloc] init];
    talkList.pageCount = 10;
    talkList.pageIndex = 1;
    talkList.merchantId = self.merchantId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.data = talkList;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantCommentList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSDictionary *data = baseRes.data;
        NSDictionary *datalist = data[@"datalist"];
        self.allTalkCount = data[@"totalCount"];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in datalist) {
                RequestMerchantCommentListModel *talkModel = [RequestMerchantCommentListModel yy_modelWithDictionary:dic];
                [self.talkArr addObject:talkModel];
            }
        }else {
           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self hideProgress];
        [self creatrTableView];
        [self createShareBtn];
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}

- (void)getGoodsData:(NSString *)merchantId {
    RequestMerchantGoodsList *goodsList = [[RequestMerchantGoodsList alloc] init];
    goodsList.pageIndex = 1;
    goodsList.pageCount = 4;
    goodsList.merchantId = self.merchantId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.data = goodsList;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantGoodsList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantGoodsListModel *model = [RequestMerchantGoodsListModel yy_modelWithDictionary:dic];
                [self.goodsArr addObject:model];
            }
        }else {
           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self getTalkData];
//        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}
- (void)getCouponListData:(RequestMerchantDetailModel *)model {
    RequestMerchantCouponList *list = [[RequestMerchantCouponList alloc] init];
    list.merchantId = self.merchantId;
    list.pageIndex = 1;
    list.pageCount = 15;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = list;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantCouponList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestMerchantCouponListModel *model = [RequestMerchantCouponListModel yy_modelWithDictionary:dic];
                [self.couponArr addObject:model];
            }
        }else {
            [self showToast:baseRes.msg];
        }
        [self getGoodsData:self.shopModel.merchantId];
    } faild:^(id error) {

    }];
    
}

#pragma mark - 打开地图导航
- (void)mapAction:(UITapGestureRecognizer *)sender {

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度地图",@"高德地图", nil];
    [sheet showInView:self.view];
    
    

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
        DWHelper *helper = [DWHelper shareHelper];
        CLLocationCoordinate2D startLocation = helper.coordinate;
    
    if (buttonIndex == 0) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
            NSString *name = self.shopModel.address;
            CLLocationCoordinate2D Coordinate ;
            Coordinate.latitude = [self.shopModel.lat doubleValue];
            Coordinate.longitude = [self.shopModel.lng doubleValue];
            CLLocationCoordinate2D Coordinate2D = [self BD09FromGCJ02:Coordinate];
            
                    NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",startLocation.latitude, startLocation.longitude,  Coordinate2D.latitude, Coordinate2D.longitude, name];
           // NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",startLocation.latitude, startLocation.longitude,  [self.shopModel.lat doubleValue], [self.shopModel.lng doubleValue], name];
            [self openMap:urlString];
        }else {
            [self sheetAction:@"百度地图"];
        }
    }else if( buttonIndex == 1) {
         //style  导航方式(0 速度快; 1 费用少; 2 路程短; 3 不走高速；4 躲避拥堵；5 不走高速且避免收费；6 不走高速且躲避拥堵；7 躲避收费和拥堵；8 不走高速躲避收费和拥堵)
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
           NSString *name = self.shopModel.address;
                    NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",name, [self.shopModel.lat doubleValue], [self.shopModel.lng doubleValue]];
                    [self openMap:urlString];
        }else {
            [self sheetAction:@"高德地图"];
        }
    }
}


// 高德坐标转百度坐标
- (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

- (void)sheetAction:(NSString *)title {
    UIAlertView *alertController = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您还未安装%@客户端,请安装", title] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertController show];

}
- (void)openMap:(NSString *)urlString {
    NSString *string = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - 展示组图
- (void)showImageAction:(UIButton *)sender {
    OKLog(@"展示组图");
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.showImage.superview; // 原图的父控件
    browser.imageCount = self.pictureArr.count; // 图片总数
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}
#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{   [self.showImage sd_setImageWithURL:[NSURL URLWithString:self.pictureArr[index]]];
    return self.showImage.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
     return self.pictureArr[index];
}

#pragma mark - 点击头像进入个人中心
- (void)touchImage:(id)sender {
    OKLog(@"进入个人主页");
}

#pragma mark - 优惠券
- (void)selectedCoupon:(NSInteger)num withButton:(UIButton *)btn {
    OKLog(@"领取了第%ld张优惠券", (long)num);
    if ([self isLogin]) {
        CouponMessageViewController *coupM = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CouponMessageViewController"];
        coupM.title = self.title;
        coupM.iconUrlStr=   self.shopModel.iconUrl;
        coupM.model = self.couponArr[num];
        __weak ShopViewController *weakSelf = self;
        coupM.balckBlock = ^(NSString *str) {
//            [weakSelf getCouponListData:weakSelf.shopModel];
        };
        [self.navigationController pushViewController:coupM animated:YES];
    }else {
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
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

#pragma mark - 收藏事件
- (void)collectAction:(UIButton *)sender {
    OKLog(@"点击收藏");
    if ([self isLogin]) {
        if ([self.isCollect integerValue] == 1) {
            [self collectWithType:2 withBtn:sender];
        }else {
            [self collectWithType:1 withBtn:sender];
        }
    }else {
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
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

- (void)collectWithType:(NSInteger)type withBtn:(UIButton *)sender{
    RequestCollectMerchant *merchant = [[RequestCollectMerchant alloc] init];
    merchant.type = type;
    NSLog(@"%ld", (long)type);
    merchant.merchantId = self.shopModel.merchantId;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[merchant yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestCollectMerchant" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            NSDictionary *dic = baseRes.data;
            NSNumber *isCollect = dic[@"isCollect"];
            if ([isCollect integerValue] == 1) {
                self.isCollect = @(1);
                [sender setImage:[UIImage imageNamed:@"btn_class_xiangqing_shoucang_press"] forState:UIControlStateNormal];
                self.collectLabel.text = @"已收藏";
            }else {
                self.isCollect = @(0);
                [sender setImage:[UIImage imageNamed:@"btn_class_xiangqing_shoucang_normal"] forState:UIControlStateNormal];
                self.collectLabel.text = @"收藏";
            }
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
       
    }];
}

#pragma mark - 打电话
- (void)phoneAction:(UIButton *)sender {
    
    [self alertWithTitle:@"温馨提示" message:@"是否拨打商户电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.shopModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];


}

- (void)callPhone:(NSString *)phoneNumber {
    NSString *phoneUrl = [NSString stringWithFormat:@"tel://%@", phoneNumber];//tel打电话 sms发信息
    //进行拨号操作（该拨号方式苹果不允许使用）
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
    //网页拨号
    //创建网页对象
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    //利用网页对象实现拨号操作
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneUrl]]];
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return 30;
        }else {
            return 80;
        }
    }else if (indexPath.section == 1) {
        CGFloat height = [self.shopModel.content getTextHeightWithFont:[UIFont systemFontOfSize:12] withMaxWith:Bounds.size.width-20];
        return 83 + height;
    }else if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            return 30;
        }
        RequestMerchantCommentListModel *talkModel = self.talkArr[indexPath.row];
        CGFloat textHeight = [talkModel.content getTextHeightWithFont:[UIFont systemFontOfSize:12] withMaxWith:Width-20];
        if (talkModel.images.count == 0) {
            return 40 + textHeight;
        }else {
            return 40 + textHeight + (Bounds.size.width - 40)/3;
        }
        
//        return (Bounds.size.width - 40)/3 * 1 +130;//动态设置 cell的高度(判断 文本高度 和展示图片的个数 *3是几行图片)
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row < 3) {
            RequestMerchantGoodsListModel *goodsModel = [self.goodsArr objectAtIndex:indexPath.row];
            ShopContentViewController *shopController = [[ShopContentViewController alloc] init];
            shopController.shopModel = self.shopModel;
            shopController.goodsId = goodsModel.goodsId;
            shopController.title = @"套餐详情";
            [self.navigationController pushViewController: shopController animated:YES];
        }else {
            MoreShopContentViewController *moreController = [[MoreShopContentViewController alloc] init];
            moreController.merchantId = self.shopModel.merchantId;
            moreController.shopModel = self.shopModel;
            moreController.title = @"套餐";
            [self.navigationController pushViewController:moreController animated:YES];
        }
       
    }else if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            MoreTalkViewController *moreTalkController = [[MoreTalkViewController alloc] init];
            moreTalkController.merchantId = self.merchantId;
            moreTalkController.title = @"全部评论";
            [self.navigationController pushViewController:moreTalkController animated:YES];
        }
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.goodsArr.count < 3) {
            return self.goodsArr.count;
        }else {
             return 4;
        }
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        if (self.talkArr.count > 3) {
            return 4;
        }else {
            return self.talkArr.count;
        }
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        SecondShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondShopCell" forIndexPath:indexPath];
        [cell cellGetData:self.shopModel];
        return cell;
    }else if (indexPath.section == 2){
        RequestMerchantCommentListModel *talkModel = self.talkArr[indexPath.row];
        if (indexPath.row == 3 ) {
            CommentMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentMoreCell" forIndexPath:indexPath];
            cell.numberLabel.text = [NSString stringWithFormat:@"%@条评论", self.allTalkCount];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else {
            if (talkModel.images.count == 0) {
                FourShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourShopCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell cellGetDataWith:talkModel withController:self];
                return cell;
            }else {
                ThirdShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdShopCell" forIndexPath:indexPath];
                for (UIImageView *view in cell.imagesBtn) {
                    view.image = [UIImage imageNamed:@""];
                }
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.pictureArray removeAllObjects];
                [cell.pictureArray addObjectsFromArray:talkModel.images];
                [cell talkImageData:nil];
                [cell cellGetDataWith:talkModel withController:self];
                return cell;
            }
        }
    }else {
        if (indexPath.row > 2) {
            FootMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"footMoreCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            OKLog(@"查看更多套餐");
            return cell;
        }else {
            ShopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstShopCell" forIndexPath:indexPath];
            RequestMerchantGoodsListModel *goodsModel = [self.goodsArr objectAtIndex:indexPath.row];
            [cell cellGetData:goodsModel WithController:self];
            return cell;
        }
    }
    return nil;
//    cell.textLabel.text = @"商铺详情";
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataSource:(RequestHomePageModel *)model{
//    self.title = model.merchantId;
}



#pragma mark - 点击评论上图片的代理方法
- (void)touchPhotoImage:(id)sender {
//    if ([self isLogin]) {
//        MyCenterViewController *myCenterController = [[MyCenterViewController alloc] init];
//        [self.navigationController pushViewController:myCenterController animated:YES];
//    }else {
//        LoginController *loginController = [[LoginController alloc] init];
//        [self.navigationController pushViewController:loginController animated:YES];
//    }
//    OKLog(@"点击头像");
}

- (void)dealloc {
    NSLog(@"一级释放");
}

@end
