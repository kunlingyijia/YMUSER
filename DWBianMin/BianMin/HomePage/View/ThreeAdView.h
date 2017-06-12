//
//  ThreeAdView.h
//  BianMin
//
//  Created by z on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeAdModel.h"
@class RequestActiveListModel;
@protocol ThreeAdViewDelegate <NSObject>

- (void)didSelect:(RequestActiveListModel *)model;

@end

@interface ThreeAdView : UIView

@property (nonatomic, weak) id <ThreeAdViewDelegate> delegate;

- (void)setDataSource:(NSArray *)dataSource withController:(BaseViewController *)vc;

@end
