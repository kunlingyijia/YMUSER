//
//  RequestMerchantList.h
//  BianMin
//
//  Created by kkk on 16/6/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMerchantList : NSObject

@property (nonatomic, copy) NSString *merchantCategoryId;//1便民 2家政 3餐饮 4娱乐 5酒店 6其他
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger businessAreaId;
///1-商家，2-团购套餐，3-便民服务
@property (nonatomic, strong) NSString  *serchType;


@end
