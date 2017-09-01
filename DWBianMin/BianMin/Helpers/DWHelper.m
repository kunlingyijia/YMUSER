//
//  DWHelper.m
//  BianMin
//
//  Created by kkk on 16/4/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWHelper.h"
#import "UMSocial.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RegionModel.h"
#import "DWTools.h"
#import "DWDeviceInfo.h"
#import "SVProgressHUD.h"
#import "LoginController.h"
@interface DWHelper ()<UMSocialUIDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation DWHelper


+ (id)shareHelper {
    static DWHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DWHelper alloc] init];
    });
    return helper;
}


- (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method success:(SuccessCallback)success faild:(FaildCallback)faild {
//    self.Successblock = success;
//    self.Faildblock = faild;
    
    if (method == GET) {
        NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl, actName,sign];
        AFHTTPSessionManager *Session = [AFHTTPSessionManager manager];
        //缓存策略
        Session.requestSerializer.cachePolicy = 0;
        Session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"application/x-www-form-urlencoded", nil];
//         [Session.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [Session.requestSerializer setValue:[NSString stringWithFormat:@"%lf", self.coordinate.latitude] forHTTPHeaderField:@"lat"];
        [Session.requestSerializer setValue:[NSString stringWithFormat:@"%lf", self.coordinate.longitude] forHTTPHeaderField:@"lng"];
        NSString *province = nil;
        NSString *city = nil;
        NSString *area = nil;
        NSString *adress = nil;
        if (self.adressData.province != nil) {
            province = self.adressData.province;
            city = self.adressData.city;
            area = self.adressData.district;
            adress = [NSString stringWithFormat:@"%@%@%@",self.adressData.province,self.adressData.city, self.adressData.district];
        }else {
            province = @"";
            city = @"";
            area = @"";
            adress = @"";
        }
        [Session.requestSerializer setValue:@"福州" forHTTPHeaderField:@"province"];
        [Session.requestSerializer setValue:city forHTTPHeaderField:@"city"];
        [Session.requestSerializer setValue:area forHTTPHeaderField:@"area"];
        [Session.requestSerializer setValue:adress forHTTPHeaderField:@"address"];
        [Session.requestSerializer setValue:@"1" forHTTPHeaderField:@"clientOS"];
        [Session.requestSerializer setValue:[DWTools getXKVersion] forHTTPHeaderField:@"appVersion"];
        [Session.requestSerializer setValue:[[UIDevice currentDevice].identifierForVendor UUIDString] forHTTPHeaderField:@"deviceNo"];
        
        [Session.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"systemVersion"];
        if ([DWDeviceInfo getDeviceName]) {
            [Session.requestSerializer setValue:[NSString stringWithFormat:@"%@",[DWDeviceInfo getDeviceName]] forHTTPHeaderField:@"phoneModel"];
        }
        
        [Session GET:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([responseObject[@"resultCode"]isEqualToString:@"14"]) {
                //设置别名
                [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                DWHelper *helper = [DWHelper shareHelper];
                [userDefaults setObject:@(0) forKey:@"isLogin"];
                helper.isLogin = @(0);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"退出账号" object:@"退出账号" userInfo:nil];
//                // 跳转到登录界面
//                LoginController *loginController = [[LoginController alloc] init];
//                     UIViewController * viewControllerNow = [self currentViewController];
//                if ([viewControllerNow  isKindOfClass:[LoginController class]]) {
//                    //如果是页面XXX，则执行下面语句
//                }else{
//                    [viewControllerNow.navigationController pushViewController:loginController animated:YES];
//                }
            }
           
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(error);
            NSString * errorStr =error.localizedDescription;
            if (errorStr.length>1) {
                [SVProgressHUD showErrorWithStatus:  [error.localizedDescription   substringToIndex:error.localizedDescription.length-1]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                
            }
        }];
    }else if (method == POST) {
        NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl, actName,sign];
        AFHTTPSessionManager *Session = [AFHTTPSessionManager manager];
        //缓存策略
        Session.requestSerializer.cachePolicy = 0;
        Session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        [Session POST:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(error);
            [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        }];
    }
}


- (void)UMShareWithController:(id)sender WithText:(NSString *)text WithPictureUrl:(NSString *)imageUrl WithContentUrl:(NSString *)contentUrl{
    NSString *newUrl = [contentUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialData defaultData].extConfig.title = @"易民网";
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    [UMSocialData defaultData].extConfig.qqData.url = newUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = newUrl;
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:contentUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = newUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = newUrl;
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialSnsService presentSnsIconSheetView:sender
                                             appKey:@"5760ee9be0f55a0dec0013e6"
                                          shareText:text
                                         shareImage:[UIImage imageNamed:@"666"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,nil]
                                           delegate:self];
    
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                        @"http://www.baidu.com/img/bdlogo.gif"];
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ] content:@"分享内嵌文字" image:nil location:nil urlResource:urlResource presentedController:sender completion:^(UMSocialResponseEntity *shareResponse){
//        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];

}
//实现回调方法(可选)
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (NSString *)getNetWorking {
    return  self.netWorking;
}
//定位
- (BOOL)isOpenLocation {
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        //位置服务是在设置中禁用
    {
        return NO;
    }
    return YES;
}

- (NSDictionary *)getloaction {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    NSLog(@"开始定位");
    return @{};
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lf",coordinate.latitude] forKey:@"Dlatitude"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%lf",coordinate.longitude] forKey:@"Dlongitude"];
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

//获取当前的网络状态
+ (NSString *)networkingStatesFromStatebar {
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            NSLog(@"%@", [child valueForKeyPath:@"dataNetworkType"]);
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSString *stateString = @"wifi";

    switch (type) {
        case 0:
            //无网络链接
            stateString = @"notReachable";
            break;
        case 1:
            stateString = @"2G";
            break;

        case 2:
            stateString = @"3G";
            break;

        case 3:
            stateString = @"4G";
            break;

        case 4:
            stateString = @"LTE";
            break;
        case 5:
            stateString = @"wifi";
            break;

        default:
            break;
    }
    //返回网络状态
    return stateString;
}

#pragma mark - 微信支付
+ (void)WXpayAction:(NSString *)orderId withpartnerId:(NSString *)partnerId withpackage:(NSString *)package withnonceStr:(NSString *)nonceStr withtimeStamp:(UInt32)timeStamp withsign:(NSString *)sign{
    PayReq *request = [[PayReq alloc] init];
    //商家向财付通申请的商家id
    request.partnerId = partnerId;
    //预支付订单:绑定了我的商品的基本信息 (后台生成的id)
    request.prepayId= orderId;
    //商家根据财付通文档填写的数据和签名 : 微信的标识 意味着是微信支付 不是别的服务
    request.package = package;
    //随机串，防重发
    request.nonceStr= nonceStr;
    //时间戳，防重发
    request.timeStamp= timeStamp;
    //商家根据微信开放平台文档对数据做的签名: 是一种加密方式 所有的支付都需要加密
    request.sign= sign;
    [WXApi sendReq:request];
}



+ (void)AliPayActionWithOrderStr:(NSString *)str{
//          /*
//         *商户的唯一的parnter和seller。
//         *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
//         */
//        /*============================================================================*/
//        /*=======================需要填写商户app申请的===================================*/
//        /*============================================================================*/
//        //表示商户id 支付宝签订协议后分配的id 需要公司营业执照(公司弄)
//        NSString *partner = @"2088321000596152";
//        //邮箱地址 绑定总账号(公司弄) 绑定公司账号, 用于客户交易资金转账
//        NSString *seller = @"fzyimin@sina.com";
//        //私钥:是用来加密用的 公钥:是用来解密用的(我们用不上)  (后台弄的)
//    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALys+oYaxqv4FYju8C1poM6qmHLjWPnXzqEJT0NxyFXgdaK/Qe9DcpcASod9mIAdlLIxJEyYNlWeonAJVYW8pQ+pTVGwI9n0iaT71ldWQzcMN3Dvi/+zpgw3HxxO7HJtEIlR84pvILv1yceCZCqqQ4O/4SemsG00oTiTyD3SM2ZvAgMBAAECgYBLToeX6ywNC7Icu7Hljll+45yBjri+0CJLKFoYw1uA21xYnxoEE9my54zX04uA502oafDhGYfmWLDhIvidrpP6oaluURb/gbV5Bdcm98gGGVgm6lpK+G5N/eawXDjP0ZjxXb114Y/Hn/oVFVM9OqcujFSV+Wg4JgJ4Mmtdr35gYQJBAPbhx030xPcep8/dL5QQMc7ddoOrfxXewKcpDmZJi2ey381X+DhuphQ5gSVBbbunRiDCEcuXFY+R7xrgnP+viWcCQQDDpN8DfqRRl+cUhc0z/TbnSPJkMT/IQoFeFOE7wMBcDIBoQePEDsr56mtc/trIUh/L6evP9bkjLzWJs/kb/i25AkEAtoOf1k/4NUEiipdYjzuRtv8emKT2ZPKytmGx1YjVWKpyrdo1FXMnsJf6k9JVD3/QZnNSuJJPTD506AfZyWS6TQJANdeF2Hxd1GatnaRFGO2y0mvs6U30c7R5zd6JLdyaE7sNC6Q2fppjmeu9qFYq975CKegykYTacqhnX4I8KEwHYQJAby60iHMAYfSUpu//f5LMMRFK2sVif9aqlYbepJcAzJ6zbiSG5E+0xg/MjEj/Blg9rNsqDG4RECGJG2nPR72O8g==";
//    /*============================================================================*/
//        /*============================================================================*/
//        /*============================================================================*/
//    
//        //partner和seller获取失败,提示
//        if ([partner length] == 0 ||
//            [seller length] == 0 ||
//            [privateKey length] == 0)
//        {
//            NSLog(@"缺少partner或者seller或者私钥");
//            return;
//        }
//    
//        /*
//         *生成订单信息及签名
//         */
//        //将商品信息赋予AlixPayOrder的成员变量 ( 以下网络请求来的数据)
//        Order *order = [[Order alloc] init];
//        order.partner = partner;
//        order.seller = seller;
//        order.tradeNO = orderID; //订单ID（由商家自行制定）
//        order.productName = name; //商品标题
//        order.productDescription = explain; //商品描述
//        order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格.2f 其他值不行 会失败
//        order.notifyURL =  url; //回调URL
//    
//        //以下信息是默认信息 不需要更改
//        order.service = @"mobile.securitypay.pay";
//        order.paymentType = @"1";
//        order.inputCharset = @"utf-8";
//        order.itBPay = @"30m";
//        order.showUrl = @"m.alipay.com";
//    
//        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//        //标识 支付后根据这个值跳转到这个App (要在info中设置 见图片http://blog.sina.com.cn/s/blog_6f72ff900102v4vp.html)
        NSString *appScheme = @"dwbm";
        [[AlipaySDK defaultService] payOrder:str fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                NSString *resultStatus = resultDic[@"resultStatus"];
                NSLog(@"%@",resultDic[@"memo"]);
                if ([resultStatus isEqualToString:@"9000"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"支付成功" object:@"支付成功" userInfo:@{}];
                }
            }];
}
+ (NSMutableArray *)getCityData
{
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    if ([UD objectForKey:@"city"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
        fileData = [NSData dataWithContentsOfFile:path];
        
        [UD setObject:fileData forKey:@"city"];
        [UD synchronize];
    }
    else {
        fileData = [UD objectForKey:@"city"];
    }
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dict in jsonArray) {
        [array addObject:dict];
    }
    
    return array;
}
///图片展示
+(void)SD_WebImage:(UIImageView*)imageView imageUrlStr:(NSString*)urlStr placeholderImage:(NSString*)placeholder{
    
    if (placeholder==nil) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bg_zaijia_1-1"]];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",placeholder]]];
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


@end
