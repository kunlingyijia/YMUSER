//
//  GoodsListVC.h
//  BianMin
//
//  Created by 席亚坤 on 17/6/1.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsListVC : BaseViewController
@property (nonatomic, copy) void(^ GoodsListVCBlock)(NSString * keyword);
///搜索关键词
@property (nonatomic, strong) NSString  *keyword ;
///1-商家，2-团购套餐，3-便民服务
@property (nonatomic, strong) NSString  *serchType ;





@end
