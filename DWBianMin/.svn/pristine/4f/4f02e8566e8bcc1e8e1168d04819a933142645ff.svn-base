
//
//  DWCacheManager.m
//  BianMin
//
//  Created by kkk on 16/5/31.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWCacheManager.h"

#define kUserId @"dw_userId"

@implementation DWCacheManager

+ (void)setPulicCache:(id)cache :(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setPrivateCache:(id)cache :(NSString *)key{
    NSString *userId = [DWCacheManager getPublicCacheWithKey:kUserId];
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:[NSString stringWithFormat:@"private_%@_%@", userId, key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getPublicCacheWithKey:(NSString *)key{
    id cache = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return cache;
}

+ (id)getPrivateCacheWithKey:(NSString *)key {
    NSString *userId = [DWCacheManager getPublicCacheWithKey:kUserId];
    id cache = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"private_%@_%@", userId, key]];
    return cache;
}

@end
