//
//  AdressModel.h
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdressModel : NSObject

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *postcode;
@property (nonatomic, copy) NSString *zone;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, assign) NSInteger regionId;
///街道名称
@property (nonatomic, copy) NSString *street;
///纬度（新增）
@property (nonatomic, strong) NSString  *lat ;
///经度（新增）
@property (nonatomic, strong) NSString  *lng ;








@end
