
//
//  FMDatabaseUtils.m
//  BianMin
//
//  Created by z on 16/6/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "FMDatabaseUtils.h"
#import "RegionModel.h"

@implementation FMDatabaseUtils

+ (FMDatabase *)getDatabase{
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"region" ofType:@".db"];
    return [FMDatabase databaseWithPath:dbPath];
}

+ (DBRegionModel *)getRegionByRegionCode:(NSString *)code{
    FMDatabase *db = [FMDatabaseUtils getDatabase];
    if (![db open]) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from dwregion where regionCd='%@'", code];
    FMResultSet *set=[db executeQuery:sql];
    DBRegionModel *model = nil;
    if ([set next]) {
        NSString *regionId = [set stringForColumn:@"regionId"];
        NSString *regionCd = [set stringForColumn:@"regionCd"];
        NSString *regionName = [set stringForColumn:@"regionName"];
        NSString *superId = [set stringForColumn:@"superId"];
        NSString *regionType = [set stringForColumn:@"regionType"];
        
        model = [[DBRegionModel alloc] init];
        model.regionCode = regionCd;
        model.reigonId = [regionId integerValue];
        model.reigonName = regionName;
        model.superId = superId;
        model.regionType = [regionType integerValue];
        
    };
    return model;
}
+ (NSMutableArray *)getCityData
{
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    if ([UD objectForKey:@"city"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"dwregion" ofType:@"json"];
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

@end
