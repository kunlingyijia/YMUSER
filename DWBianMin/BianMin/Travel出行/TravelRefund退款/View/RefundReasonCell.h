//
//  RefundReasonCell.h
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ReturnRefundReasonCell)(NSString *str);


@interface RefundReasonCell : UITableViewCell

///"不想拼车了"
@property (weak, nonatomic) IBOutlet UIView *reason1View;
///"选错路线了"
@property (weak, nonatomic) IBOutlet UIView *reason2View;
///"时间预定错误"
@property (weak, nonatomic) IBOutlet UIView *reason3View;
///"其他原因"
@property (weak, nonatomic) IBOutlet UIView *reason4View;

///选择原因1
@property (weak, nonatomic) IBOutlet UIImageView *chooseReason1;
///选择原因2
@property (weak, nonatomic) IBOutlet UIImageView *chooseReason2;
///选择原因3
@property (weak, nonatomic) IBOutlet UIImageView *chooseReason3;
///选择原因4
@property (weak, nonatomic) IBOutlet UIImageView *chooseReason4;

///储存选择原因图片的数组
@property (nonatomic, strong) NSMutableArray *reasonArray;

@property(nonatomic,copy)ReturnRefundReasonCell returnRefundReasonCell;

-(void)chose:(ReturnRefundReasonCell)block;

@end
