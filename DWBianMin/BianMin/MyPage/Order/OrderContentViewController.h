//
//  OrderContentViewController.h
//  BianMin
//
//  Created by kkk on 16/5/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderContentViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLaebl;
@property (nonatomic, copy) NSString *orderNo;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;
@property (nonatomic, assign) NSInteger isPayBack;
@property (weak, nonatomic) IBOutlet UIView *firstView;

@end
