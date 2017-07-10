//
//  RequestBindPhoneNum.h
//  BianMin
//
//  Created by kkk on 16/6/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestBindPhoneNum : NSObject


@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *thirdPartToken;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *thirdPartUserId;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *gender;
///registrationId
@property (nonatomic, strong) NSString  *registrationId ;


@end
