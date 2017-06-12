//
//  ReservationController.h
//  Go
//
//  Created by 月美 刘 on 16/8/27.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "BaseViewController.h"

@interface ReservationController : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RContentSizeHeight;  //可滑动高度
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *startPlace;      //出发地
@property (weak, nonatomic) IBOutlet UILabel *endPlace;        //目的地
@property (weak, nonatomic) IBOutlet UILabel *startTime;       //出发时间
@property (weak, nonatomic) IBOutlet UILabel *totalPeople;     //已预约／总人数
@property (weak, nonatomic) IBOutlet UILabel *price;           //价格
@property (weak, nonatomic) IBOutlet UILabel *driveTime;       //车程
@property (weak, nonatomic) IBOutlet UILabel *kilometer;       //公里
@property (weak, nonatomic) IBOutlet UITextField *peopleCount; //人数
@property (weak, nonatomic) IBOutlet UITextField *getOnPlace;  //上车地点
@property (weak, nonatomic) IBOutlet UITextField *endDownPlace;

@property (weak, nonatomic) IBOutlet UIButton *reservationBtn; //预约按钮
@property (weak, nonatomic) IBOutlet UIView *adressBgview;
@property (nonatomic, copy) NSString *tripId;
//声明预约的触发事件
- (IBAction)ReservationBtnClick:(id)sender;
@end
