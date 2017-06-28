//
//  DWTabBarController.m
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWTabBarController.h"
#import "DWCommonParm.h"
@interface DWTabBarController ()

@end

@implementation DWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllChildViewControllers];
}
- (void)addAllChildViewControllers {
    //设置背景
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    bgView.backgroundColor = [UIColor colorWithRed:198 / 255.0 green:198/255.0 blue:0 alpha:1.0];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    self.homePageViewController = [[DWHomePageViewController alloc] init];
    self.classPageViewController = [[DWClassPageViewController alloc] init];
    self.myViewControler = [[DWMyViewController alloc] init];
    [DWCommonParm sharedInstance].homePage = self.homePageViewController;
    [DWCommonParm sharedInstance].merchantCategory = self.classPageViewController;
    [DWCommonParm sharedInstance].myViewController = self.myViewControler;
    [self addOneChildVc:self.homePageViewController
                  title:@"首页"
              imageName:@"icon_zhuye_normal"
      selectedImageName:@"icon_zhuye_press"];
    [self addOneChildVc:self.classPageViewController
                  title:@"商家"
              imageName:@"icon_shangjia_normal"
      selectedImageName:@"icon_shangjia_press"];
    [self addOneChildVc:self.myViewControler
                  title:@"我的"
              imageName:@"icon_wode_normal"
      selectedImageName:@"icon_wode_press"];
}

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    //设置标题
    childVc.title = title;
    //设置图标
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置选中图标
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont systemFontOfSize:13], NSFontAttributeName,
                                                [UIColor colorWithHexString:kSubTitleColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont systemFontOfSize:13], NSFontAttributeName,
                                                [UIColor colorWithHexString:kNavigationBgColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //        self.tabBar.backgroundImage = [UIImage imageNamed:@"tabBar_bg"];
    //添加导航控制器
    DWNavigationController *nav = [[DWNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}





@end
