//
//  AuthenticationModel.m
//  BianMin
//
//  Created by kkk on 16/5/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel


+ (NSString *)getRegisterKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"registKey"];
}
+ (NSString *)getRegistertoken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"registToken"];
}
+ (NSString *)getLoginKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"loginKey"];
}
+ (NSString *)getLoginToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"loginToken"];
}

+ (NSString *)getRegionID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"regionId"];
}
+ (NSString *)getRegionName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"regionName"];
}

+ (NSString *)getUserID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userID"];
}
+ (NSString *)getlatitude{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"Dlatitude"];
}
+ (NSString *)getlongitude{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"Dlongitude"];
}

@end
