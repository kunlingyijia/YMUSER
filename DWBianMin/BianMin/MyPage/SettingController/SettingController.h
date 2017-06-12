//
//  SettingController.h
//  BianMin
//
//  Created by kkk on 16/4/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingController : BaseViewController
@property (nonatomic, copy) NSString *qqToken;
@property (nonatomic, copy) NSString *wechaToken;
@property (nonatomic, copy) void(^backAction)(NSString *str);
@end
