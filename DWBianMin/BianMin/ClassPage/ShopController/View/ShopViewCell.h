//
//  ShopViewCell.h
//  BianMin
//
//  Created by kkk on 16/4/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestMerchantGoodsListModel;
@interface ShopViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *pictureView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *priceLabelTwo;
@property (nonatomic, strong)UILabel *alreadyNum;

- (void)cellGetData:(RequestMerchantGoodsListModel *)model WithController:(BaseViewController *)controller;


@end
