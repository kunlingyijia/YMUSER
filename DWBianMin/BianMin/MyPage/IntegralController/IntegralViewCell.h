//
//  IntegralViewCell.h
//  BianMin
//
//  Created by kkk on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RequestScoreGoodsListModel;
@interface IntegralViewCell : UICollectionViewCell

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *subNameLabel;
@property (nonatomic, strong)UIImageView *photoImage;
@property (nonatomic, strong)UILabel *priceLabel;

- (void)cellGetDataModel:(RequestScoreGoodsListModel *)model withController:(BaseViewController *)vc;

@end
