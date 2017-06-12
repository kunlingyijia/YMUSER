//
//  RequestCollectMerchant.h
//  BianMin
//
//  Created by kkk on 16/6/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCollectMerchant : NSObject

@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, assign) NSInteger type;//1.收藏 2.取消收藏


@end
