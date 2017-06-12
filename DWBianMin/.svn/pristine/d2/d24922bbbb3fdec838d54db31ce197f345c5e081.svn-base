//
//  SelectedDateViewController.m
//  BianMin
//
//  Created by kkk on 16/8/11.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SelectedDateViewController.h"
#import "GYZCalendarView.h"
#import "DefineConst.h"
@interface SelectedDateViewController ()

@end

@implementation SelectedDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"选择日期";
    // Do any additional setup after loading the view.
    GYZCalendarView *calendarView = [GYZCalendarView calendarWithDays:365 showType:CalendarShowTypeMultiple frame:self.view.frame selectEnable:YES showChineseCalendar:NO];
    __weak SelectedDateViewController *weakSelf = self;
    calendarView.calendarBlock = ^(GYZCalendarModel *model) {
        weakSelf.selectedDateBack(model);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:calendarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
