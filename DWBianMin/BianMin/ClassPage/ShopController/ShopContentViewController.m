//
//  ShopContentViewController.m
//  BianMin
//
//  Created by kkk on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ShopContentViewController.h"
#import "CWStarRateView.h"
#import "GoodsCell.h"
#import "GoodsHeaderView.h"
#import "FourShopCell.h"
#import "GoodsMessageCell.h"
#import "CommitOrderController.h"
#import "MyCenterViewController.h"
#import "RequestGoodsInfo.h"
#import "RequestMerchantGoodsListModel.h"
#import "RequestGoodsInfoModel.h"
#import "RequestMerchantDetailModel.h"
#import "ThirdShopCell.h"
#import "RequestMerchantCommentList.h"
#import "CommentMoreCell.h"
#import "MoreTalkViewController.h"
#import <UIButton+LXMImagePosition.h>
#import "SDPhotoBrowser.h"
#import "SubmitTGOrderVC.h"
#define Space 10
#define PictureHeight Bounds.size.width/5*2
#define PriceHeight 30

@interface ShopContentViewController ()<UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong)UITableView *tableView;

//测试数据
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *talkArr;
@property (nonatomic, copy) NSString *allTalkCount;
@property (nonatomic, strong) GoodsHeaderView *headerView;
//展示组图的中介
@property (nonatomic, strong) UIImageView *showImage;
//@property (nonatomic, strong) RequestGoodsInfoModel *GoodsModel;
@end

@implementation ShopContentViewController

- (NSMutableArray *)talkArr {
    if (!_talkArr) {
        self.talkArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _talkArr;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithObjects:@"干锅",@"荤菜",@"素菜",@"主食", nil];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"套餐详情";
    self.navigationController.navigationBar.translucent = NO;
    [self showBackBtn];
    [self getTalkData];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[GoodsCell class] forCellReuseIdentifier:@"shopContentCell"];
    [self.tableView registerClass:[FourShopCell class] forCellReuseIdentifier:@"fourShopCell"];
    [self.tableView registerClass:[GoodsMessageCell class] forCellReuseIdentifier:@"goodsMessageCell"];
    [self.tableView registerClass:[ThirdShopCell class] forCellReuseIdentifier:@"thirdShopCell"];
    [self.tableView registerClass:[CommentMoreCell class] forCellReuseIdentifier:@"commentMoreCell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    [self createHeaderView];
}

- (void)getTalkData {
    [self showProgress];
    RequestMerchantCommentList *talkList = [[RequestMerchantCommentList alloc] init];
    talkList.pageCount = 10;
    talkList.pageIndex = 1;
    talkList.merchantId = self.shopModel.merchantId;
    talkList.goodsId = self.goodsId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.data = talkList;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantCommentList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            NSDictionary *data = baseRes.data;
            NSDictionary *datalist = data[@"datalist"];
            self.allTalkCount = data[@"totalCount"];
            for (NSDictionary *dic in datalist) {
                RequestMerchantCommentListModel *talkModel = [RequestMerchantCommentListModel yy_modelWithDictionary:dic];
                [self.talkArr addObject:talkModel];
            }
            [self getGoodsData];
        }else {
           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self.tableView reloadData];
    } faild:^(id error) {
        
    }];
}


- (void)createHeaderView {
    self.headerView = [[GoodsHeaderView alloc] initWithFrame:CGRectMake(0, 0, Bounds.size.width, PictureHeight + 275+20) withStar:self.model.star];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.firstPriceLabel.text = self.price;
    self.headerView.shopName.text = self.shopModel.merchantName;
    
    self.showImage = [UIImageView new];
    self.showImage.frame = CGRectMake(-10, -10, 1, 1);
    [self.headerView addSubview:self.showImage];
    [self loadImageWithView:self.headerView.pictureView urlStr:self.model.originUrl];
    
    self.headerView.pictureView.userInteractionEnabled = YES;
    UIButton *showImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showImageBtn.backgroundColor = [UIColor redColor];
    [showImageBtn setTitle:[NSString stringWithFormat:@"%lu张", (unsigned long)self.model.images.count] forState:UIControlStateNormal];
    [showImageBtn setImage:[UIImage imageNamed:@"icon_class_banner_zhaopian"] forState:UIControlStateNormal];
    if (self.model.images.count == 0) {
        showImageBtn.hidden = YES;
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
    [self.headerView.pictureView addSubview:showImageBtn];
    [showImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.headerView.pictureView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    NSString *priceStr = [NSString stringWithFormat:@"%.2f", self.model.discountedPrice];
    CGFloat priceWidth = [priceStr getSingleLineTextWidthWithFont:[UIFont systemFontOfSize:25] withMaxWith:Width];
    self.headerView.firstPriceLabel.text = [NSString stringWithFormat:@"%.2f", self.model.discountedPrice];
    self.headerView.firstPriceLabel.frame =  CGRectMake(20, CGRectGetMaxY(self.headerView.pictureView.frame)+10, priceWidth, PriceHeight);
    self.headerView.secondPriceLabel.text = [NSString stringWithFormat:@"门市价:%.2f", self.model.price];
    self.headerView.sellNumLabel.text = [NSString stringWithFormat:@" 已售%@", self.model.sales];
    self.headerView.shopAdressLabel.text = self.shopModel.address;
    self.headerView.goodsTalkLabel.text = [NSString stringWithFormat:@"%@人评价", self.model.commentCount];
    self.headerView.shopTalkLabel.text = [NSString stringWithFormat:@"%@条评价", self.allTalkCount];
    self.headerView.starRateNum = self.model.star;
    
    self.headerView.shopAdressLabel.userInteractionEnabled = YES;
    [self.headerView.gestAdress addTarget:self action:@selector(mapSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapSelectedAction:)];
//    [self.headerView.shopAdressLabel addGestureRecognizer:tap];
    
    
//    打电话
    __weak ShopContentViewController *weakSelf = self;
    self.headerView.phoneAction = ^(NSString *str) {
        if ([weakSelf isLogin]) {
                [weakSelf callPhoneAction];
        }else {
            LoginController *loginController = [[LoginController alloc] init];
            [weakSelf.navigationController pushViewController:loginController animated:YES];
//            LoginController *loginController = [[LoginController alloc] init];
//            DWNavigationController * Nav = [[DWNavigationController alloc]initWithRootViewController:loginController];
//            
//            CATransition *  ansition =[CATransition animation];
//            [ansition setDuration:0.3];
//            [ansition setType:kCAGravityRight];
//            [[[[UIApplication sharedApplication]keyWindow ]layer] addAnimation:ansition forKey:nil];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:Nav animated:YES completion:nil];
        }
    };
//    购买
    self.headerView.buyAction = ^(NSString *str) {
        if ([weakSelf isLogin]) {
//            CommitOrderController *commitOrderController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommitOrderController"];
//            commitOrderController.merchantId = weakSelf.shopModel.merchantId;
//            commitOrderController.goodsModel = weakSelf.model;
//            [weakSelf.navigationController pushViewController:commitOrderController animated:YES];
            
            
            //Push 跳转
            SubmitTGOrderVC * VC = [[SubmitTGOrderVC alloc]initWithNibName:@"SubmitTGOrderVC" bundle:nil];
            VC.merchantId = weakSelf.shopModel.merchantId;
            VC.goodsModel = weakSelf.model;
            [weakSelf.navigationController  pushViewController:VC animated:YES];

            
            
            
        }else {
            LoginController *loginController = [[LoginController alloc] init];
            [weakSelf.navigationController pushViewController:loginController animated:YES];
//            LoginController *loginController = [[LoginController alloc] init];
//            DWNavigationController * Nav = [[DWNavigationController alloc]initWithRootViewController:loginController];
//            
//            CATransition *  ansition =[CATransition animation];
//            [ansition setDuration:0.3];
//            [ansition setType:kCAGravityRight];
//            [[[[UIApplication sharedApplication]keyWindow ]layer] addAnimation:ansition forKey:nil];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:Nav animated:YES completion:nil];
        }
        
    };
    self.tableView.tableHeaderView = self.headerView;
}


- (void)callPhoneAction {
//    BaseRequest *baseReq = [[BaseRequest alloc] init];
//    baseReq.token = [AuthenticationModel getLoginToken];
//    baseReq.encryptionType = AES;
//    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
//    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestCallPlatform" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
//        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
//        if (baseRes.resultCode == 1) {
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在转接中..." preferredStyle:UIAlertControllerStyleAlert];
//            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//            [self presentViewController:alertC animated:YES completion:nil];
//        }else{
//            [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
//        }
//    } faild:^(id error) {
//        
//    }];
    [self alertWithTitle:@"温馨提示" message:@"是否拨打商户电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.shopModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];

//    [self alertWithTitle:@"温馨提示" message:@"拨打商户电话" OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
//        [self callPhone:self.shopModel.mobile];
//    } withCancel:^(UIAlertAction *cancelaction) {
//        
//    }];
//    [self alertWithTitle:nil message:nil OKWithTitle:@"拨打商户电话" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
//                [self callPhone:self.shopModel.mobile];
//    } withCancel:^(UIAlertAction *cancelaction) {
//        
//    }];
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertC addAction:[UIAlertAction actionWithTitle:@"拨打商户电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self callPhone:self.shopModel.mobile];
//    }]];
////    [alertC addAction:[UIAlertAction actionWithTitle:@"拨打平台客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////        [self callPhone:self.shopModel.kfmobile];
////    }]];
//    
//    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    [self presentViewController:alertC animated:YES completion:nil];
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



#pragma mark - 展示组图
- (void)showImageAction:(UIButton *)sender {
    OKLog(@"展示组图");
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.showImage.superview; // 原图的父控件
    browser.imageCount = self.model.images.count; // 图片总数
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSDictionary *dic = self.model.images[index];
    NSString *imageUrl = dic[@"originUrl"];
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    return self.showImage.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSDictionary *dic = self.model.images[index];
    NSString *imageUrl = dic[@"originUrl"];
    return [NSURL URLWithString:imageUrl];
}


#pragma  mark - 地图选择
- (void)mapSelectedAction:(UITapGestureRecognizer *)tap {
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
            [self openMap:urlString];
        }else {
            [self sheetAction:@"百度地图"];
        }
    }else if( buttonIndex == 1) {
         //style  导航方式(0 速度快; 1 费用少; 2 路程短; 3 不走高速；4 躲避拥堵；5 不走高速且避免收费；6 不走高速且躲避拥堵；7 躲避收费和拥堵；8 不走高速躲避收费和拥堵)
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
            NSString *name = self.shopModel.address;
            NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=2",name, [self.shopModel.lat floatValue], [self.shopModel.lng floatValue]];
            [self openMap:urlString];
        }else {
            [self sheetAction:@"高德地图"];
        }
    }
}
- (void)openMap:(NSString *)urlString {
    NSString *string = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    [[UIApplication sharedApplication] openURL:url];
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
#pragma mark - 网络请求
- (void)getGoodsData {
    RequestGoodsInfo *info = [[RequestGoodsInfo alloc] init];
    info.goodsId = self.goodsId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    baseReq.encryptionType = RequestMD5;
    baseReq.data = info;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestGoodsInfo" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.model = [RequestMerchantGoodsListModel yy_modelWithJSON:baseRes.data];
            [self loadImageWithView:self.headerView.pictureView urlStr:self.model.originUrl];
        }else {
          [self showToast:baseRes.msg];//   [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self hideProgress];
        [self createTableView];
        [self.tableView reloadData];
    } faild:^(id error) {
    
    }];
}

#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CGFloat textHeight = [self.model.useRule getTextHeightWithFont:[UIFont systemFontOfSize:14] withMaxWith:(Width/3*2.0)];
        return 10+160+textHeight;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            return 30;
        }else {
            RequestMerchantCommentListModel *talkModel = self.talkArr[indexPath.row];
            CGFloat textHeight = [talkModel.content getTextHeightWithFont:[UIFont systemFontOfSize:12] withMaxWith:Width-20];
            if (talkModel.images.count == 0) {
                return 40 + textHeight;
            }else {
                return 40 + textHeight + (Bounds.size.width - 40)/3;
            }
        }
    }
    return 28;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        MoreTalkViewController *moreTalkController = [[MoreTalkViewController alloc] init];
        moreTalkController.merchantId = self.shopModel.merchantId;
        moreTalkController.goodsID = self.model.goodsId;
        [self.navigationController pushViewController:moreTalkController animated:YES];
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
////    if (section == 4 || section == 5) {
////        return 10;
////    }
////    if (section == 0) {
////        return 60;
////    }
//    return 30;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
////    if (section == 4 || section == 5) {
////        return nil;
////    }
//    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
//    if (section == 0) {
//        UILabel *label = [UILabel new];
//        label.font = [UIFont systemFontOfSize:12];
//        label.backgroundColor = [UIColor whiteColor];
//        label.textColor = [UIColor colorWithHexString:kSubTitleColor];
//        label.text = @"  套餐";
//        [headerSectionView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headerSectionView.mas_top).with.offset(0);
//            make.left.right.equalTo(headerSectionView);
//            make.height.mas_equalTo(@(30));
//        }];
//        
//        UILabel *nameLabel = [UILabel new];
//        nameLabel.textAlignment = NSTextAlignmentCenter;
//        
//        nameLabel.text = self.dataArr[section];
//        nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
//        nameLabel.font = [UIFont systemFontOfSize:12];
//        nameLabel.backgroundColor = [UIColor colorWithHexString:@"#f4f5fa"];
//        [headerSectionView addSubview:nameLabel];
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(label.mas_bottom);
//            make.left.right.bottom.equalTo(headerSectionView);
//        }];
//    }else {
//        UILabel *nameLabel = [UILabel new];
//        nameLabel.textAlignment = NSTextAlignmentCenter;
//        nameLabel.text = self.dataArr[section];
//        nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
//        nameLabel.font = [UIFont systemFontOfSize:12];
//        nameLabel.backgroundColor = [UIColor colorWithHexString:@"#f4f5fa"];
//        [headerSectionView addSubview:nameLabel];
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.left.bottom.equalTo(headerSectionView);
//        }];
//    }
//    
//    
//    return headerSectionView;
//}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        if (self.talkArr.count < 3) {
            return self.talkArr.count;
        }else {
            return 4;
        }
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            CommentMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentMoreCell" forIndexPath:indexPath];
            cell.numberLabel.text = [NSString stringWithFormat:@"%@条评论", self.allTalkCount];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
           
        }else {
            RequestMerchantCommentListModel *talkModel = self.talkArr[indexPath.row];
            if (talkModel.images.count == 0) {
                FourShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourShopCell" forIndexPath:indexPath];
                [cell cellGetDataWith:talkModel withController:self];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //            cell.goMyCenterBlock = ^(NSString *str) {
                //                MyCenterViewController *myCenterController = [[MyCenterViewController alloc] init];
                //                [self.navigationController pushViewController:myCenterController animated:YES];
                //            };
                return cell;
            }else {
                ThirdShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdShopCell" forIndexPath:indexPath];
                //            cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.pictureArray removeAllObjects];
                [cell.pictureArray addObjectsFromArray:talkModel.images];
                [cell talkImageData:nil];
                [cell cellGetDataWith:talkModel withController:self];
                return cell;
            }

        }
        
    }else if (indexPath.section == 0){
        GoodsMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsMessageCell" forIndexPath:indexPath];
        cell.data.text = [NSString stringWithFormat:@"%@至%@", self.model.startTime, self.model.endTime];
        cell.useData.text = [NSString stringWithFormat:@"%@至%@", self.model.startuseTime, self.model.enduseTime];
        cell.useRule.text = self.model.useRule;
        return cell;
    }
    
//    else {
//        GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopContentCell" forIndexPath:indexPath];
//        if (indexPath.section == 0) {
//            cell.nameLabel.text = @"干锅菜";
//            cell.priceLabel.text = @"¥98";
//            cell.numLabel.text = @"1份";
//        }else if (indexPath.section == 1){
//            cell.nameLabel.text = @"培根";
//            cell.numLabel.text = @"5份";
//            cell.priceLabel.text = @"¥26";
//        }else if (indexPath.section == 2) {
//            cell.nameLabel.text = @"油麦菜";
//            cell.numLabel.text = @"3份";
//            cell.priceLabel.text = @"¥15";
//        }else {
//            cell.nameLabel.text = @"主食";
//            cell.numLabel.text = @"4份";
//            cell.priceLabel.text = @"¥30";
//        }
//        return cell;
//    }

    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"二级释放");
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
