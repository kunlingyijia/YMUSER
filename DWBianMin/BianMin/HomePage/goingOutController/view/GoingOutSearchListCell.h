//
//  GoingOutSearchListCell.h
//  Go
//
//  Created by 月美 刘 on 16/8/12.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestTripListModel.h"
@interface GoingOutSearchListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNo;      //车牌号
@property (weak, nonatomic) IBOutlet UILabel *startTime;  //出发时间
@property (weak, nonatomic) IBOutlet UILabel *arriveTime; //到达时间
@property (weak, nonatomic) IBOutlet UILabel *driveTime;  //车程
@property (weak, nonatomic) IBOutlet UILabel *startPlace; //出发地
@property (weak, nonatomic) IBOutlet UILabel *endPlace;   //目的地
@property (weak, nonatomic) IBOutlet UILabel *price;      //价格
@property (weak, nonatomic) IBOutlet UILabel *carType;    //车类型
@property (weak, nonatomic) IBOutlet UIView *ticketCount; //车票数
@property (weak, nonatomic) IBOutlet UILabel *ticketNum;

- (void)cellGetDataWithModel:(RequestTripListModel *)model;

@end
