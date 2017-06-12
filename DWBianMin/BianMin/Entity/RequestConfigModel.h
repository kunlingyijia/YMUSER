//
//  RequestConfigModel.h
//  BianMin
//
//  Created by kkk on 16/10/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestConfigModel : NSObject
@property (nonatomic, copy) NSString *referralCode;
@property (nonatomic, copy) NSString *referralUrl;
@property (nonatomic, copy) NSString *referralReglUrl;
@property (nonatomic, copy) NSString *waterSwitch;
@property (nonatomic, copy) NSString *waterLogo;
@property (nonatomic, copy) NSString *image_hostname;
@property (nonatomic, copy) NSString *image_account;
@property (nonatomic, copy) NSString *image_password;
///客服电话
@property (nonatomic, copy) NSString* plat_kfmobile;


@end
