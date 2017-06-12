//
//  RefundDetailsTwoCell.h
//  BianMin
//
//  Created by 席亚坤 on 17/2/23.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RefundModel;
@interface RefundDetailsTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
-(void)CellGetData:(RefundModel*)model;
@end
