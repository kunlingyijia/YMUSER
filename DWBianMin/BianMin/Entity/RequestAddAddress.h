//
//  RequestAddAddress.h
//  BianMin
//
//  Created by kkk on 16/5/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestAddAddress : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *postcode;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger regionId;
@property (nonatomic, copy) NSString *zone;
///纬度（新增）
@property (nonatomic, strong) NSString  *lat ;
///经度（新增）
@property (nonatomic, strong) NSString  *lng ;
///街道（新增）
@property (nonatomic, strong) NSString  *street ;
@end
