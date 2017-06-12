//
//  RequestUpdateAddress.h
//  BianMin
//
//  Created by kkk on 16/8/2.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUpdateAddress : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *postcode;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger regionId;
@property (nonatomic, copy) NSString *zone;
@property (nonatomic, copy) NSString *addressId;
///纬度（新增）
@property (nonatomic, strong) NSString  *lat ;
///经度（新增）
@property (nonatomic, strong) NSString  *lng ;
///街道（新增）
@property (nonatomic, strong) NSString  *street ;







@end
