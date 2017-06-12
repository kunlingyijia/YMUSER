//
//  RequestActiveInfo.h
//  BianMin
//
//  Created by kkk on 16/6/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestActiveInfo : NSObject

@property (nonatomic, copy) NSString *activeId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@end
