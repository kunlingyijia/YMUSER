//
//  ADViewController.m
//  BianMin
//
//  Created by kkk on 16/4/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ADViewController.h"
#import "DWGuideViewController.h"
#import "DWTabBarController.h"
#define Bounds [UIScreen mainScreen].bounds
@interface ADViewController ()

@end

@implementation ADViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *ADImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Bounds.size.width, Bounds.size.height/4 * 3)];
    ADImage.image = [UIImage imageNamed:@"AD1"];
    [self.view addSubview:ADImage];
    
    UIImageView *LogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, Bounds.size.height/4*3, Bounds.size.width, Bounds.size.height/4)];
    LogoImage.image = [UIImage imageNamed:@"AD2"];
    [self.view addSubview:LogoImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self launchFirst]) {
        DWGuideViewController *userGuideViewController = [[DWGuideViewController alloc] init];
        [[UIApplication sharedApplication].delegate window].rootViewController = userGuideViewController;
            }else {
                [[UIApplication sharedApplication].delegate window].rootViewController = [[DWTabBarController alloc] init];
            }
    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([self launchFirst]) {
//        DWGuideViewController *userGuideViewController = [[DWGuideViewController alloc] init];
//        [[UIApplication sharedApplication].delegate window].rootViewController = userGuideViewController;
//            }else {
//                [[UIApplication sharedApplication].delegate window].rootViewController = [[DWTabBarController alloc] init];
//            }
//    });
}

- (BOOL)launchFirst {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        return YES;
    }
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
