//
//  DWClassPageViewController.h
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "RequestCateAndBusinessareaModel.h"
@class DropDownListView;

@interface DWClassPageViewController : BaseViewController

//- (instancetype)initWithType:(MerchantCategoryModel *)model;

- (void)setMerchantCategory:(RequestCateAndBusinessareaModel *)model withIndex:(NSInteger)kindIndex;
@property (nonatomic, assign) NSInteger kindClassIndex;
//标识 是跳转还是 tabbar分类  6-跳转
@property (nonatomic, assign) NSInteger isNewController;
@property (nonatomic, assign) NSInteger newCount;
@property (nonatomic, strong)DropDownListView *dropDownView;
@property (nonatomic, strong) RequestCateAndBusinessareaModel *model;


@end
