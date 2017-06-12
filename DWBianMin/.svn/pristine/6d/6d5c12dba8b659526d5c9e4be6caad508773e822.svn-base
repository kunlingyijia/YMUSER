//
//  HomeAdModel.h
//  BianMin
//
//  Created by z on 16/5/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MerchantModel.h"

@interface HomeAdModel : NSObject

@property (nonatomic, strong) NSString *homeAdId;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, assign) NSInteger type; //0-商家1-外部链接 2-分类
@property (nonatomic, strong) NSString *targetUrl;
@property (nonatomic, strong) MerchantModel *merchant;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *categoryId;

- (void)jump:(NSInteger)type viewControll:(UIViewController *)vc;

@end
