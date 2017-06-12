//
//  RequestThirdPartBind.h
//  BianMin
//
//  Created by kkk on 16/7/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestThirdPartBind : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *thirdPartToken;
@property (nonatomic, copy) NSString *thirdPartUserId;

@end
