//
//  SelectedDateViewController.h
//  BianMin
//
//  Created by kkk on 16/8/11.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "GYZCalendarModel.h"
@interface SelectedDateViewController : BaseViewController

@property (nonatomic , copy)void(^selectedDateBack)(GYZCalendarModel *model);

@end
