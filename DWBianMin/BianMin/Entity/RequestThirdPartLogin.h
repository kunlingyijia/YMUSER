//
//  RequestThirdPartLogin.h
//  BianMin
//
//  Created by kkk on 16/6/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestThirdPartLogin : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *thirdPartToken;
@property (nonatomic, copy) NSString *thirdPartUserId;
///registrationId
@property (nonatomic, strong) NSString  *registrationId ;


@end
