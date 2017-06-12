//
//  ThirdUserModel.h
//  BianMin
//
//  Created by kkk on 16/6/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdUserModel : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *gender;

@end
