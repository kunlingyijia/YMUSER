//
//  ThreeAdView.m
//  BianMin
//
//  Created by z on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ThreeAdView.h"
#import "RequestActiveListModel.h"
@interface ThreeAdView()

@property (nonatomic, strong) UILabel *ad1Title;
@property (nonatomic, strong) UILabel *ad1SubTitle;
@property (nonatomic, strong) UIImageView *ad1ImageView;
@property (nonatomic, strong) UIButton *btn1;

@property (nonatomic, strong) UILabel *ad2Title;
@property (nonatomic, strong) UILabel *ad2SubTitle;
@property (nonatomic, strong) UIImageView *ad2ImageView;
@property (nonatomic, strong) UIButton *btn2;

@property (nonatomic, strong) UILabel *ad3Title;
@property (nonatomic, strong) UILabel *ad3SubTitle;
@property (nonatomic, strong) UIImageView *ad3ImageView;
@property (nonatomic, strong) UIButton *btn3;

@property (nonatomic, strong) NSMutableArray *container;
@property (nonatomic, strong) NSArray *modelArr;

@end

@implementation ThreeAdView

- (NSMutableArray *)container {
    if (!_container) {
        self.container  = [NSMutableArray arrayWithCapacity:0];
    }
    return _container;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource withController:(BaseViewController *)vc {
    self.modelArr = dataSource;
    for (int i = 0; i < dataSource.count; i++) {
        RequestActiveListModel *model = dataSource[i];
        [self.container addObject:model.activeId];
    }
    switch (dataSource.count) {
        case 1:
            [self createOneView:dataSource withController:vc];
            break;
        case 2:
            [self createTwoView:dataSource withController:vc];
            break;
        case 3:
            [self createThirdView:dataSource withController:vc];
            break;
        default:
            break;
    }
    if (dataSource.count > 2) {
        [self createThirdView:dataSource withController:vc];
    }
}

- (void)createOneView:(NSArray *)arr withController:(BaseViewController *)vc  {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self addSubview:headView];
    RequestActiveListModel *model = arr[0];

    self.ad1Title = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, Width - self.frame.size.height, 20)];
    self.ad1Title.font = [UIFont systemFontOfSize:14];
    self.ad1Title.textAlignment = NSTextAlignmentCenter;
    self.ad1Title.text = model.title;
    self.ad1Title.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.ad1Title];
    
    self.ad1SubTitle = [[UILabel alloc] init];
    self.ad1SubTitle.font = [UIFont systemFontOfSize:12];
    self.ad1SubTitle.text = model.content;
    self.ad1SubTitle.numberOfLines = 0;
    self.ad1SubTitle.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.ad1SubTitle];
    [self.ad1SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ad1Title.mas_bottom);
        make.left.right.equalTo(self.ad1Title);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.ad1ImageView = [[UIImageView alloc] init];
    [vc loadImageWithView:self.ad1ImageView urlStr:model.logoUrl];
    self.ad1ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ad1ImageView.clipsToBounds = YES;

    [self addSubview:self.ad1ImageView];
    [self.ad1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.height - 40, (self.frame.size.height - 40)/2));
    }];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10, Width, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self addSubview:footView];
    
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.frame = CGRectMake(0, 10, Width, 120);
    self.btn1.tag = 1;
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"pressBg"] forState:UIControlStateHighlighted];
    [self.btn1 addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn1];
}

- (void)createTwoView:(NSArray *)arr withController:(BaseViewController *)vc{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    [self addSubview:headView];
    RequestActiveListModel *model1 = arr[0];

    self.ad1Title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, Width/2-20, 20)];
    self.ad1Title.font = [UIFont systemFontOfSize:14];
    self.ad1Title.textAlignment = NSTextAlignmentCenter;

    self.ad1Title.text = model1.title;
    self.ad1Title.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.ad1Title];
    
    self.ad1SubTitle = [[UILabel alloc] init];
    self.ad1SubTitle.font = [UIFont systemFontOfSize:12];
    self.ad1SubTitle.textAlignment = NSTextAlignmentCenter;
    self.ad1SubTitle.text = model1.content;
    self.ad1SubTitle.numberOfLines = 0;
    self.ad1SubTitle.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:self.ad1SubTitle];
    
    self.ad1ImageView = [[UIImageView alloc] init];
    self.ad1ImageView.center = CGPointMake(Width/4, self.frame.size.height*3/4-10);
    [vc loadImageWithView:self.ad1ImageView urlStr:model1.logoUrl];
    self.ad1ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ad1ImageView.clipsToBounds = YES;
    [self addSubview:self.ad1ImageView];
    [self.ad1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-20);
        make.centerX.equalTo(self.ad1Title);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.ad1SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ad1Title.mas_bottom);
        make.right.left.equalTo(self.ad1Title);
        make.bottom.equalTo(self.ad1ImageView.mas_top);
    }];
    
    
    RequestActiveListModel *model2 = arr[1];
    self.ad2Title = [[UILabel alloc] initWithFrame:CGRectMake(Width/2+10, 20, Width/2-10, 20)];
    self.ad2Title.font = [UIFont systemFontOfSize:14];
    self.ad2Title.textAlignment = NSTextAlignmentCenter;
    self.ad2Title.text = model2.title;
    self.ad2Title.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.ad2Title];
    
    self.ad2SubTitle = [[UILabel alloc] init];
    self.ad2SubTitle.font = [UIFont systemFontOfSize:12];
    self.ad2SubTitle.textAlignment = NSTextAlignmentCenter;
    self.ad2SubTitle.text = model2.content;
    self.ad2SubTitle.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:self.ad2SubTitle];
    
    self.ad2ImageView = [[UIImageView alloc] init];

    [vc loadImageWithView:self.ad2ImageView urlStr:model2.logoUrl];
    self.ad2ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ad2ImageView.clipsToBounds = YES;
    [self addSubview:self.ad2ImageView];
    [self.ad2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ad2Title);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self).with.offset(-20);
    }];
    
    [self.ad2SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ad2Title.mas_bottom);
        make.right.left.equalTo(self.ad2Title);
        make.bottom.equalTo(self.ad2ImageView.mas_top);
    }];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10, Width, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self addSubview:footView];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.frame = CGRectMake(0, 10, Width/2, 120);
    self.btn1.tag = 1;
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"pressBg"] forState:UIControlStateHighlighted];
    [self.btn1 addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2.tag = 2;
    self.btn2.frame = CGRectMake(Width/2, 10, Width/2, 120);
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"pressBg"] forState:UIControlStateHighlighted];
    [self.btn2 addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn2];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(Width/2, 20, 1, self.frame.size.height - 40)];
    line1.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:line1];
    
}

- (void)createThirdView:(NSArray *)arr withController:(BaseViewController *)vc{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self addSubview:headView];
    
    
     RequestActiveListModel *model1 = arr[0];
    
    self.ad1Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, Width*2/5, 20)];
    self.ad1Title.font = [UIFont systemFontOfSize:14];
    self.ad1Title.textAlignment = NSTextAlignmentCenter;
    self.ad1Title.text = model1.title;
    self.ad1Title.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.ad1Title];
    
    self.ad1SubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, Width*2/5, 20)];
    self.ad1SubTitle.font = [UIFont systemFontOfSize:12];
    self.ad1SubTitle.textAlignment = NSTextAlignmentCenter;
    self.ad1SubTitle.text = model1.content;
    self.ad1SubTitle.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:self.ad1SubTitle];
    
    self.ad1ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width/5, 30, 40, 40)];
    self.ad1ImageView.center = CGPointMake(Width/5, self.frame.size.height*3/4-10);
//    self.ad1ImageView.image = [UIImage imageNamed:@"beer"];
    [vc loadImageWithView:self.ad1ImageView urlStr:model1.logoUrl];
    self.ad1ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ad1ImageView.clipsToBounds = YES;
//    self.ad1ImageView.layer.masksToBounds = YES;
//    self.ad1ImageView.layer.cornerRadius  = 20;
    [self addSubview:self.ad1ImageView];
    
    RequestActiveListModel *model2 = arr[1];
    self.ad2Title = [[UILabel alloc] initWithFrame:CGRectMake(Width*2/5+10, 20, Width*3/5-60, 20)];
    self.ad2Title.font = [UIFont systemFontOfSize:14];
    self.ad2Title.text = model2.title;
    self.ad2Title.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.ad2Title];
    
    self.ad2SubTitle = [[UILabel alloc] initWithFrame:CGRectMake(Width*2/5+10, 40, Width*3/5-60, 20)];
    self.ad2SubTitle.font = [UIFont systemFontOfSize:12];
    self.ad2SubTitle.text = model2.content;
    self.ad2SubTitle.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:self.ad2SubTitle];
    
    self.ad2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width-50, 30, 40, 40)];
    self.ad2ImageView.center = CGPointMake(Width-30, (self.frame.size.height - 20)/4+10);
//    self.ad2ImageView.image = [UIImage imageNamed:@"oldking"];
    [vc loadImageWithView:self.ad2ImageView urlStr:model2.logoUrl];
    self.ad2ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ad2ImageView.clipsToBounds = YES;
//    self.ad2ImageView.layer.masksToBounds = YES;
//    self.ad2ImageView.layer.cornerRadius  = 20;
    [self addSubview:self.ad2ImageView];
    
    RequestActiveListModel *model3 = arr[2];
    self.ad3Title = [[UILabel alloc] initWithFrame:CGRectMake(Width*2/5+10, 20+(self.frame.size.height - 20)/2, Width*3/5-60, 20)];
    self.ad3Title.font = [UIFont systemFontOfSize:14];
    self.ad3Title.text = model3.title;
    self.ad3Title.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.ad3Title];
    
    self.ad3SubTitle = [[UILabel alloc] initWithFrame:CGRectMake(Width*2/5+10, 40+(self.frame.size.height - 20)/2, Width*3/5-60, 20)];
    self.ad3SubTitle.font = [UIFont systemFontOfSize:12];
    self.ad3SubTitle.text = model3.content;
    self.ad3SubTitle.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:self.ad3SubTitle];
    
    self.ad3ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width-50, 30, 40, 40)];
    self.ad3ImageView.center = CGPointMake(Width-30, (self.frame.size.height - 20)/4*3+10);
//    self.ad3ImageView.image = [UIImage imageNamed:@"gree"];
    [vc loadImageWithView:self.ad3ImageView urlStr:model3.logoUrl];
    self.ad3ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ad3ImageView.clipsToBounds = YES;
//    self.ad3ImageView.layer.masksToBounds = YES;
//    self.ad3ImageView.layer.cornerRadius  = 20;
    [self addSubview:self.ad3ImageView];
    
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(Width*2/5, 20, 1, self.frame.size.height - 40)];
    line1.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:line1];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(Width*2/5, self.frame.size.height/2, Width*3/5-10, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:line2];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-10, Width, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self addSubview:footView];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.frame = CGRectMake(0, 10, Width*2/5, 120);
    self.btn1.tag = 1;
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"pressBg"] forState:UIControlStateHighlighted];
    [self.btn1 addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2.tag = 2;
    self.btn2.frame = CGRectMake(Width*2/5, 10, Width*3/5, (self.frame.size.height - 20)/2);
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"pressBg"] forState:UIControlStateHighlighted];
    [self.btn2 addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn2];
    
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn3.frame = CGRectMake(Width*2/5, 10+(self.frame.size.height - 20)/2, Width*3/5, (self.frame.size.height - 20)/2);
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"pressBg"] forState:UIControlStateHighlighted];
    self.btn3.tag = 3;
    [self.btn3 addTarget:self action:@selector(adClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn3];
}


- (void)adClick:(UIButton *)btn{
    NSLog(@"tag = %ld", (long)btn.tag);
//    ThreeAdModel *model = [self.container objectAtIndex:btn.tag];
    NSInteger count = btn.tag - 1;
    RequestActiveListModel *model = self.modelArr[count];
    DELEGATE_CALLBACK_ONE_PARAMETER(self.delegate, didSelect:, model);
    
    
}

@end
