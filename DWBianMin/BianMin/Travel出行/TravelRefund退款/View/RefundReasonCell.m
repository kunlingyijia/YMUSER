//
//  RefundReasonCell.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RefundReasonCell.h"

@implementation RefundReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.reasonArray = [[NSMutableArray alloc] init];
    [self.reasonArray addObject:self.chooseReason1];
    [self.reasonArray addObject:self.chooseReason2];
    [self.reasonArray addObject:self.chooseReason3];
    [self.reasonArray addObject:self.chooseReason4];
    [self addReasonTargetAction];
}

//懒加载
- (NSMutableArray *)reasonArray {
    if (!_reasonArray) {
        self.reasonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _reasonArray;
}

//为View添加触摸事件
- (void)addReasonTargetAction {
    //"不想拼车了"
    UITapGestureRecognizer *reason1ViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reasonViewAction:)];
    [self.reason1View addGestureRecognizer:reason1ViewTap];
    //"选错路线了"
    UITapGestureRecognizer *reason2ViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reasonViewAction:)];
    [self.reason2View addGestureRecognizer:reason2ViewTap];
    //"时间预定错误"
    UITapGestureRecognizer *reason3ViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reasonViewAction:)];
    [self.reason3View addGestureRecognizer:reason3ViewTap];
    //"其他原因"
    UITapGestureRecognizer *reason4ViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reasonViewAction:)];
    [self.reason4View addGestureRecognizer:reason4ViewTap];
}

#pragma mark - 选择退款原因的View事件
- (void)reasonViewAction:(UITapGestureRecognizer *)sender {
    
    UIView *view = sender.view;
    UIImageView *img;
    for (id imageV in view.subviews) {
        if ([imageV isKindOfClass:[UIImageView class]]) {
            img = imageV;
            if (img.tag==101) {
                    self.returnRefundReasonCell(@"1");

                }else if (img.tag==102){
                    self.returnRefundReasonCell(@"2");


                }else if (img.tag==103){
                    self.returnRefundReasonCell(@"3");


                }else if (img.tag==104){
                    self.returnRefundReasonCell(@"4");

                }

            
            
            for (int i = 0; i < self.reasonArray.count; i++) {
                UIImageView *temp = [self.reasonArray objectAtIndex:i];
                if (temp.tag == img.tag) {
                    temp.image = [UIImage imageNamed:@"yes"];
                }else {
                    temp.image = [UIImage imageNamed:@"no"];
                }
            }
        }
    }
}


-(void)chose:(ReturnRefundReasonCell)block{
    self.returnRefundReasonCell = block;
}

@end
