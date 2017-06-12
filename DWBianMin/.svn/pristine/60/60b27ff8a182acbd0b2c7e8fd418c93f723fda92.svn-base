//
//  OrderViewController.h
//  BianMin
//
//  Created by z on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
//0-未付款  1-已付款  2-退款中  3-等待评价   4-已经退款  5-取消订单 6-已完成
typedef enum {
    OrderStatusAll = 7,
    OrderStatusWaitForPay = 0,
    OrderStatusWaitForUse = 1,
    OrderStatusWaitForComment = 3,
    OrderStatusWaitForRefund = 2,
    OrderStatusHaveRefunded = 4,
    OrderStatusCancle = 5,
    OrderStatusComplete = 6,
}OrderStatus;

@interface OrderViewController : BaseViewController

@property (nonatomic ,copy) NSString *isNew;
@property (nonatomic, assign) NSInteger newKind;
- (void)getCurrentStatus:(OrderStatus)status;
- (void)setTitle:(NSString *)str;
@end
