//
//  DWDeviceInfo.h
//  BianMin
//
//  Created by kkk on 16/7/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDeviceInfo : NSObject

+ (NSString *)getDeviceName;
+ (NSString *)getMacAddress;
+ (NSString *)getDeviceIPAddresses;

@end
