//
//  RequestResetPwdByVerifyCode.h
//  BianMin
//
//  Created by kkk on 16/5/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResetPwdByVerifyCode : NSObject
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *password;

@end
