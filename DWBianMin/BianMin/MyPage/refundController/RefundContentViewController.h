//
//  RefundContentViewController.h
//  BianMin
//
//  Created by kkk on 16/5/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface RefundContentViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, copy) NSString *orderNo;
///订单Id（新增）
@property (nonatomic, strong) NSString  *goodsOrderId ;


@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundLabel;

@end
