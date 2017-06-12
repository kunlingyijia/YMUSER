//
//  RequestMerchantDetailModel.h
//  BianMin
//
//  Created by kkk on 16/6/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantDetailModel : NSObject
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *haveoffice;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *hotValue;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger isCallCenter;
@property (nonatomic, copy) NSString *isCollect;
@property (nonatomic, copy) NSString *totalComment;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger have24hourWater;
@property (nonatomic, assign) NSInteger havaNoSmokingRoom;
@property (nonatomic, assign) NSInteger havaAirCondition;
//是否有WiFi，0-没有 1-有
@property (nonatomic, assign) NSInteger haveWifi;
//是否有停车场，0-没有 1-有
@property (nonatomic, assign) NSInteger haveParking;



@property (nonatomic, copy) NSString *kfmobile;

///openTime
@property (nonatomic, strong) NSString  *openTime ;
///距离(新增)
@property (nonatomic, strong) NSString  *distance ;




@end
