//
//  AppDelegate.m
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AppDelegate.h"
#import "DWTabBarController.h"
#import "DWGuideViewController.h"
#import "ADViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "DWWebViewController.h"
#import "MobClick.h"
#import "WXApi.h"
#import "FMDatabaseUtils.h"
#import "DBRegionModel.h"
//#import <AMapLocationKit/AMapLocationKit.h>
#import "RequestHomePageAdList.h"
#import "RequestHomePageModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ShopViewController.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "PushMessageController.h"
#import "WebLoginController.h"
#import "RequestWallet.h"
#import "RequestWalletModel.h"
#import "RequestConfigModel.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "PublicMessageVC.h"
@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@property (nonatomic, strong) UIView *adView;

@property (nonatomic ,strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *logoArr;
@property (nonatomic, assign) NSInteger logoIndex;
@property (nonatomic, strong) DWTabBarController *dwTabBarController;
//展示活动图
@property (nonatomic ,strong) UIView *activeV;
@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *yiminL;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *webBtn;

@property(nonatomic,strong) NSDictionary * userInfo;
///pushAlias
@property (nonatomic, strong) NSString  *pushAlias ;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    DBRegionModel *model = [FMDatabaseUtils getRegionByRegionCode:@"350111"];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([self launchFirst]) { 
        DWGuideViewController  *userGuideViewController = [[DWGuideViewController alloc] init];
        self.window.rootViewController = userGuideViewController;
    }else {
        if ([self haveNewAd]) {
            [self showAdView];
        }else{
            self.dwTabBarController = [[DWTabBarController alloc] init];
            self.window.rootViewController = self.dwTabBarController;
        }
    }

    [self locationAction];
    [self.window makeKeyAndVisible];
    [self configThirdPart];
    [self payAction];
    [self isLogin];
    [AMapServices sharedServices].apiKey =GDKey;
    //[AMapServices sharedServices].apiKey = @"6eb92d95273f7d8f43112766c305130f";
   [[AMapServices sharedServices] setEnableHTTPS:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showActive:) name:@"登录成功" object:nil];
    //设置第三方
    [self SetUpThirdParty:launchOptions];
    //设置别名
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetUpAlias:) name:@"设置别名" object:nil];
    //获取经纬度
     [[DWHelper shareHelper]getloaction];

    return YES;
}
#pragma mark -  设置别名
-(void)SetUpAlias:(NSNotification*)sender{
    NSDictionary * dic = sender.userInfo;
    self.pushAlias =dic[@"pushAlias"];
    [JPUSHService setAlias:self.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
}

#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (iResCode == 0) {
        
    }
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    
    NSLog(@"push set alias success alisa = %@", alias);
}
//是否登陆过
- (void)isLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DWHelper *helper = [DWHelper shareHelper];
    helper.isLogin = [userDefaults objectForKey:@"isLogin"];
}

- (void)UMShare {
    [UMSocialData setAppKey:@"5760ee9be0f55a0dec0013e6"];
    [MobClick startWithAppkey:@"5770879c67e58e0f940010ef" reportPolicy:REALTIME channelId:@"测试"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxb1b2bfe44501f201" appSecret:@"5c9d1be2f5dc4cc975c248f9efd7b608" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1105466760" appKey:@"ZhkBC58lGdVq4kaw" url:@"http://www.umeng.com/social"];

}
- (BOOL)launchFirst {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        return YES;
    }
    return NO;
}

#pragma mark - UM分享回调方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
    }
    
    return  YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)payAction {
    //注册
    [WXApi registerApp:WXAppId withDescription:@"微信支付"];
}
//appdelegate代理方法 (调用 支付结果回调 的方法)
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
    }
    //调用 支付结果的回调 (设置代理)
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        //通知中心发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinpay" object:resp];
                switch (resp.errCode) {
                    case WXSuccess:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"支付成功" object:@"支付成功" userInfo:@{}];
                        break;
                    case WXErrCodeCommon:
                        NSLog(@"普通错误类型");
                        break;
                    case WXErrCodeUserCancel:
                        NSLog(@"用户点击取消并返回");
                        break;
                    case WXErrCodeSentFail:
                        NSLog(@"发送失败");
                        break;
                    case WXErrCodeAuthDeny:
                        NSLog(@"授权失败 ");
                        break;
                    case WXErrCodeUnsupport:
                        NSLog(@"微信不支持");
                        break;
                    default:
                        break;
                }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [application setApplicationIconBadgeNumber:0];
//    [JPUSHService setBadge:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [JPUSHService setBadge:0];
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configThirdPart{
    //    //友盟分享
    [self UMShare];
    //想微信注册
    //    [WXApi registerApp:@"wxe58ed84bb424e243" withDescription:@"微信"];
}

- (BOOL)haveNewAd{
    return YES;
}


#pragma mark - 定位服务
- (void)locationAction {
    
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        //位置服务是在设置中禁用
    {
    }
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
                return ;
            }
        }
        //定位信息
        DWHelper *dwHelper = [DWHelper shareHelper];
        dwHelper.coordinate = location.coordinate;
        OKLog(@"定位经纬度");
        //逆地理信息
        if (regeocode)
        {
            DWHelper *helper = [DWHelper shareHelper];
            helper.adressData = regeocode;
            NSLog(@"reGeocode:%@", regeocode.city);
        }
    }];
}


- (void)showAdView{
    self.window.rootViewController = [[DWTabBarController alloc] init];
    UIButton *adView = [[UIButton alloc] initWithFrame:self.window.bounds];
    adView.backgroundColor = [UIColor whiteColor];
    [adView addTarget:self action:@selector(clickAd:) forControlEvents:UIControlEventTouchUpInside];
    [self.window.rootViewController.view addSubview:adView];
    self.adView = adView;
    UIImageView *adImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*4/3)];
    adImage.image = [UIImage imageNamed:@""];
    [adView addSubview:adImage];
    [self getImageLogo:adImage];
    UIView *brandView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - 100, Width, 100)];
    brandView.backgroundColor= [UIColor whiteColor];
    [adView addSubview:brandView];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    logo.image = [UIImage imageNamed:@"512"];
    logo.backgroundColor = [UIColor redColor];
    logo.center = CGPointMake(Width/ 2 - 30, 40);
    [brandView addSubview:logo];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    lable.center = CGPointMake(Width/ 2 + 40, 40);
    lable.text = @"便民服务";
    lable.font = [UIFont boldSystemFontOfSize:16];
    lable.textColor = [UIColor colorWithHexString:kTitleColor];
    [brandView addSubview:lable];
    
    UILabel *copyRightLable = [[UILabel alloc] initWithFrame:CGRectMake(0, brandView.frame.size.height - 40, Width, 30)];
    copyRightLable.text = @"©2016 bmin.wang All Rights Reserved";
    copyRightLable.font = [UIFont systemFontOfSize:12];
    copyRightLable.textAlignment = NSTextAlignmentCenter;
    copyRightLable.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [brandView addSubview:copyRightLable];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundColor:[UIColor blackColor]];
    closeBtn.frame = CGRectMake(Width - 80, 30, 60, 30);
    closeBtn.layer.cornerRadius = 30/2;
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    closeBtn.layer.masksToBounds = YES;
    closeBtn.alpha = 0.3;
    [closeBtn addTarget:self action:@selector(hideAdView:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [adView addSubview:closeBtn];
    [self performSelector:@selector(hideAdView:) withObject:adView afterDelay:6];
}

- (void)hideAdView:(UIView *)adView{
    [UIView animateWithDuration:1 animations:^{
        self.adView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.adView removeFromSuperview];
        self.adView = nil;
    }];
}

- (void)clickAd:(UIButton *)btn{
    NSNumber *num = [DWCacheManager getPublicCacheWithKey:@"logoNum"];
    if (num == nil) {
        return;
    }
    RequestHomePageModel *model = self.logoArr[[num integerValue] - 1];
    if (model.type == 1) {
        ShopViewController *shopViewC = [[ShopViewController alloc] init];
        shopViewC.merchantId = model.merchantId;
        DWTabBarController *tabbar = (DWTabBarController *)self.window.rootViewController;
        [tabbar.homePageViewController.navigationController pushViewController:shopViewC animated:YES];
        [self hideAdView:btn];
    }else if (model.type == 3) {
        if (model.linkUrl.length !=0) {
            DWWebViewController *webVC = [[DWWebViewController alloc] init];
            [webVC setUrl:model.linkUrl];
            DWTabBarController *tabbar = (DWTabBarController *)self.window.rootViewController;
            [tabbar.homePageViewController.navigationController pushViewController:webVC animated:YES];
            [self hideAdView:btn];
        }else{
            ShopViewController *shopViewC = [[ShopViewController alloc] init];
            shopViewC.merchantId = model.merchantId;
            DWTabBarController *tabbar = (DWTabBarController *)self.window.rootViewController;
            [tabbar.homePageViewController.navigationController pushViewController:shopViewC animated:YES];
            [self hideAdView:btn];

        }
        
    }
    
    
}

- (void)getImageLogo:(UIImageView *)imageView {
    RequestHomePageAdList *homePage = [[RequestHomePageAdList alloc] init];
    homePage.position = 1;
    homePage.regionId = [AuthenticationModel getRegionID];
        BaseRequest *baseRequest = [[BaseRequest alloc] init];
    baseRequest.encryptionType = RequestMD5;
    baseRequest.data = homePage;
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseRequest yy_modelToJSONString] act:@"act=Api/Home/requestHomePageAdList" sign:[[baseRequest.data yy_modelToJSONString]MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
              RequestHomePageModel *model = [RequestHomePageModel yy_modelWithDictionary:dic];
                [weakSelf.logoArr addObject:model];
            }
        }
        if (weakSelf.logoArr.count != 0) {
            [self showImage:imageView withArr:weakSelf.logoArr];
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];

}

- (void)showImage:(UIImageView *)imageView withArr:(NSMutableArray *)arr {
    NSNumber *num = [DWCacheManager getPublicCacheWithKey:@"logoNum"];
    NSLog(@"%@", num);
    if (num == nil || num == NULL) {
        RequestHomePageModel *model = arr[0];
        if (model.originUrl == nil || model.originUrl == NULL) {
            imageView.image = [UIImage imageNamed:@"ad"];
        }else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrl]];
        }
        [DWCacheManager setPulicCache:@(1) :@"logoNum"];
    }else if(arr.count < [num integerValue] || arr.count == [num integerValue] ) {
        RequestHomePageModel *model = arr[0];
        if (model.originUrl == nil || model.originUrl == NULL) {
            imageView.image = [UIImage imageNamed:@"ad"];
        }else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrl]];
        }
        [DWCacheManager setPulicCache:@(0+1) :@"logoNum"];
    }else {
        RequestHomePageModel *model = arr[[num integerValue]];
        if (model.originUrl == nil || model.originUrl == NULL) {
            imageView.image = [UIImage imageNamed:@"ad"];
        }else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrl]];
        }
        [DWCacheManager setPulicCache:[NSNumber numberWithInteger:[num integerValue] + 1] :@"logoNum"];
    }
}


- (void)logoGetData:(NSString *)logoData {

}

- (NSMutableArray *)logoArr {
    if (!_logoArr) {
        self.logoArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _logoArr;
}

////极光推送
//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
//    [JPUSHService registerDeviceToken:deviceToken];
//}

//- (void)application:(UIApplication *)application
//didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}

//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//- (void)application:(UIApplication *)application
//didRegisterUserNotificationSettings:
//(UIUserNotificationSettings *)notificationSettings {
//    
//    
//    
//}
//
//// Called when your app has been activated by the user selecting an action from
//// a local notification.
//// A nil action identifier indicates the default action.
//// You should call the completion handler as soon as you've finished handling
//// the action.
//- (void)application:(UIApplication *)application
//handleActionWithIdentifier:(NSString *)identifier
//forLocalNotification:(UILocalNotification *)notification
//  completionHandler:(void (^)())completionHandler {
//    
//    
//    
//}
//
//// Called when your app has been activated by the user selecting an action from
//// a remote notification.
//// A nil action identifier indicates the default action.
//// You should call the completion handler as soon as you've finished handling
//// the action.
//- (void)application:(UIApplication *)application
//handleActionWithIdentifier:(NSString *)identifier
//forRemoteNotification:(NSDictionary *)userInfo
//  completionHandler:(void (^)())completionHandler {
//    
//    
//}
//#endif
//
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", userInfo);
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [JPUSHService clearAllLocalNotifications];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
////    PushMessageController *messageC = [[PushMessageController alloc] init];
//    
//    //Push 跳转
//    PublicMessageVC * messageC = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
//   
//    DWTabBarController *tabbar = (DWTabBarController *)self.window.rootViewController;
//    [tabbar.homePageViewController.navigationController popToRootViewControllerAnimated:NO];
//    [tabbar.homePageViewController.navigationController pushViewController:messageC animated:YES];
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:[userInfo yy_modelToJSONString] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
////    [alert show];
//}
//
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:
//(void (^)(UIBackgroundFetchResult))completionHandler {
//    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", userInfo);
//    NSLog(@"收到通知:%@", userInfo);
//    NSInteger num = application.applicationIconBadgeNumber;
//    [application setApplicationIconBadgeNumber:num+1];
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:[userInfo yy_modelToJSONString] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
////    [alert show];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新订单" object:@"刷新订单" userInfo:@{}];
//    //Push 跳转
//    PublicMessageVC * messageC = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
//    
//    DWTabBarController *tabbar = (DWTabBarController *)self.window.rootViewController;
//    [tabbar.homePageViewController.navigationController popToRootViewControllerAnimated:NO];
//    [tabbar.homePageViewController.navigationController pushViewController:messageC animated:YES];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//- (void)application:(UIApplication *)application
//didReceiveLocalNotification:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//}

#pragma mark - 显示易民钱包
- (void)showActive:(NSNotification *)sender {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSNumber *firstLogin = [userD objectForKey:@"firstLogin"];
    if (firstLogin == nil) {
        [userD setObject:@(1) forKey:@"firstLogin"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showActiveFun];
        });
    }
}
- (void)showActiveFun {
    self.activeV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    self.activeV.backgroundColor = [UIColor blackColor];
    self.activeV.alpha = 0.5;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.activeV];
    self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"组-4"]];
    self.img.contentMode = UIViewContentModeScaleAspectFit;
    self.img.userInteractionEnabled = YES;
    [window addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.activeV);
        make.centerY.equalTo(self.activeV).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(Width - 30, Width-30));
    }];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setImage:[UIImage imageNamed:@"图层-50"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(cancelActiveAction:) forControlEvents:UIControlEventTouchUpInside];
    self.btn.contentMode = UIViewContentModeScaleAspectFit;
    [self.img addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img).with.offset(20);
        make.right.equalTo(self.img).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.yiminL = [UILabel new];
    self.yiminL.text = @"易民钱包";
    self.yiminL.font = [UIFont systemFontOfSize:18];
    self.yiminL.textAlignment = NSTextAlignmentCenter;
    self.yiminL.textColor = [UIColor colorWithHexString:@"#ff6402"];
    [window addSubview:self.yiminL];
    [self.yiminL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.img);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    self.webBtn = [UIButton new];
    [self.webBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    self.webBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.webBtn setTitleColor:[UIColor colorWithHexString:@"#ff6402"] forState:UIControlStateNormal];
    self.webBtn.layer.masksToBounds = YES;
    self.webBtn.layer.cornerRadius = 15;
    self.webBtn.layer.borderColor = [UIColor colorWithHexString:@"#ff6402"].CGColor;
    self.webBtn.layer.borderWidth = 1;
    [self.webBtn addTarget:self action:@selector(webAction:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self.webBtn];
    [self.webBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yiminL.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.img);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

- (void)cancelActiveAction:(UIButton *)sender {
    [self.activeV removeFromSuperview];
    [self.img removeFromSuperview];
    [self.btn removeFromSuperview];
    [self.webBtn removeFromSuperview];
    [self.yiminL removeFromSuperview];
}

- (void)webAction:(UIButton *)sender {
    DWHelper *helper = [DWHelper shareHelper];
    [self cancelActiveAction:nil];
    WebLoginController *webLogin = [[WebLoginController alloc] init];
            webLogin.registUrl = helper.configModel.referralReglUrl;
    DWTabBarController *tabbar = (DWTabBarController *)self.window.rootViewController;
    [webLogin setUrl:helper.configModel.referralUrl];
    [tabbar.myViewControler.navigationController pushViewController:webLogin animated:YES];
 
}
#pragma mark - 设置所有第三方
-(void)SetUpThirdParty:(NSDictionary *)launchOptions{
       //极光推送
    [self JGPush:launchOptions];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
}


#pragma mark - 极光推送
-(void)JGPush:(NSDictionary *)launchOptions{
    /*=======
     NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
     
     // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
     JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
     entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
     if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
     //可以添加自定义categories
     //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
     //      NSSet<UNNotificationCategory *> *categories;
     //      entity.categories = categories;
     //    }
     //    else {
     //      NSSet<UIUserNotificationCategory *> *categories;
     //      entity.categories = categories;
     //    }
     }
     [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
     
     
     //如不需要使用IDFA，advertisingIdentifier 可为nil
     [JPUSHService setupWithOption:launchOptions appKey:appKey
     channel:channel
     apsForProduction:isProduction
     advertisingIdentifier:advertisingId];
     
     //2.1.9版本新增获取registration id block接口。
     [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
     if(resCode == 0){
     NSLog(@"registrationID获取成功：%@",registrationID);
     
     }
     else{
     NSLog(@"registrationID获取失败，code：%d",resCode);
     }
     }];
     
     ===========*/
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
//    [JPUSHService setupWithOption:launchOptions appKey:appKey
//                          channel:channel
//                 apsForProduction:isProduction
//            advertisingIdentifier:advertisingId];
        [JPUSHService setupWithOption:launchOptions appKey:@"bc6bf46b2d11135bf00723e7"
                              channel:@"官网"
                     apsForProduction:false
                advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            //            [USER setObject:registrationID forKey:@"deviceToken"];
            //            [USER synchronize];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
#pragma mark - 注册通知

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    //    [USER setObject:token forKey:@"deviceToken"];
    //    [USER synchronize];
    //
    //    [UMessage registerDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
    
}
/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //    [SVProgressHUD showInfoWithStatus:@"注册推送失败"];
    NSLog(@"注册推送失败------------------");
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    
    self.userInfo = userInfo;
    [self receivePushMessage];
}
//前台收到通知
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        self.userInfo = userInfo;
        //        [self receivePushMessage];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//后台收到推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        self.userInfo = userInfo;
        [self receivePushMessage];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


#pragma mark - APP运行中接收到通知(推送)处理

///** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        [self receiveRemoteNotificationReset:userInfo];
    }else{
        self.userInfo = userInfo;
        [self receivePushMessage];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark------------------收到通知的页面处理
-(void)receivePushMessage {
//    NSString *Token =[AuthenticationModel getLoginToken];
//    if (Token.length!= 0) {
//        //手势
//        [self.window bringSubviewToFront:self.gestureView];
//    }
//    //Push 跳转
//    DWTabBarController * VC = [[DWTabBarController alloc]init];
//    VC.selectedIndex = 0;
//    self.window.rootViewController = VC;
//    NSLog(@"%@",VC.viewControllers);
//    BaseNavigationController *naVC = VC.viewControllers.firstObject;
//    NSLog(@"%@",naVC.viewControllers);
//    for (BaseViewController*tempVC in naVC.viewControllers) {
//        if ([tempVC isKindOfClass:[HomePageVC class]]) {
//            HomePageVC *home = (HomePageVC *)tempVC;
//            NSString *Token =[AuthenticationModel getLoginToken];
//            if (Token.length!= 0) {
//                //Push 跳转
//                MessageViewController * VC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
//                [home.navigationController  pushViewController:VC animated:YES];
//                
//            }
//            
//        }
//    }
    
    
    
    
    
//        DWTabBarController *tabBarController = ( DWTabBarController*)self.window.rootViewController;
//        // 取到navigationcontroller
//        DWNavigationController * nav = (DWNavigationController *)tabBarController.selectedViewController;
//        //取到nav控制器当前显示的控制器
//        UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    //type字段后台返回，使用极光测试需在『附加字段』处添加
    NSDictionary *dic =self.userInfo;
    NSLog(@"%@",dic);
    
//        if([dic[@"type"] integerValue]==1){
//    
//        }else  if([dic[@"type"] integerValue]==2){
//    
//        }else if([dic[@"type"] integerValue]==3){
//    
//        }else if([dic[@"type"] integerValue]==4){
//    
//        }else if ([dic[@"type"] integerValue]==5){
////            WebToolViewController *vc=[[WebToolViewController alloc]init];
////            vc.isChange=YES;
////            vc.hidesBottomBarWhenPushed=YES;
////            vc.urlStr = dic[@"custom"];
////            [baseVC.navigationController pushViewController:vc animated:YES];
//            return;
//    
//        }else{
//            [self showReceiveMessage:dic[@"title"]];
//            return;
//        }
    
    
//        //如果是当前控制器是我的消息控制器的话，刷新数据即可
//        PublicMessageVC *message = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
//        if([baseVC isKindOfClass:[PublicMessageVC class]])
//        {
//            PublicMessageVC * vc = (PublicMessageVC *)baseVC;
//            //[vc headerRereshing];
//            return;
//        }
//        message.hidesBottomBarWhenPushed = YES;
//        [nav pushViewController:message animated:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DWHelper *helper = [DWHelper shareHelper];
    helper.isLogin = [userDefaults objectForKey:@"isLogin"];
    NSLog(@"%@",helper.isLogin);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //if ( [helper.isLogin intValue]==0) {
//        LoginController *loginController = [[LoginController alloc] init];
//        DWNavigationController * Nav = [[DWNavigationController alloc]initWithRootViewController:loginController];
//        
//        CATransition *  ansition =[CATransition animation];
//        [ansition setDuration:0.3];
//        [ansition setType:kCAGravityRight];
//        [[[[UIApplication sharedApplication]keyWindow ]layer] addAnimation:ansition forKey:nil];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:Nav animated:YES completion:nil];
    //}else if( [helper.isLogin intValue]==1){
//        // 否则，跳转到我的消息
//        PublicMessageVC *message = [[PublicMessageVC alloc]initWithNibName:@"PublicMessageVC" bundle:nil];
//        
//         UIViewController * viewControllerNow = [self currentViewController];
//        if ([viewControllerNow  isKindOfClass:[PublicMessageVC class]]) {   //如果是页面XXX，则执行下面语句
//            [message getDataList];
//        }else{
//            
//            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:message];
//            
//            CATransition *  ansition =[CATransition animation];
//            [ansition setDuration:0.3];
//            [ansition setType:kCAGravityRight];
//            [[[[UIApplication sharedApplication]keyWindow ]layer] addAnimation:ansition forKey:nil];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:Nav animated:YES completion:nil];
//        }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"跳转到消息中心" object:@"跳转到消息中心" userInfo:@{}];
        
//    }else{
//        
//    }
   
    
}
#pragma mark - 运行在前台时的提示框提醒
-(void)receiveRemoteNotificationReset:(NSDictionary *)userInfo{
    
    
    
    if (userInfo) {
        self.userInfo = userInfo;
    }
    NSString *typeStirng=userInfo[@"type"];
    if(typeStirng==nil||[typeStirng integerValue]==0){
        
        [self showReceiveMessage:userInfo[@"title"]];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:userInfo[@"title"] message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"稍后"
                                                  otherButtonTitles:@"立即前往", nil];
        [alertView show];
    }
    
}
#pragma mark-------------------------------推送处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self receivePushMessage];
    }
}
#pragma mark - 设置推送内容的展示
-(void)showReceiveMessage:(NSString *)message{
    //    [JDStatusBarNotification showWithStatus:message
    //                               dismissAfter:2.0
    //                                  styleName:@"SBStyle"];
    
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







@end
