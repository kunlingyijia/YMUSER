//
//  TripSearchLineController.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripSearchLineController.h"
#import "DWCalendarVC.h"
#import "TripListController.h"
@interface TripSearchLineController ()
@property (weak, nonatomic) IBOutlet UIButton *date;
@property (weak, nonatomic) IBOutlet UITextField *startPlace;
@property (weak, nonatomic) IBOutlet UITextField *endPlace;
@property(nonatomic,strong)NSString *dataStr;
@end

@implementation TripSearchLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    [self.date setTitle:[NSString weekdayStringFromDate:[NSDate date]] forState:UIControlStateNormal];
    self.dataStr =[NSString timeStringFromDate:[NSDate date]];
    self.title = @"搜索路线";
}

#pragma mark - 选择日期
- (IBAction)dateBtnAction:(UIButton *)sender {
    //Push 跳转
    
    DWCalendarVC * VC = [[DWCalendarVC alloc]init];
    __weak typeof(self) weakSelf = self;

    [VC ReturnDWCalendarVC:^(NSString *time, NSString *week) {
        
    [weakSelf.date setTitle:week forState:(UIControlStateNormal)];
        weakSelf.dataStr = time;
        NSLog(@"%@",weakSelf.dataStr);
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];

}

#pragma mark - 搜索路线
- (IBAction)searchBtnAction:(UIButton *)sender {
    if (self.startPlace.text.length==0) {
        [self showToast:@"请输入起点"];
        return;
    }
    if (self.endPlace.text.length==0) {
        [self showToast:@"请输入终点"];
        return;
    }
    
    
    TripListController *goOutController =      [[TripListController alloc] init];
    goOutController.dateStr =self.dataStr;
    goOutController.startPlace=self.startPlace.text;
    goOutController.endPlace=self.endPlace.text;
    
    [self.navigationController pushViewController:goOutController animated:YES];
}
@end
