//
//  ReceiveIndustry.m
//  BianMin
//
//  Created by 席亚坤 on 2017/6/13.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ReceiveIndustry.h"

@interface ReceiveIndustry ()

@end

@implementation ReceiveIndustry
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //控制器通明的关键代码
    self.modalPresentationStyle =UIModalPresentationCustom;

    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end
