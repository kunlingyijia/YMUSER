//
//  popView.m
//  BQLCalendar
//
//  Created by 毕青林 on 16/3/18.
//  Copyright © 2016年 毕青林. All rights reserved.
//

#import "popView.h"

@interface popView ()

@property (nonatomic, strong) UIView *showView;

@end

@implementation popView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapClick)];
        [self addGestureRecognizer:bgTap];
        
        self.backgroundColor = [UIColor clearColor];
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _showView.center = self.center;
        _showView.backgroundColor = [UIColor redColor];
        [self addSubview:_showView];
        
    }
    return self;
}

- (void)bgTapClick
{
    [self dismiss];
}

- (void)show {
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    _showView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _showView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _showView.alpha = 1;
        _showView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            _showView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                _showView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:.1 animations:^{
        _showView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _showView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            _showView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
        
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
