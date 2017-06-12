//
//  CouponView.h
//  BianMin
//
//  Created by kkk on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponViewDelegate <NSObject>

- (void)selectedCoupon:(NSInteger)num withButton:(UIButton *)btn;

@end



@interface CouponView : UIView

//- (instancetype)initWithFrame:(CGRect)frame couponNumber:(NSArray *)couponArr;

@property (nonatomic, weak)id<CouponViewDelegate> delegate;
- (void)createView:(NSArray *)couponArr;

@end
