//
//  RequestMerchantGoodsList.h
//  BianMin
//
//  Created by kkk on 16/6/23.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantGoodsList : NSObject

@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;

@end
