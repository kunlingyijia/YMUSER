//
//  DW-Prefix.h
//  BianMin
//
//  Created by kkk on 16/4/27.
//  Copyright © 2016年 bianming. All rights reserved.
//
#ifndef DW_Prefix_h
#define DW_Prefix_h
#import "FakeData.h"
#import "AppDelegate.h"
#import "UIColor+DWColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "NSString+DWString.h"
#import "Masonry.h"
#import "DWHelper.h"
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DWWebViewController.h"
#import "LoginController.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "YYModel.h"
#import "NSString+DWString.h"
#import "AESCrypt.h"
#import "AuthenticationModel.h"
#import "ProcessResultCode.h"
#import "RegionModel.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "DWCacheManager.h"
#import "JPUSHService.h"
#import "IQKeyboardManager.h"
#import "RequestConfigModel.h"
#import "UITableView+NoData.h"
#import "UICollectionView+NoData.h"
#import "PublicBtn.h"
#import "PublicTF.h"
#import "EZTextView.h"

#import "YanZhengOBject.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DWNavigationController.h"
#import "APICount.h"
#import "LineView.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define Bounds [UIScreen mainScreen].bounds
#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define MainColor [UIColor colorWithRed:1.0 / 255.0 green:199.0 /255.0 blue:184.0 / 255.0 alpha:1.0]
#define DELEGATE_CALLBACK(DELEGATE, SEL) if (DELEGATE && [DELEGATE respondsToSelector:@selector(SEL)]) [DELEGATE performSelector:@selector(SEL)]
#define DELEGATE_CALLBACK_ONE_PARAMETER(DELEGATE, SEL, X) if (DELEGATE && [DELEGATE respondsToSelector:@selector(SEL)]) [DELEGATE performSelector:@selector(SEL) withObject:X]

#ifdef DEBUG
#define OKLog(s,...) NSLog(@"%@:%d : %@/%@\n **** %@ ****", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#   define OKLog(...)
#endif
///正式
//#define kServerUrl @"http://api.bmin.wang/?"
///测试
//#define kServerUrl @"http://test.bmin.wang/?"
///开发
#define kServerUrl @"http://bmin.dongwuit.com/?"
///正式地图
#define GDKey @"a4725781981191b57d44936de2fbbe52"
///测试地图
//#define GDKey @"2d5e8931fb852fc18d87d2ce0ee1404c"
#define kPhotoUrl @"http://test.dongwuit.com/?act=Api/Image/upload&sign=%@"
#define kTitleColor @"#333333"
#define kSubTitleColor @"#aaaaaa"
#define kNavigationTitleColor @"#ffffff"
#define kViewBg @"#f4f4f4"
#define kNavigationBgColor @"#06c1ae"
#define kLineColor @"#EDEDED"
#define kLineHeight 0.5
#define WXAppId @"wxb1b2bfe44501f201"
#define kFirstFont 16
#define kSecondFont 15
#define kThirtFont 14

#endif /* DW_Prefix_h */
