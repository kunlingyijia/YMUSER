//
//  FourShopCell.h
//  BianMin
//
//  Created by kkk on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMerchantCommentListModel.h"
@class CWStarRateView;
@interface FourShopCell : UITableViewCell

@property (nonatomic, copy)void(^goMyCenterBlock)(NSString *);

@property (nonatomic, strong)UILabel *talkNum;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIView *pictureArrView;
@property (nonatomic, strong)NSArray *pictureArray;
//头像
@property (nonatomic, strong)UIImageView *photoImage;
@property (nonatomic, strong)UILabel *userName;
@property (nonatomic, assign)CGFloat starNum;
@property (nonatomic, strong) CWStarRateView *starView;
- (void)cellGetDataWith:(RequestMerchantCommentListModel *)talkModel withController:(BaseViewController *)vc;
@end
