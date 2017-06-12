//
//  AuthenticationModel.h
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationModel : NSObject

+ (NSString *)getRegisterKey;
+ (NSString *)getRegistertoken;
+ (NSString *)getLoginKey;
+ (NSString *)getLoginToken;
+ (NSString *)getRegionID;
+ (NSString *)getRegionName;
+ (NSString *)getUserID;
+ (NSString *)getlatitude;
+ (NSString *)getlongitude;
@end
