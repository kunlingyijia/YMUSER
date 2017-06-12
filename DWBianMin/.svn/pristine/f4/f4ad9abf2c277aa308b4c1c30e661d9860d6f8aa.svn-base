//
//  ThirdShopCell.h
//  BianMin
//
//  Created by kkk on 16/4/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMerchantCommentListModel.h"
@class CWStarRateView;
//制定协议
@protocol ThirdShopCellDelegate <NSObject>

- (void)touchPhotoImage:(id)sender;

@end



@interface ThirdShopCell : UITableViewCell
//代理
@property (nonatomic, weak)id<ThirdShopCellDelegate>delegate;
@property (nonatomic, strong)UILabel *talkNum;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIView *pictureArrView;
@property (nonatomic, strong)NSMutableArray *pictureArray;
//头像
@property (nonatomic, strong)UIImageView *photoImage;
@property (nonatomic, strong)UILabel *userName;
@property (nonatomic, assign)CGFloat starNum;
@property (nonatomic, strong) CWStarRateView *starView;
@property (nonatomic, strong)NSMutableArray *imagesBtn;
- (void)talkImageData:(NSMutableArray *)images;
- (void)cellGetDataWith:(RequestMerchantCommentListModel *)talkModel withController:(BaseViewController *)vc;
@end
