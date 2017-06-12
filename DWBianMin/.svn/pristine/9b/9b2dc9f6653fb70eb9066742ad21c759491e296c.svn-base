//
//  BQLCalendar.h
//  BQLCalendar
//
//  Created by 毕青林 on 16/3/18.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^calendarBlock)(NSString *date);

@interface BQLCalendar : UIView

@property (nonatomic, copy) calendarBlock block;

/**
 *  init sign（draw Date）
 *
 *  @param signArray the array of This month has check-in date（format:01、02、22、31，the array can be empty）
 *  @param block 
 */
- (void)initSign:(NSArray *)signArray Touch:(calendarBlock )block;

// sign today
- (void)signToday;

@end
