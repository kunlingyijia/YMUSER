//
//  CommitOrderController.h
//  BianMin
//
//  Created by kkk on 16/5/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class RequestMerchantGoodsListModel;
@interface CommitOrderController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (nonatomic, strong) RequestMerchantGoodsListModel *goodsModel;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *merchantId;
@property (weak, nonatomic) IBOutlet UIView *couponView;

@end
