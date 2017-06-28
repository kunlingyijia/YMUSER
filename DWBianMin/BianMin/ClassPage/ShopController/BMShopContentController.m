//
//  BMShopContentController.m
//  BianMin
//
//  Created by kkk on 16/8/19.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BMShopContentController.h"
#import "RequestMerchantDetail.h"
#import "RequestMerchantDetailModel.h"
#import "RequestCollectMerchant.h"
#import "RequestBminserviceListModel.h"
#import "RequestBminserviceList.h"
#import "ComitBmOrederViewController.h"
#import "RequestAgreementLinksModel.h"
#import <UIButton+LXMImagePosition.h>
#import "SDPhotoBrowser.h"
@interface BMShopContentController ()<SDPhotoBrowserDelegate>
///商家详情
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) RequestMerchantDetailModel *shopModel;
@property (nonatomic, strong) NSMutableArray *pictureArr;
@property (nonatomic, strong) NSNumber *isCollect;
@property (nonatomic, strong) UILabel *collectionLabel;
@property (nonatomic, strong) NSMutableArray *orderArr;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong)UIImageView *showImage;
@end

@implementation BMShopContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    
    self.scrollerView = [UIScrollView new];
    self.scrollerView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    self.container = [UIView new];
    self.container.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollerView);
        make.width.equalTo(self.scrollerView);
    }];
    [self getHeaderData];
    [self createShareBtn];
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
            weakSelf.view.userInteractionEnabled = YES;
            [[DWHelper shareHelper] UMShareWithController:weakSelf WithText:model.shareTitle WithPictureUrl:model.shareImage WithContentUrl:model.shareLink];
        }else {
            weakSelf.view.userInteractionEnabled = YES;

            [weakSelf showToast:baseRes.msg];

//            [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        weakSelf.view.userInteractionEnabled = YES;

    }];
    
}



- (void)createView {
    self.showImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*2/5)];
    [self.container addSubview:_showImage];
    _showImage.contentMode = UIViewContentModeScaleAspectFill;
    _showImage.clipsToBounds = YES;
    [self loadImageWithView:_showImage urlStr:self.shopModel.iconUrl];
    
    UIButton *showImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showImageBtn.frame = CGRectMake(Width-35-10, Width*2/5-35-10, 35, 35);
    [showImageBtn setTitle:[NSString stringWithFormat:@"%lu张", (unsigned long)self.shopModel.images.count] forState:UIControlStateNormal];
    [showImageBtn setImage:[UIImage imageNamed:@"icon_class_banner_zhaopian"] forState:UIControlStateNormal];
    if (self.shopModel.images.count == 0) {
        
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
    [self.container addSubview:showImageBtn];
    
    
    
    
    UILabel *shopName = [UILabel new];
    shopName.text = self.shopModel.merchantName;
    shopName.textColor = [UIColor colorWithHexString:kTitleColor];
    shopName.font = [UIFont systemFontOfSize:14];
    [self.container addSubview:shopName];
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_showImage).with.offset(10);
        make.top.equalTo(_showImage.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(@(30));
    }];
    UILabel *phoneNum = [UILabel new];
   // phoneNum.text = self.shopModel.mobile;
    phoneNum.textColor = [UIColor colorWithHexString:kTitleColor];
    phoneNum.font = [UIFont systemFontOfSize:14];
    [self.container addSubview:phoneNum];
    [phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.top.equalTo(shopName.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(@(30));
    }];
    
    UIImageView *collectionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_xiangqing_shoucang_normal"]];
    collectionImage.userInteractionEnabled = YES;
    collectionImage.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionAction:)];
    [collectionImage addGestureRecognizer:tap];
    collectionImage.clipsToBounds = YES;
    [self.container addSubview:collectionImage];
    [collectionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showImage.mas_bottom).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.collectionLabel = [UILabel new];
    self.collectionLabel.text = @"收藏";
    self.collectionLabel.textAlignment = NSTextAlignmentCenter;
    self.collectionLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    self.collectionLabel.font = [UIFont systemFontOfSize:14];
    [self.container addSubview:self.collectionLabel];
    [self.collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(collectionImage);
        make.top.equalTo(collectionImage.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    if ([self.shopModel.isCollect integerValue] == 1) {
        self.isCollect = @(1);
        collectionImage.image = [UIImage imageNamed:@"btn_class_xiangqing_shoucang_press"];
        self.collectionLabel.text = @"已收藏";
    }else {
        self.isCollect = @(0);
        collectionImage.image = [UIImage imageNamed:@"btn_class_xiangqing_shoucang_normal"];
        self.collectionLabel.text = @"收藏";
    }
    
    
    UIView *firstLine = [UIView new];
    firstLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.container addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNum.mas_bottom).with.offset(5);
        make.right.equalTo(self.container);
        make.left.equalTo(self.container).with.offset(10);
        make.height.mas_equalTo(@(1));
    }];
    
    UIImageView *adressImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_chuxing_zhongian"]];
    adressImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.container addSubview:adressImage];
    [adressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine).with.offset(10);
        make.left.equalTo(self.container).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIImageView *callImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_xiangqing_call"]];
    callImage.contentMode = UIViewContentModeCenter;
    UITapGestureRecognizer *callTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callAction:)];
    callImage.userInteractionEnabled = YES;
    [callImage addGestureRecognizer:callTap];
    [self.container addSubview:callImage];
    [callImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressImage);
        make.right.equalTo(self.container).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UILabel *adressLabel = [UILabel new];
    adressLabel.text = self.shopModel.address;
    adressLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    adressLabel.font = [UIFont systemFontOfSize:13];
    adressLabel.numberOfLines = 2;
    adressLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *adressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapAction:)];
    [adressLabel addGestureRecognizer:adressTap];
    
    [self.container addSubview:adressLabel];
    [adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressImage);
        make.left.equalTo(adressImage.mas_right).with.offset(5);
        make.right.equalTo(callImage.mas_left).with.offset(-5);
        make.height.mas_equalTo(@(40));
       
    }];
    
    UIView *secondLine = [UIView new];
    secondLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.container addSubview:secondLine];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adressLabel.mas_bottom).with.offset(5);
        make.right.equalTo(self.container);
        make.left.equalTo(self.container).with.offset(10);
        make.height.mas_equalTo(@(1));
    }];
    
    UILabel *OpenTime = [UILabel new];
   
    OpenTime.textColor = [UIColor colorWithHexString:kTitleColor];
    OpenTime.font = [UIFont systemFontOfSize:14];
    OpenTime.text =[NSString stringWithFormat:@"营业时间: %@", self.shopModel.openTime];
    [self.container addSubview:OpenTime];
    
    [OpenTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLine.mas_bottom).with.offset(10);
        make.left.equalTo(self.container).with.offset(10);
        make.height.mas_equalTo(@(20));
    }];
    
    UILabel *messageShowLabel = [UILabel new];
    messageShowLabel.text = @"详情描述";
    messageShowLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    messageShowLabel.font = [UIFont systemFontOfSize:14];
    [self.container addSubview:messageShowLabel];
    [messageShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(OpenTime.mas_bottom).with.offset(10);
        make.left.equalTo(self.container).with.offset(10);
        make.height.mas_equalTo(@(20));
    }];
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.text = self.shopModel.content;
    CGFloat height = [self.shopModel.content getTextHeightWithFont:[UIFont systemFontOfSize:13] withMaxWith:Width - 20];
    messageLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    messageLabel.font = [UIFont systemFontOfSize:13];
    messageLabel.numberOfLines = 0;
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.container addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageShowLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.container).with.offset(10);
        make.right.equalTo(self.container).with.offset(-10);
        make.height.mas_equalTo(@(height));
    }];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.container addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageLabel.mas_bottom).with.offset(10);
        make.right.left.equalTo(self.container);
    }];
    
    UILabel *moneyLabel = [UILabel new];
    moneyLabel.text = @"收费标准";
    moneyLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(10);
        make.left.equalTo(self.bgView).with.offset(10);
        make.right.equalTo(self.bgView).with.offset(-10);
        make.height.mas_equalTo(@(30));
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"预约" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self.bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.container.mas_bottom).with.offset(-10);
        make.right.equalTo(self.container).with.offset(-20);
        make.left.equalTo(self.container).with.offset(20);
        make.height.mas_equalTo(@(40));
    }];
    [self getOrderDataList];

}



- (void)createOrederList {
    CGFloat viewWidth = (Width - 50)/2;
    NSInteger count = 0;
    NSInteger arrCount = self.orderArr.count/2;
    NSInteger indexIndex = self.orderArr.count%2;
    NSInteger maxI = 0;
    if (self.orderArr.count == 0) {
        maxI = 0;
        self.container.frame = CGRectMake(0, 0, Width, Height-64);
    }else if (self.orderArr.count < 3) {
        maxI = 1;
    }else if (indexIndex == 0) {
        maxI = arrCount;
    }else if (indexIndex != 0) {
        maxI = arrCount + 1;
    }
    for (int i = 0; i< maxI; i++) {
        for (int j = 0; j < 2; j++) {
            UIView *orderV = [self getOrderView:count];
            orderV.frame = CGRectMake(20 + j*(viewWidth+10), 40 + i * (viewWidth/2 + 10), viewWidth, viewWidth/2);
            count = count + 1;
            if (i == maxI-1) {
                if (indexIndex == 0 && j == 1) {
                    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(orderV.mas_bottom).with.offset(75);
                    }];
                    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.bottom.equalTo(self.bgView.mas_bottom);
                    }];
                    break;
                }else if (indexIndex != 0 && j == 0) {
                    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(orderV.mas_bottom).with.offset(75);
                    }];
                    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.bgView.mas_bottom);
                    }];
                    break;
                }
            }
        }
    }
}

- (UIView *)getOrderView:(NSInteger)count {
    RequestBminserviceListModel *model = self.orderArr[count];
    UIView *orderV = [[UIView alloc] init];
    orderV.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:orderV];
    UILabel *price = [UILabel new];
    price.textAlignment = NSTextAlignmentCenter;
    price.text = [NSString stringWithFormat:@"¥%.2f", model.price];
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    [orderV addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orderV);
        make.left.equalTo(orderV);
        make.bottom.equalTo(orderV);
        make.height.mas_equalTo(@(20));
    }];

    
    UILabel *nameL = [UILabel new];
    nameL.text = model.serviceName;
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.textColor = [UIColor colorWithHexString:kTitleColor];
    nameL.numberOfLines =2;
    nameL.font = [UIFont systemFontOfSize:12];
    [orderV addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderV.mas_top).offset(5);
        make.left.equalTo(orderV.mas_left).offset(5);
        make.right.equalTo(orderV.mas_right).offset(-5);
        make.bottom.equalTo(price.mas_top);
    }];
//    orderV.tag = (count + 1) * 100;
//    cancelBtn.tag = (count + 1) * 100 +1;
    return orderV;
}

- (void)commitAction:(UIButton *)sender {
    if ([self isLogin]) {
        ComitBmOrederViewController *commitBm = [[ComitBmOrederViewController alloc] initWithNibName:@"ComitBmOrederViewController" bundle:nil];
        commitBm.orderArr = [NSMutableArray arrayWithArray:self.orderArr];
        commitBm.merchantId = self.merchantId;
        [self.navigationController pushViewController:commitBm animated:YES];
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

#pragma mark - 自定义方法
//地图
- (void)mapAction:(UITapGestureRecognizer *)sender {
        DWHelper *helper = [DWHelper shareHelper];
        CLLocationCoordinate2D startLocation = helper.coordinate;
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择地图" preferredStyle:UIAlertControllerStyleActionSheet];
    
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *name = @"";
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",
                                       startLocation.latitude, startLocation.longitude,  [self.shopModel.lat floatValue], [self.shopModel.lng floatValue], name];
                [self openMap:urlString];
            }else {
                [self sheetAction:@"百度"];
            }
        }]];
    
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *name = @"东吴科技";
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                                       name, 26.083490, 119.318280];
    
                [self openMap:urlString];
            }else {
                [self sheetAction:@"高德"];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
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

//打电话
- (void)callAction:(UITapGestureRecognizer *)sender {
    
    [self alertWithTitle:@"温馨提示" message:@"是否拨打商户电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.shopModel.mobile];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];


}



- (void)collectionAction:(UITapGestureRecognizer *)sender {
    UIImageView *imageV = (UIImageView *)sender.view;
    if ([self isLogin]) {
        if ([self.isCollect integerValue] == 1) {
            [self collectWithType:2 withBtn:imageV];
        }else {
            [self collectWithType:1 withBtn:imageV];
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
- (void)collectWithType:(NSInteger)type withBtn:(UIImageView *)sender{
    RequestCollectMerchant *merchant = [[RequestCollectMerchant alloc] init];
    merchant.type = type;
    merchant.merchantId = self.shopModel.merchantId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[merchant yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestCollectMerchant" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            NSDictionary *dic = baseRes.data;
            NSNumber *isCollect = dic[@"isCollect"];
            if ([isCollect integerValue] == 1) {
                self.isCollect = @(1);
                sender.image = [UIImage imageNamed:@"btn_class_xiangqing_shoucang_press"];
                self.collectionLabel.text = @"已收藏";
            }else {
                self.isCollect = @(0);
                sender.image = [UIImage imageNamed:@"btn_class_xiangqing_shoucang_normal"];
                self.collectionLabel.text = @"收藏";
            }
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}

#pragma mark - 网络请求
- (void)getHeaderData {
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
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.shopModel = [RequestMerchantDetailModel yy_modelWithJSON:baseRes.data];
            self.title = self.shopModel.merchantName;
            for (NSDictionary *dic in self.shopModel.images) {
                [self.pictureArr addObject:dic[@"originUrl"]];
            }
            [self createView];
        }else {
            [self showToast:baseRes.msg];

            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}
#pragma mark - 获取便民服务项目列表
- (void)getOrderDataList {
    RequestBminserviceList *orderList = [[RequestBminserviceList alloc] init];
    orderList.merchantId = self.shopModel.merchantId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.data = orderList;
    baseReq.encryptionType = RequestMD5;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Bmin/requestBminserviceList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                RequestBminserviceListModel *model = [RequestBminserviceListModel yy_modelWithDictionary:dic];
                [self.orderArr addObject:model];
            }
            [self createOrederList];
        }else {
            [self showToast:baseRes.msg];

           // [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}



- (NSMutableArray *)pictureArr {
    if (!_pictureArr) {
        self.pictureArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _pictureArr;
}
- (NSMutableArray *)orderArr {
    if (!_orderArr) {
        self.orderArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _orderArr;
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
