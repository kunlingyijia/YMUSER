//
//  RequestRecommendMerchantList.h
//  BianMin
//
//  Created by kkk on 16/6/24.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestRecommendMerchantList : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *merchantType;//1-团购 2-便民
///经度(新增)
@property (nonatomic, strong) NSString  *lng ;
///纬度(新增)

@property (nonatomic, strong) NSString  *lat ;




@end
