//
//  SearchBarView.m
//  jdmobile
//
//  Created by matrix on 15/6/13.
//  Copyright (c) 2015年 SYETC02. All rights reserved.
//

#import "DWSearchBarView.h"
#import "Masonry.h"
//#import "DN-Prefix.pch"
//#import "UIImage+Extension.h"

#define kXMargin 8
#define kYMargin 4
#define kIconSize 15

#define kSearchBarHeight 30

@interface DWSearchBarView ()

@property (nonatomic) UIImageView *searchIcon;
@property (nonatomic) RoundedView *backgroundView;


@end

@implementation DWSearchBarView

#pragma mark - Initializers

- (void)setDefaults {
    
    NSUInteger boundsWidth = self.bounds.size.width;
    NSUInteger boundsHeight= self.bounds.size.height;
    //Background Rounded White Image
    self.backgroundView = [[RoundedView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight)];
    [self addSubview:self.backgroundView];
    
    self.adressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.adressBtn.frame = CGRectMake(0, 0, kSearchBarHeight+20, kSearchBarHeight);
    [self.adressBtn setTitle:@"" forState:UIControlStateNormal];
    self.adressBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.adressBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.adressBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.adressBtn addTarget:self action:@selector(adressActive:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.adressBtn];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_jiantou_down_normal"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self.backgroundView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.adressBtn);
        make.left.equalTo(self.adressBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.adressBtn.frame)+20, 0, self.backgroundView.frame.size.width*2/3-10, self.backgroundView.frame.size.height-5)];
    img.image = [UIImage imageNamed:@"home_sreach_bg-1"];
    
    [self.backgroundView addSubview:img];
    
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(img.frame)+10, 0, boundsWidth - kIconSize*4, boundsHeight)];
    [self.searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIFont *defaultFont = [UIFont fontWithName:@"Avenir Next" size:12];
    self.searchButton.titleLabel.font=defaultFont;
    [self.searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(pressedSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchButton];
    
    // Button
    self.searchIcon = [[UIImageView alloc] init];
    [self.searchIcon setImage:[UIImage imageNamed:@"magn_glass"]  ];
    
//    self.searchIcon.contentMode = UIViewContentModeScaleAspectFit;
//    self.searchIcon.center = CGPointMake( (kIconSize/2 + kXMargin), CGRectGetMidY(self.bounds));
    //[self.searchIcon addTarget:self action:@selector(pressedAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backgroundView addSubview:self.searchIcon];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_top).with.offset(5);
        make.right.mas_equalTo(img.mas_right).with.offset(-5);
        make.bottom.mas_equalTo(img.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(@(img.frame.size.height - 10));
    }];
    
    
    
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    
    CGRect newFrame = frame;
    frame.size.height = kSearchBarHeight;
    frame = newFrame;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

//- (id)init
//{
//    return [self initWithFrame:CGRectMake(10, 20, 300, 32)];
//}

- (void)adressActive:(id)sender {
    if ([self.delegate respondsToSelector:@selector(adressSelected:)]) {
        [self.delegate adressSelected:nil];
    }
}

- (void)pressedSearch: (id)sender {
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
        [self.delegate searchBarSearchButtonClicked:self];
}

- (void)pressedAudio: (id)sender {
    
    if ([self.delegate respondsToSelector:@selector(searchBarAudioButtonClicked:)])
        [self.delegate searchBarAudioButtonClicked:self];
}
@end

@implementation RoundedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

