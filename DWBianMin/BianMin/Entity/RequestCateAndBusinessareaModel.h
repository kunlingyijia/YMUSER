//
//  RequestCateAndBusinessareaModel.h
//  BianMin
//
//  Created by kkk on 16/8/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCateAndBusinessareaModel : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger isHome;
@property (nonatomic, assign) NSInteger isBmin;//1-便民
@property (nonatomic, copy) NSString *merchantCategoryId;
@property (nonatomic, strong) NSMutableArray *_child;

@end
