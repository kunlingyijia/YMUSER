//
//  DWNavigationController.m
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWNavigationController.h"
#import "DWTabBarController.h"
#import "DWCommonParm.h"

@implementation DWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitilColor];
}

- (void)setTitilColor{
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:kNavigationTitleColor
                                                            ] forKey:UITextAttributeTextColor];
    self.navigationBar.titleTextAttributes = dict;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == [DWCommonParm sharedInstance].homePage || viewController == [DWCommonParm sharedInstance].merchantCategory || viewController == [DWCommonParm sharedInstance].myViewController) {
        [viewController setHidesBottomBarWhenPushed:NO];
    }else{
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
