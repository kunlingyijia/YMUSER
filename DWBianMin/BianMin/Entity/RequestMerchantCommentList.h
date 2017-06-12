//
//  RequestMerchantCommentList.h
//  BianMin
//
//  Created by kkk on 16/7/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantCommentList : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSString *merchantId;
@property (nonatomic, strong) NSString *goodsId;

@end
