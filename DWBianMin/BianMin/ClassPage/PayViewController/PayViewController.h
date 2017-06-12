//
//  PayViewController.h
//  BianMin
//
//  Created by kkk on 16/5/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class RequestPayOrderModel;
@class RequestMerchantGoodsListModel;
@interface PayViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wxPayImage;
@property (nonatomic, strong) RequestMerchantGoodsListModel *goodsModel;
@property (nonatomic, assign) CGFloat sumPrice;
@property (nonatomic, assign) NSInteger goodsNum;
@property (weak, nonatomic) IBOutlet UIImageView *payImage;
//存储订单号
@property (nonatomic, strong) RequestPayOrderModel *payOrderModel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *onePriceLabel;

@end
