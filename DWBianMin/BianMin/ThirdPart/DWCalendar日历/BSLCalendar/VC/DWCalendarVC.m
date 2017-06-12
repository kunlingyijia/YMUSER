//
//  DWCalendarVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "DWCalendarVC.h"
#import "BSLCalendar.h"

@interface DWCalendarVC ()
@property(nonatomic,strong)NSString *dateStr;
@end

@implementation DWCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"选择日期";
    BSLCalendar *calendar = [[BSLCalendar alloc]initWithFrame:CGRectMake(5, 50, Width-10, Width-10)];
    [self.view addSubview:calendar];
    __weak typeof(self) weakSelf = self;
    calendar.showChineseCalendar = YES;
    [calendar selectDateOfMonth:^(NSInteger year, NSInteger month, NSInteger day) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd";
        NSString *yearstr = [NSString stringWithFormat:@"%ld",year];
         NSString *monthstr = [NSString stringWithFormat:@"%ld",month];
         NSString *daystr = [NSString stringWithFormat:@"%ld",day];
        NSString * time = [NSString stringWithFormat:@"%@-%@-%@",yearstr,monthstr,daystr];
       
        
        NSDate *data = [format dateFromString:time];
        
        weakSelf.returnDWCalendarVC(time,[NSString weekdayStringFromDate:data]);
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];

}

-(void)ReturnDWCalendarVC:(ReturnDWCalendarVC)block{
    self.returnDWCalendarVC = block;
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
