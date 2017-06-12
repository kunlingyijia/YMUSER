//
//  RequestMyCouponList.h
//  BianMin
//
//  Created by kkk on 16/7/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMyCouponList : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, assign) NSInteger status;//0-全部,1-未使用 ，2-已使用，3-过期
@end
