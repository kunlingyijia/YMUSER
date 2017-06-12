//
//  SignInViewCell.h
//  BianMin
//
//  Created by kkk on 16/6/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataModel;
@interface SignInViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)cellGetDataWithModel:(DataModel *)model;
@end
