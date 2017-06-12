//
//  DWHelper.h
//  BianMin
//
//  Created by kkk on 16/4/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "RequestConfigModel.h"
@class RegionModel;
typedef void(^SuccessCallback)(id response);
typedef void(^FaildCallback)(id error);



//枚举 请求类型
typedef enum : NSUInteger {
    POST,
    GET,
    PUT,
}RequestMethod;




@interface DWHelper : NSObject

@property (nonatomic, copy)SuccessCallback Successblock;
@property (nonatomic, copy)FaildCallback Faildblock;
//存储当前网络状态
@property (nonatomic, copy)NSString *netWorking;
//存储wifi下是否显示图片
@property (nonatomic, assign)BOOL isWifiOn;
//当前地理位置
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) AMapLocationReGeocode *adressData;
//是否处于登录状态
@property (nonatomic, assign) NSNumber* isLogin;
//存储 定位城市ID
@property (nonatomic,copy) NSString *adressID;

@property (nonatomic, strong) RequestConfigModel *configModel;

//单例
+ (id)shareHelper;
//网络请求
- (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method success:(SuccessCallback)success faild:(FaildCallback)faild;
//获取当前网络状态
+ (NSString *)networkingStatesFromStatebar;

- (NSString *)getNetWorking;



//友盟分享
- (void)UMShareWithController:(id)sender WithText:(NSString *)text WithPictureUrl:(NSString *)imageUrl WithContentUrl:(NSString *)contentUrl;

//定位功能
- (NSDictionary *)getloaction;
//判断是否打开了定位
- (BOOL)isOpenLocation;

//微信支付
+ (void)WXpayAction:(NSString *)orderId withpartnerId:(NSString *)partnerId withpackage:(NSString *)package withnonceStr:(NSString *)nonceStr withtimeStamp:(UInt32)timeStamp withsign:(NSString *)sign;
//支付宝支付
+ (void)AliPayActionWithOrderStr:(NSString *)str;

+ (NSMutableArray *)getCityData;
///图片展示
+(void)SD_WebImage:(UIImageView*)imageView imageUrlStr:(NSString*)urlStr placeholderImage:(NSString*)placeholder;
@end
