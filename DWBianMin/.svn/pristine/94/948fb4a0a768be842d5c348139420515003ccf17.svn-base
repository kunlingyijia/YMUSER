//
//  SignInViewCell.m
//  BianMin
//
//  Created by kkk on 16/6/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SignInViewCell.h"
#import "DataModel.h"
@implementation SignInViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataWithModel:(DataModel *)model {
    
    self.weekLabel.text = [self getWeek:model];
    self.dateLabel.text = model.signDay;
}

- (NSString *)getWeek:(DataModel *)model {
    NSLog(@"%@", model.signDay);
    NSRange day = {8,2};
    NSRange month = {5,2};
    NSRange year = {0,4};
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[[model.signDay substringWithRange:day] integerValue]];
    [_comps setMonth:[[model.signDay substringWithRange:month] integerValue]];
    [_comps setYear:[[model.signDay substringWithRange:year] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    NSLog(@"_weekday::%ld",(long)_weekday-1);
    switch (_weekday - 1) {
        case 0:
            return @"星期日";
            break;
        case 1:
            return @"星期一";
            break;
        case 2:
            return @"星期二";
            break;
        case 3:
            return @"星期三";
            break;
        case 4:
            return @"星期四";
            break;
        case 5:
            return @"星期五";
            break;
        case 6:
            return @"星期六";
            break;
        
        default:
            break;
    }
    return nil;
}

@end
