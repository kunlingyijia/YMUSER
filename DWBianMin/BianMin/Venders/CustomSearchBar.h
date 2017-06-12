//
//  CustomSearchBar.h
//  CustomSearchBarDemo
//
//  Created by 王春平 on 16/3/8.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击搜索按钮，调用block，用于外界做赋值、加载数据等操作
typedef void(^ReturnBlock)(UITextField *textField);

@interface CustomSearchBar : UIView 

@property (nonatomic, copy) ReturnBlock block;

- (void)getBlockFromOutSpace:(ReturnBlock)block;
@property (nonatomic, copy)void(^beginSearch)(UITextField *textField);
@property (nonatomic, copy)void(^endSearch)(NSString *str);
@end
