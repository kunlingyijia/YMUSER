//
//  BMselectedTimeController.m
//  BianMin
//
//  Created by kkk on 16/8/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BMselectedTimeController.h"
#import "DateHelper.h"
#import "NSDate+CalculateDay.h"
#import "KMDatePicker.h"
#import "HZQDatePickerView.h"
@interface BMselectedTimeController ()<KMDatePickerDelegate, UITextFieldDelegate>

@end

@implementation BMselectedTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showBackBtn];
    self.title = @"选择时间";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
}
- (void)createView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect = CGRectMake(0.0, 0.0, rect.size.width, 216.0);
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:rect
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDay];
    self.dateText.inputView = datePicker;
    self.dateText.delegate = self;
    
    
    datePicker =[[KMDatePicker alloc]
                 initWithFrame:rect
                 delegate:self
                 datePickerStyle:KMDatePickerStyleHourMinute];
    self.startTime.inputView = datePicker;
    self.startTime.delegate = self;
    
    datePicker =[[KMDatePicker alloc]
                 initWithFrame:rect
                 delegate:self
                 datePickerStyle:KMDatePickerStyleHourMinute];
    self.endTime.inputView = datePicker;
    self.endTime.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    _txtFCurrent = textField;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}



#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    
    if ([self.txtFCurrent isEqual:self.dateText]) {
        _txtFCurrent.text = [NSString stringWithFormat:@"%@-%@-%@", datePickerDate.year,
                             datePickerDate.month,
                             datePickerDate.day];
    }
    if ([self.txtFCurrent isEqual:self.startTime] || [self.txtFCurrent isEqual:self.endTime]) {
        if ([datePickerDate.minute integerValue]<30) {
            _txtFCurrent.text = [NSString stringWithFormat:@"%@:00", datePickerDate.hour];
        }else{
            _txtFCurrent.text = [NSString stringWithFormat:@"%@:30", datePickerDate.hour];

        }
       // _txtFCurrent.text = [NSString stringWithFormat:@"%@:%@", datePickerDate.hour,
                            // datePickerDate.minute];
    }
}


- (IBAction)sureAction:(id)sender {
    if (self.dateText.text.length == 0) {
        [self showToast:@"请选择上门日期"];
        return;
    } if (self.startTime.text.length == 0) {
        [self showToast:@"请选择起始时段"];
        return;
    }
    if (self.endTime.text.length == 0) {
        [self showToast:@"请选择结束时段"];
        return;
    }
    
    
    NSString *a = [self.startTime.text stringByReplacingOccurrencesOfString:@":" withString:@""];//该方法是去掉指定符号
    //NSString * endTimeStr = [self.endTime.text substringToIndex:10];
    NSString *b = [self.endTime.text stringByReplacingOccurrencesOfString:@":" withString:@""];//该方法是去掉指定符号
    if ([a intValue]>=[b intValue  ]) {
        [self showToast:@"上门时段选择有误"];
        return;
    }else{
        
    }
    
    
        self.backBlockAction(self.dateText.text, self.startTime.text, self.endTime.text);
        [self.navigationController popViewControllerAnimated:YES];
    
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
