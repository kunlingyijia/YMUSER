//
//  RequestActiveInfoModel.h
//  BianMin
//
//  Created by kkk on 16/6/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestActiveInfoModel : NSObject

@property (nonatomic ,copy) NSString *logoUrl;
@property (nonatomic ,copy) NSString *activeId;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic , strong) NSArray *merchant;

@end
