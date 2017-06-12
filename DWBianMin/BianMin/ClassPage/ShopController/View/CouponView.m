//
//  CouponView.m
//  BianMin
//
//  Created by kkk on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CouponView.h"
#import "RequestMerchantCouponListModel.h"
#define Space 10
#define ImageWidth (Bounds.size.width - 40)/3
#define ImageHeight (ImageWidth)*3/5
#define SpaceY 5
@interface CouponView ()

@property (nonatomic, strong)NSArray *arr;
@end


@implementation CouponView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
    
}

- (void)createView:(NSArray *)couponArr  {
    NSLog(@"%lu", (unsigned long)couponArr.count);
    for (int i = 0 ; i < couponArr.count; i++) {
        RequestMerchantCouponListModel *model = couponArr[i];
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        if (i < 3) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            bgView.frame = CGRectMake(Space +  i * (ImageWidth + Space), SpaceY, ImageWidth, ImageHeight);
            [bgView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.bottom.equalTo(bgView);
            }];
            btn.tag = 1000+i;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *getLabel = [UILabel new];
            [bgView addSubview:getLabel];
            getLabel.textAlignment = NSTextAlignmentCenter;
            getLabel.font = [UIFont systemFontOfSize:10];
            getLabel.backgroundColor = [UIColor whiteColor];
            [getLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bgView).with.offset(-10);
                make.right.equalTo(bgView).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(ImageWidth/2, ImageWidth/2/5));
            }];
            
            if (model.couponType == 1) {
                if (model.isReceived == 1) {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_manjian_yilingqu"] forState:UIControlStateNormal];
                    getLabel.text = @"已经领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#555555"];
                    btn.userInteractionEnabled = NO;
                }else {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_manjian"] forState:UIControlStateNormal];
                    getLabel.text = @"立即领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#cb264e"];
                }
                UILabel *contentLabel = [UILabel new];
                [bgView addSubview:contentLabel];
                contentLabel.font = [UIFont systemFontOfSize:6];
                contentLabel.textColor = [UIColor whiteColor];
                contentLabel.textAlignment = NSTextAlignmentCenter;
                contentLabel.text = [NSString stringWithFormat:@"满%.0f元,立减%.2f元", model.mPrice, model.mVaule];
                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bgView);
                    make.left.equalTo(getLabel).with.offset(-10);
                    make.bottom.equalTo(getLabel.mas_top);
                    make.height.mas_equalTo(@(10));
                }];
                UILabel *moneyLabel = [UILabel new];
                [bgView addSubview:moneyLabel];
                moneyLabel.text = @"¥";
                moneyLabel.font = [UIFont systemFontOfSize:12];
                moneyLabel.textColor = [UIColor whiteColor];
                [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(17);
                    make.centerX.equalTo(bgView);
                    make.size.mas_equalTo(CGSizeMake(10, 10));
                }];
                UILabel *priceLabel = [UILabel new];
                [bgView addSubview:priceLabel];
                priceLabel.text = [NSString stringWithFormat:@"%.0f", model.mVaule];
                priceLabel.textColor = [UIColor whiteColor];
                [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(10);
                    make.left.equalTo(moneyLabel.mas_right);
                    make.size.mas_equalTo(CGSizeMake(50, 20));
                }];
            }else if (model.couponType == 2){
                UILabel *getLabel = [UILabel new];
                [bgView addSubview:getLabel];
                getLabel.textAlignment = NSTextAlignmentCenter;
                getLabel.font = [UIFont systemFontOfSize:10];
                getLabel.backgroundColor = [UIColor whiteColor];
                [getLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(bgView).with.offset(-10);
                    make.right.equalTo(bgView).with.offset(-10);
                    make.size.mas_equalTo(CGSizeMake(ImageWidth/2, ImageWidth/2/5));
                }];

                if (model.isReceived == 1) {
                    getLabel.text = @"已经领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#555555"];
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_lijian_yilingqu"] forState:UIControlStateNormal];
                    btn.userInteractionEnabled = NO;
                }else {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_lijian"] forState:UIControlStateNormal];
                    getLabel.text = @"立即领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#cb264e"];
                }
                UILabel *moneyLabel = [UILabel new];
                [bgView addSubview:moneyLabel];
                moneyLabel.text = @"¥";
                moneyLabel.font = [UIFont systemFontOfSize:12];
                moneyLabel.textColor = [UIColor whiteColor];
                [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(17);
                    make.centerX.equalTo(bgView);
                    make.size.mas_equalTo(CGSizeMake(10, 10));
                }];
                UILabel *priceLabel = [UILabel new];
                [bgView addSubview:priceLabel];
                priceLabel.text = [NSString stringWithFormat:@"%.0f", model.lValue];
                priceLabel.textColor = [UIColor whiteColor];
                [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(10);
                    make.left.equalTo(moneyLabel.mas_right);
                    make.size.mas_equalTo(CGSizeMake(50, 20));
                }];

            }else {
                if (model.isReceived == 1) {
                    getLabel.text = @"已经领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#555555"];
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_zhekou_yilingqu"] forState:UIControlStateNormal];
                    btn.userInteractionEnabled = NO;
                }else {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_zhekou"] forState:UIControlStateNormal];
                    getLabel.text = @"立即领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#cb264e"];
                }
                UILabel *moneyLabel = [UILabel new];
                [bgView addSubview:moneyLabel];
                moneyLabel.textAlignment = NSTextAlignmentRight;
                if ((model.dValue % 10) == 0) {
                    moneyLabel.text = [NSString stringWithFormat:@"%.0f", model.dValue/10.0];
                }else {
                    moneyLabel.text = [NSString stringWithFormat:@"%.1f", model.dValue/10.0];
                }
                moneyLabel.textColor = [UIColor whiteColor];
                [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(10);
                    make.centerX.equalTo(bgView);
                    make.size.mas_equalTo(CGSizeMake(30, 20));
                }];
                UILabel *priceLabel = [UILabel new];
                [bgView addSubview:priceLabel];
                priceLabel.text = @" 折";
                priceLabel.font = [UIFont systemFontOfSize:12];
                priceLabel.textColor = [UIColor whiteColor];
                [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(16);
                    make.left.equalTo(moneyLabel.mas_right);
                    make.size.mas_equalTo(CGSizeMake(20, 10));
                }];
                
            }
            
        }else if(i  > 2 && i  < 6) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            bgView.frame = CGRectMake(Space +  (i-3) * (ImageWidth + Space), 2*SpaceY+ImageHeight, ImageWidth, ImageHeight);
            [bgView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.bottom.equalTo(bgView);
            }];
            btn.tag = 1000+i;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *getLabel = [UILabel new];
            [bgView addSubview:getLabel];
            getLabel.backgroundColor = [UIColor grayColor];
            getLabel.textAlignment = NSTextAlignmentCenter;
            getLabel.font = [UIFont systemFontOfSize:10];
            getLabel.backgroundColor = [UIColor whiteColor];
            [getLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bgView).with.offset(-10);
                make.right.equalTo(bgView).with.offset(-5);
                make.size.mas_equalTo(CGSizeMake(ImageWidth/2, ImageWidth/2/5));
            }];
            if (model.couponType == 1) {
                if (model.isReceived == 1) {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_manjian_yilingqu"] forState:UIControlStateNormal];
                    getLabel.text = @"已经领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#555555"];
                    btn.userInteractionEnabled = NO;
                }else {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_manjian"] forState:UIControlStateNormal];
                    getLabel.text = @"立即领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#cb264e"];
                }
                UILabel *contentLabel = [UILabel new];
                [bgView addSubview:contentLabel];
                contentLabel.font = [UIFont systemFontOfSize:6];
                contentLabel.textColor = [UIColor whiteColor];
                contentLabel.textAlignment = NSTextAlignmentCenter;
                contentLabel.text = [NSString stringWithFormat:@"满%.0f元,立减%.0f元", model.mPrice, model.mVaule];
                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bgView);
                    make.left.equalTo(getLabel).with.offset(-10);
                    make.bottom.equalTo(getLabel.mas_top);
                    make.height.mas_equalTo(@(10));
                }];
                UILabel *moneyLabel = [UILabel new];
                [bgView addSubview:moneyLabel];
                moneyLabel.text = @"¥";
                moneyLabel.font = [UIFont systemFontOfSize:12];
                moneyLabel.textColor = [UIColor whiteColor];
                [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(17);
                    make.centerX.equalTo(bgView);
                    make.size.mas_equalTo(CGSizeMake(10, 10));
                }];
                UILabel *priceLabel = [UILabel new];
                [bgView addSubview:priceLabel];
                priceLabel.text = [NSString stringWithFormat:@"%.0f", model.mVaule];
                priceLabel.textColor = [UIColor whiteColor];
                [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(10);
                    make.left.equalTo(moneyLabel.mas_right);
                    make.size.mas_equalTo(CGSizeMake(50, 20));
                }];
            }else if (model.couponType == 2){
                UILabel *getLabel = [UILabel new];
                [bgView addSubview:getLabel];
                getLabel.textAlignment = NSTextAlignmentCenter;
                getLabel.font = [UIFont systemFontOfSize:10];
                getLabel.backgroundColor = [UIColor whiteColor];
                [getLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(bgView).with.offset(-10);
                    make.right.equalTo(bgView).with.offset(-10);
                    make.size.mas_equalTo(CGSizeMake(ImageWidth/2, ImageWidth/2/5));
                }];
                
                if (model.isReceived == 1) {
                    getLabel.text = @"已经领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#555555"];
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_lijian_yilingqu"] forState:UIControlStateNormal];
                    btn.userInteractionEnabled = NO;
                }else {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_lijian"] forState:UIControlStateNormal];
                    getLabel.text = @"立即领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#cb264e"];
                }
                UILabel *moneyLabel = [UILabel new];
                [bgView addSubview:moneyLabel];
                moneyLabel.text = @"¥";
                moneyLabel.font = [UIFont systemFontOfSize:12];
                moneyLabel.textColor = [UIColor whiteColor];
                [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(17);
                    make.centerX.equalTo(bgView);
                    make.size.mas_equalTo(CGSizeMake(10, 10));
                }];
                UILabel *priceLabel = [UILabel new];
                [bgView addSubview:priceLabel];
                priceLabel.text = [NSString stringWithFormat:@"%.0f", model.lValue];
                priceLabel.textColor = [UIColor whiteColor];
                [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(10);
                    make.left.equalTo(moneyLabel.mas_right);
                    make.size.mas_equalTo(CGSizeMake(50, 20));
                }];
                
            }else {
                if (model.isReceived == 1) {
                    getLabel.text = @"已经领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#555555"];
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_zhekou_yilingqu"] forState:UIControlStateNormal];
                    btn.userInteractionEnabled = NO;
                }else {
                    [btn setImage:[UIImage imageNamed:@"bg_class_youhuiquan_zhekou"] forState:UIControlStateNormal];
                    getLabel.text = @"立即领取";
                    getLabel.textColor = [UIColor colorWithHexString:@"#cb264e"];
                }
                UILabel *moneyLabel = [UILabel new];
                [bgView addSubview:moneyLabel];
                moneyLabel.textAlignment = NSTextAlignmentRight;
                moneyLabel.text = [NSString stringWithFormat:@"%.0f", model.dValue];
                moneyLabel.textColor = [UIColor whiteColor];
                [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(10);
                    make.centerX.equalTo(bgView);
                    make.size.mas_equalTo(CGSizeMake(30, 20));
                }];
                UILabel *priceLabel = [UILabel new];
                [bgView addSubview:priceLabel];
                priceLabel.text = @" 折";
                priceLabel.font = [UIFont systemFontOfSize:12];
                priceLabel.textColor = [UIColor whiteColor];
                [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bgView).with.offset(16);
                    make.left.equalTo(moneyLabel.mas_right);
                    make.size.mas_equalTo(CGSizeMake(20, 10));
                }];
            }
        }else {
            break;
    }
        
//        else if (i  > 5 && i  < 9) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.tag = 1000+i;
//            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//            if (model.couponType == 1) {
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_manjianquan_yilingqu-拷贝"] forState:UIControlStateNormal];
//            }else if (model.couponType == 2){
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_lijianquan"] forState:UIControlStateNormal];
//            }else {
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_zhekouquan"] forState:UIControlStateNormal];
//            }
//            btn.frame = CGRectMake(Space +  (i-6) * (ImageWidth + Space), 3*SpaceY+ImageHeight*2, ImageWidth, ImageHeight);
//            [self addSubview:btn];
//        }else if (i > 8 && i < 12) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.tag = 1000+i;
//            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//            if (model.couponType == 1) {
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_manjianquan_yilingqu-拷贝"] forState:UIControlStateNormal];
//            }else if (model.couponType == 2){
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_lijianquan"] forState:UIControlStateNormal];
//            }else {
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_zhekouquan"] forState:UIControlStateNormal];
//            }
//            btn.frame = CGRectMake(Space +  (i-9) * (ImageWidth + Space), 4*SpaceY+ImageHeight*3, ImageWidth, ImageHeight);
//            [self addSubview:btn];
//        }else {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.tag = 1000+i;
//            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//            if (model.couponType == 1) {
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_manjianquan_yilingqu-拷贝"] forState:UIControlStateNormal];
//            }else if (model.couponType == 2){
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_lijianquan"] forState:UIControlStateNormal];
//            }else {
//                [btn setImage:[UIImage imageNamed:@"bg_class_shangjiaxiangqing_zhekouquan"] forState:UIControlStateNormal];
//            }
//            btn.frame = CGRectMake(Space +  (i-12) * (ImageWidth + Space), 5*SpaceY+ImageHeight*4, ImageWidth, ImageHeight);
//            [self addSubview:btn];
//        }
    }
}

- (void)btnAction:(UIButton *)sender {
    NSInteger count = sender.tag - 1000;
    if ([self.delegate respondsToSelector:@selector(selectedCoupon:withButton:)]) {
        [self.delegate selectedCoupon:count withButton:sender];
    }
}


@end
