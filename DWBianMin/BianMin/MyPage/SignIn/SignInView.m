//
//  SignInView.m
//  BianMin
//
//  Created by kkk on 16/5/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SignInView.h"
#define WeekLabelW (Width - 20)/7

@interface SignInView ()
@property (nonatomic, strong)NSArray *weekArray;
@property (nonatomic, strong)NSArray *dayArray;
@end

@implementation SignInView
- (NSArray *)weekArray {
    if (!_weekArray) {
        self.weekArray = @[@"周末",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    return _weekArray;
}

- (NSArray *)dayArray {
    if (!_dayArray) {
        self.dayArray = @[@"25",@"26",@"27",@"28",@"29",@"30",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"];
    }
    return _dayArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.monthLabel = [UILabel new];
    self.monthLabel.textColor = [UIColor colorWithHexString:@"#fa7251"];
    self.monthLabel.text = @"五月";
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.monthLabel];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:@"#fa7251"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.monthLabel.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@(1));
    }];
    
    for (int i = 0; i < 7; i++) {
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + i * WeekLabelW, 35, WeekLabelW, 20)];
        weekLabel.text = self.weekArray[i];
        weekLabel.font = [UIFont systemFontOfSize:12];
        weekLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:weekLabel];
    }
    
//    UILabel *firstLine = [UILabel new];
//    firstLine.backgroundColor = [UIColor colorWithHexString:kTitleColor];
//    [self addSubview:firstLine];
//    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line.mas_bottom).with.offset(25);
//        make.left.equalTo(self).with.offset(10);
//        make.right.equalTo(self).with.offset(-10);
//        make.height.mas_equalTo(@(1));
//    }];
//    
//    UILabel *secondLine = [UILabel new];
//    secondLine.backgroundColor = [UIColor colorWithHexString:kTitleColor];
//    [self addSubview:secondLine];
//    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(firstLine.mas_bottom);
//        make.left.equalTo(self).with.offset(10);
//        make.width.mas_equalTo(@(1));
//        make.height.mas_equalTo(@((Width-20)*5/7));
//    }];
//    
//    
//    UILabel *thirdLine = [UILabel new];
//    thirdLine.backgroundColor = [UIColor colorWithHexString:kTitleColor];
//    [self addSubview:thirdLine];
//    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(secondLine.mas_bottom);
//        make.left.equalTo(secondLine);
//        make.width.mas_equalTo(@(Width - 20));
//        make.height.mas_equalTo(@(1));
//    }];
//    
//    
//    UILabel *fourthLine = [UILabel new];
//    fourthLine.backgroundColor = [UIColor colorWithHexString:kTitleColor];
//    [self addSubview:fourthLine];
//    [fourthLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(firstLine.mas_bottom);
//        make.left.equalTo(firstLine.mas_right).with.offset(-1);
//        make.bottom.equalTo(thirdLine);
//        make.width.mas_equalTo(@(1));
//    }];
    
    int count = 0;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 7; j++) {
            UIButton *dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [dayBtn setTitle:self.dayArray[count] forState:UIControlStateNormal];
            [dayBtn addTarget:self action:@selector(datBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [dayBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            dayBtn.layer.borderColor = [UIColor colorWithHexString:kSubTitleColor].CGColor;
            dayBtn.layer.borderWidth = 1;
            dayBtn.frame = CGRectMake(13.5+ j * (WeekLabelW), 57 + i * (WeekLabelW - 1), WeekLabelW, WeekLabelW);
            [self addSubview:dayBtn];
            count++;
        }
    }
}

- (void)datBtnAction:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        sender.backgroundColor = [UIColor colorWithHexString:kSubTitleColor];
    }else {
        sender.selected = NO;
        sender.backgroundColor = [UIColor whiteColor];
    }

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
