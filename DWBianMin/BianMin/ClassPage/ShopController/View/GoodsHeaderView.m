//
//  GoodsHeaderView.m
//  BianMin
//
//  Created by kkk on 16/5/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsHeaderView.h"
#import "CWStarRateView.h"
#define Space 10
#define PictureHeight Bounds.size.width/5*2
#define PriceHeight 30

@interface GoodsHeaderView ()

@end

@implementation GoodsHeaderView



- (instancetype)initWithFrame:(CGRect)frame withStar:(NSString *)str {
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewWith:str];
    }
    return self;
}


- (void)createViewWith:(NSString *)start {
    //图片
    self.pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Bounds.size.width, PictureHeight)];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:@"http://img03.tooopen.com/images/20120620/sy_201206201356228570.jpg"]];
    [self addSubview:self.pictureView];
    //价格
    UILabel *label = [UILabel new];
    label.text = @"¥";
    label.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self addSubview:label];
    self.firstPriceLabel= [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.pictureView.frame)+17, 80, PriceHeight)];
    self.firstPriceLabel.text = @"258";
    self.firstPriceLabel.font = [UIFont systemFontOfSize:25];
    self.firstPriceLabel.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    [self addSubview:self.firstPriceLabel];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.firstPriceLabel.mas_bottom).with.offset(-4);
        make.size.mas_equalTo(CGSizeMake(10, 15));
    }];
    
    
    self.secondPriceLabel= [UILabel new];
    self.secondPriceLabel.text = @"门市价:¥429";
    self.secondPriceLabel.font = [UIFont systemFontOfSize:14];
    self.secondPriceLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:self.secondPriceLabel];
    [self.secondPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstPriceLabel.mas_right);
        make.bottom.equalTo(self.firstPriceLabel).with.offset(-3);
    }];
    
    //购买
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:buyBtn];
    [buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    buyBtn.backgroundColor = [UIColor colorWithHexString:@"#ff9712"];
    [buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.layer.masksToBounds = YES;
    buyBtn.layer.cornerRadius = 50/20;
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureView.mas_bottom).with.offset(1.5*Space);
        make.right.equalTo(self.mas_right).with.offset(-Space);
        make.bottom.equalTo(self.secondPriceLabel.mas_bottom);
        make.width.mas_equalTo(@(80));
    }];
    
    UILabel *firstLine = [UILabel new];
    [self addSubview:firstLine];
    firstLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstPriceLabel.mas_bottom).with.offset(Space);
        make.left.equalTo(self.mas_left).with.offset(Space);
        make.right.equalTo(self.mas_right).with.offset(-Space);
        make.height.mas_equalTo(@(1));
    }];
    
    UIImageView *buyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_my_xiangqing_dagou"]];
    [self addSubview:buyImage];
    [buyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine.mas_bottom).with.offset(Space);
        make.left.equalTo(self.mas_left).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *buyLabel = [UILabel new];
    buyLabel.text = @" 未消费 随时退";
    buyLabel.font = [UIFont systemFontOfSize:14];
    buyLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:buyLabel];
    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyImage.mas_top);
        make.left.equalTo(buyImage.mas_right);
    }];
    //已售数量
    self.sellNumLabel = [UILabel new];
    self.sellNumLabel.text = @"已售0";
    self.sellNumLabel.font = [UIFont systemFontOfSize:14];
    self.sellNumLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self addSubview:self.sellNumLabel];
    [self.sellNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyLabel.mas_top);
        make.right.equalTo(self.mas_right).with.offset(-Space);
    }];
    
    UIImageView *sellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_class_kaquanxiangqing_yishou"]];
    [self addSubview:sellImage];
    [sellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sellNumLabel);
        make.right.equalTo(self.sellNumLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *secondLine = [UILabel new];
    secondLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self addSubview:secondLine];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyLabel.mas_bottom).with.offset(1.5*Space);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(@(Space));
    }];
    
    //星星
    CWStarRateView *starRate = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 60 , 25)];
    [starRate setNumberOfStarts:5];
    starRate.userInteractionEnabled = NO;
    starRate.scorePercent = [start floatValue]*0.2;
    [self addSubview:starRate];
    [starRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLine.mas_bottom).with.offset(Space);
        make.left.equalTo(self.mas_left).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    //评分
    UILabel *starLabel = [UILabel new];
    starLabel.text = self.starRateNum;
    starLabel.textColor = [UIColor colorWithHexString:@"#ff9712"];
    [self addSubview:starLabel];
    starLabel.font = [UIFont systemFontOfSize:14];
    [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starRate.mas_centerY);
        make.left.equalTo(starRate.mas_right).with.offset(20);
    }];
    
    self.goodsTalkLabel = [UILabel new];
    self.goodsTalkLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.goodsTalkLabel.font = [UIFont systemFontOfSize:13];
    self.goodsTalkLabel.text = @"565人评价";
    self.goodsTalkLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.goodsTalkLabel];
    [self.goodsTalkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starRate.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-Space);
    }];
    
    
    UILabel *thirdLine = [UILabel new];
    thirdLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:thirdLine];
    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starRate.mas_bottom).with.offset(Space);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(@(Space));
    }];
    
    //商家信息
    UILabel *shopMessageLabel = [UILabel new];
    shopMessageLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    shopMessageLabel.font = [UIFont systemFontOfSize:14];
    shopMessageLabel.text = @"商家信息";
    [self addSubview:shopMessageLabel];
    [shopMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdLine.mas_bottom).with.offset(Space);
        make.left.equalTo(self.mas_left).with.offset(Space);
    }];
    //商家评论
    self.shopTalkLabel = [UILabel new];
    self.shopTalkLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.shopTalkLabel.font = [UIFont systemFontOfSize:14];
    self.shopTalkLabel.textAlignment = NSTextAlignmentRight;
    self.shopTalkLabel.text = @"";
    [self addSubview:self.shopTalkLabel];
    [self.shopTalkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shopMessageLabel.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-Space);
    }];
    
    UILabel *fourLine = [UILabel new];
    fourLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:fourLine];
    [fourLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopMessageLabel.mas_bottom).with.offset(Space);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).with.offset(Space);
        
        make.height.mas_equalTo(@(1));
    }];
    
    //店名
    self.shopName = [UILabel new];
    self.shopName.text = @"";
    self.shopName.font = [UIFont systemFontOfSize:14];
    self.shopName.textColor = [UIColor colorWithHexString:kTitleColor];
    [self addSubview:self.shopName];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourLine.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(Space);
         make.width.mas_equalTo((Width-2*Space)/5*3);
    }];
    
    //地址
    self.shopAdressLabel = [UILabel new];
    self.shopAdressLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.shopAdressLabel.text = @"";
    self.shopAdressLabel.numberOfLines = 2;
    self.shopAdressLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.shopAdressLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.shopAdressLabel];
    //    shopAdressLabel.backgroundColor = [UIColor redColor];
    [self.shopAdressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopName.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(Space);
        make.width.mas_equalTo((Width-2*Space)/5*3);
//        make.width.equalTo(self.mas_width).width/2.offset(Space);
    }];
    //图标
    UIImageView *adressImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_xiangqing_gps"]];
    adressImage.hidden = YES;
    //    adressImage.backgroundColor = [UIColor redColor];
    adressImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:adressImage];
    [adressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopAdressLabel.mas_bottom);
        make.left.equalTo(self.mas_left).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    //距离
    self.distanceLabel = [UILabel new];
    self.distanceLabel.hidden = YES;
    self.distanceLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.text = @"460m";
    [self addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adressImage.mas_top);
        make.left.equalTo(adressImage.mas_right);
    }];
    
    //立我最近
    UILabel *shortDistanceL = [UILabel new];
    shortDistanceL.text = @"离我最近";
    shortDistanceL.hidden = YES;
    shortDistanceL.textColor = [UIColor colorWithHexString:@"#ff9712"];
    shortDistanceL.font = [UIFont systemFontOfSize:14];
    [self addSubview:shortDistanceL];
    [shortDistanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLabel.mas_top);
        make.left.equalTo(self.distanceLabel.mas_right);
    }];
    
    UILabel *fifthLine = [UILabel new];
    fifthLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:fifthLine];
    [fifthLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shortDistanceL.mas_bottom).with.offset(Space);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).with.offset(Space);
        
        make.height.mas_equalTo(@(1));
    }];
    
    
    UILabel *sixthLine = [UILabel new];
    sixthLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:sixthLine];
    [sixthLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourLine.mas_bottom);
        make.bottom.equalTo(fifthLine.mas_top);
         make.left.equalTo(self.shopAdressLabel.mas_right).with.offset(30);
//        make.centerX.equalTo(self.center.x);
//         make.width.mas_equalTo((Width-2*Space)/5*3);
        make.width.mas_equalTo(@(1));
    }];
    
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [phoneBtn setImage:[UIImage imageNamed:@"btn_class_xiangqing_call"] forState:UIControlStateNormal];
//    [phoneBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopAdressLabel.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-Space);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *seventhLine = [UILabel new];
    seventhLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self addSubview:seventhLine];
    [seventhLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fifthLine.mas_bottom).with.offset(5);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@(10));
    }];
    
    self.gestAdress = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gestAdress setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateHighlighted];
    [self addSubview:self.gestAdress];
    
    [self.gestAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(fourLine);
        make.right.equalTo(sixthLine);
        make.bottom.equalTo(fifthLine);
    }];
    
    self.gestPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gestPhone setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateHighlighted];
     [self.gestPhone addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.gestPhone];
    [self.gestPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(fourLine);
        make.left.equalTo(sixthLine);
        make.bottom.equalTo(fifthLine);
    }];
}

#pragma mark - 打电话
- (void)phoneAction:(UIButton *)sender {
    OKLog(@"打电话");
    self.phoneAction(nil);
    
}

#pragma mark - 购买事件
- (void)buyAction:(UIButton *)sender {
    OKLog(@"购买");
    self.buyAction(nil);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end