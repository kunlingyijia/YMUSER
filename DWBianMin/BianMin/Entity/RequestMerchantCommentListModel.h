//
//  RequestMerchantCommentListModel.h
//  BianMin
//
//  Created by kkk on 16/7/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantCommentListModel : NSObject

@property (nonatomic, copy) NSString *goodsCommentId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, strong) NSArray *images;


@end
