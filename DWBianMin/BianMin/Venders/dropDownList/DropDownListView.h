//
//  DropDownListView.h
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownChooseProtocol.h"

#define SECTION_BTN_TAG_BEGIN   1000
#define SECTION_IV_TAG_BEGIN    3000
@interface DropDownListView : UIView<UITableViewDelegate,UITableViewDataSource>{
    NSInteger currentExtendSection;     //当前展开的section ，默认－1时，表示都没有展开
}

@property (nonatomic, assign) id<DropDownChooseDelegate> dropDownDelegate;
@property (nonatomic, assign) id<DropDownChooseDataSource> dropDownDataSource;

@property (nonatomic, strong) UIView *mSuperView;
@property (nonatomic, strong) UIView *mTableBaseView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIButton *classBtn;
@property (nonatomic, strong) UIImageView *sectionBtnIv;
@property (nonatomic, assign) NSInteger isNewC;

//动态设计弹出菜单的高度
@property (nonatomic, strong)NSMutableArray *hightArray;



- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate isNavigation:(BOOL)isNavigation titleColor:(NSString *)titleColor;
- (void)setTitle:(NSString *)title inSection:(NSInteger) section;

- (BOOL)isShow;
- (void)hideExtendedChooseView;


- (void)selectedTitle:(NSString *)title;

@end
