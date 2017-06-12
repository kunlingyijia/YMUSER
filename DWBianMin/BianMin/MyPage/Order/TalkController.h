//
//  TalkController.h
//  BianMin
//
//  Created by kkk on 16/5/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
#import "RequestMyGoodsOrderListModel.h"
@interface TalkController : LQPhotoPickerViewController
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) RequestMyGoodsOrderListModel *model;
@end
