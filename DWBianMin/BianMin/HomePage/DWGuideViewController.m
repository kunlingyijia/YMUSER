//
//  DWGuideViewController.m
//  BianMin
//
//  Created by kkk on 16/4/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWGuideViewController.h"
#import "SGFocusImageFrame.h"
#import "DWTabBarController.h"
#import "AdressSelectedController.h"
@interface DWGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) UIButton *btn;

@end


@implementation DWGuideViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setDataSource];
    [self setupViews];
    
}

- (void)setDataSource{
    UIImage *image1 = [UIImage imageNamed:@"bg_yindaoye_1"];
    NSString *text1 = @"大事小事,随传随到";
    NSString *title1 = @"一键呼叫";
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:image1, @"image", text1, @"text", title1, @"title", nil];
    
    UIImage *image2 = [UIImage imageNamed:@"bg_yindaoye_2"];
    NSString *text2 = @"足不出户,海量商品想买就买";
    NSString *title2 = @"一键下单";
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:image2, @"image", text2, @"text", title2, @"title", nil];
    
    UIImage *image3 = [UIImage imageNamed:@"bg_yindaoye_3"];
    NSString *text3 = @"积累积分,兑换精美大礼";
    NSString *title3 = @"一键签到";
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:image3, @"image", text3, @"text", title3, @"title" ,nil];
    
    self.dataSource = [NSArray arrayWithObjects:dict1, dict2, dict3, nil];
}

- (void)setupViews {
    float height = Height;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, height)];
    self.scrollView.contentSize = CGSizeMake(3*Width, height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.dataSource.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*Width, 0, Width, Height)];
        if(i == 0){
            view.backgroundColor = [UIColor colorWithHexString:@"#4abbe7"];
        }else if (i == 1){
            view.backgroundColor = [UIColor colorWithHexString:@"#3bcca5"];
        }else{
            view.backgroundColor = [UIColor colorWithHexString:@"#ffb846"];
        }
        
        NSDictionary *dict = [self.dataSource objectAtIndex:i];
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 100, Width-80,  Width-80)];
        imageView.image = [dict objectForKey:@"image"];
        [view addSubview:imageView];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+ imageView.frame.size.height + 20, Width, 20)];
        textLabel.font = [UIFont systemFontOfSize:30];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = [dict objectForKey:@"title"];
        [view addSubview:textLabel];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [dict objectForKey:@"text"];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textLabel.mas_bottom).with.offset(10);
            make.left.right.equalTo(view);
            make.height.mas_equalTo(@(30));
        }];
        [self.scrollView addSubview:view];
    }
    
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, Height - 120, Width, 20)];
    self.pageCtrl.numberOfPages = self.dataSource.count;
    [self.view addSubview:self.pageCtrl];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(100, Height - 100, Width - 200, 40);
    [self.btn setTitleColor:[UIColor colorWithHexString:@"#4abbe7"] forState:UIControlStateNormal];
    self.btn.backgroundColor = [UIColor whiteColor];
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.cornerRadius = 17;
    [self.btn setTitle:@"点击进入" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pagewidth = _scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pagewidth / 2) /pagewidth) +1;
        if (currentPage < self.dataSource.count)
    {
        self.pageCtrl.currentPage = currentPage;
        switch (currentPage) {
            case 0:
                [self.btn setTitleColor:[UIColor colorWithHexString:@"#4abbe7"] forState:UIControlStateNormal];
                break;
            case 1:
                [self.btn setTitleColor:[UIColor colorWithHexString:@"#3bcca5"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.btn setTitleColor:[UIColor colorWithHexString:@"#ffb846"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }

    
    }
    
}

- (void)click:(id)sender{
    
    
    NSString *regionName = [AuthenticationModel getRegionName];
    if (regionName == nil || regionName == NULL) {
        AdressSelectedController *adressSelected = [[AdressSelectedController alloc] init];
        adressSelected.isFrest = @"是";
        adressSelected.selectdeAdress = ^(NSString *adressStr) {
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"切换地址" object:@"切换地址" userInfo:@{}];
//            weakSelf.pageIndex = 1;
//            [weakSelf.searchView.adressBtn setTitle:adressStr forState:UIControlStateNormal];
//            [weakSelf.classKindArr removeAllObjects];
//            [weakSelf againAchiveData];
//            [weakSelf.dataSource removeAllObjects];
//            [weakSelf getShopDataWithType:self.merchantType];
        };
       
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:adressSelected];
    }else {
   [UIApplication sharedApplication].keyWindow.rootViewController = [[DWTabBarController alloc] init];
    
    };

    
    
    
}

@end
