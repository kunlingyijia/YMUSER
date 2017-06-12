//
//  RequestAddBminorder.h
//  BianMin
//
//  Created by kkk on 16/8/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestAddBminorder : NSObject

@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, strong) NSArray *bminServiceList;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *bookingStartTime;
@property (nonatomic, copy) NSString *bookingEndTime;
@property (nonatomic, assign) NSString* price;
@property (nonatomic, copy) NSString *content;
///纬度（新增）
@property (nonatomic, strong) NSString  *lat ;
///经度（新增）
@property (nonatomic, strong) NSString  *lng ;





@end
