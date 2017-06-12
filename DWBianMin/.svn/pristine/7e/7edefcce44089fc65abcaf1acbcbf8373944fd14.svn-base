//
//  GoingOutSearchListCell.m
//  Go
//
//  Created by 月美 刘 on 16/8/12.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "GoingOutSearchListCell.h"

@implementation GoingOutSearchListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataWithModel:(RequestTripListModel *)model {
    self.carNo.text = model.carNo;
    NSLog(@"%@", model.driveTime);
    NSRange range = [model.driveTime rangeOfString:@"."];
    if ([model.driveTime containsString:@"."]) {
        NSString *hourT = [model.driveTime substringToIndex:range.location];
        
        NSInteger minth = [[model.driveTime substringFromIndex:range.location] floatValue] * 60;
        self.driveTime.text = [NSString stringWithFormat:@"%@小时%ld分", hourT,(long)minth];
    }else {
         self.driveTime.text = [NSString stringWithFormat:@"%@小时", model.driveTime];
    }
    self.price.text = [NSString stringWithFormat:@"¥%.2f", model.price];
    NSString *starT = [model.startTime substringFromIndex:10];
    NSString *endT = [model.arriveTime substringFromIndex:10];
    self.startTime.text = [starT substringToIndex:6];
    self.arriveTime.text = [endT substringToIndex:6];
    self.startPlace.text = model.startPlace;
    self.endPlace.text = model.endPlace;
    self.carType.text = model.carType;
    self.ticketNum.text = [NSString stringWithFormat:@"%@张", model.lastTicketCount];
    
}

@end
