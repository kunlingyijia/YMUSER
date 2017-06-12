//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "DropDownListView.h"
#import "DropDownCell.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@interface DropDownListView ()
@property (nonatomic, strong) NSString *titleColor;
//判断是否在导航条上
@property (nonatomic, assign) BOOL isNvitgation;
@end



@implementation DropDownListView


//- (NSMutableArray *)hightArray {
//    if (!_hightArray) {
//        self.hightArray = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _hightArray;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate isNavigation:(BOOL)isNavigation titleColor:(NSString *)titleColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isNvitgation  = isNavigation;
        self.titleColor = titleColor;
        self.backgroundColor = [UIColor whiteColor];
        currentExtendSection = -1;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;

        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
            
            sectionNum = [self.dropDownDataSource numberOfSections];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            NSString *sectionBtnTitle = @"--";
            if ([self.dropDownDataSource respondsToSelector:@selector(PictureInSection:index:)]) {
                sectionBtnTitle = [self.dropDownDataSource PictureInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            }
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)]) {
                sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            }
            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            [sectionBtn setTitleColor:[UIColor colorWithHexString:self.titleColor] forState:UIControlStateNormal];
            sectionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            [self addSubview:sectionBtn];
            
            self.sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 16), (self.frame.size.height-12)/2, 12, 12)];
                [self.sectionBtnIv setImage:[UIImage imageNamed:@"down_dark.png"]];

            [self.sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            self.sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: self.sectionBtnIv];
            
            if (i<sectionNum && i != 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 1, frame.size.height/2)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:lineView];
            }
            
            
            
        }
        
    }
    return self;
}



-(void)sectionBtnTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];
        
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
    }

}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    [self hideExtendedChooseView];
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}
-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView.alpha = 0.2;
            
            self.mTableView.frame = rect;
        }completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView) {
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x, self.frame.origin.y + self.frame.size.height , [UIScreen mainScreen].bounds.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
        self.mTableBaseView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
//        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 240) style:UITableViewStylePlain];
        if (self.isNvitgation) {
            self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x,0, [UIScreen mainScreen].bounds.size.width, 200) style:UITableViewStylePlain];
        }else {
           self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x, self.frame.origin.y + self.frame.size.height, [UIScreen mainScreen].bounds.size.width, 240) style:UITableViewStylePlain];
        }
        
        [self.mTableView registerClass:[DropDownCell class] forCellReuseIdentifier:@"dropCell"];
        self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0)];
        self.mTableView.rowHeight = 40;
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        
    }
    
    //修改tableview的frame
//    int sectionWidth = (self.frame.size.width)/[self.dropDownDataSource numberOfSections];
    int sectionWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect rect = self.mTableView.frame;
//    rect.origin.x = sectionWidth *section;
    rect.size.width = sectionWidth;
    rect.size.height = 0;
    self.mTableView.frame = rect;
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView];
    
    //动画设置位置
    if(section == 0){
        if (self.isNewC == 6) {
            NSMutableArray *arr = [self.hightArray objectAtIndex:0];
            if (self.hightArray.count <= 6) {
                rect.size.height = self.hightArray.count * 40;
            }else {
                rect .size.height = 200;
            }
//            rect .size.height = 200;
        }else {
            NSMutableArray *arr = [self.hightArray objectAtIndex:0];
            if (arr.count <= 6) {
                rect.size.height = arr.count * 40;
            }else {
                rect .size.height = 280;
            }
//            rect .size.height = 280;
        }
        
    }else if(section == 1){
        NSMutableArray *arr = [self.hightArray objectAtIndex:1];
        if (arr.count < 6) {
            rect.size.height = arr.count * 40;
        }else {
            rect .size.height = 280;
        }
    }else {
        NSMutableArray *arr = [self.hightArray objectAtIndex:2];
        if (arr.count < 6) {
            rect.size.height = arr.count * 40;
        }else {
            rect .size.height = 280;
        }
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.mTableView.alpha = 0.2;
        
        self.mTableBaseView.alpha = 1.0;
        self.mTableView.alpha = 1.0;
        self.mTableView.frame =  rect;
    }];
    [self.mTableView reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView];
}
#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)selectedTitle:(NSString *)title {
    UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
    [currentSectionBtn setTitle:@"到底变了没有" forState:UIControlStateNormal];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:)]) {
        NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
        
        UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
        [currentSectionBtn setTitleColor:[UIColor colorWithHexString:self.titleColor] forState:UIControlStateNormal];
        [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
        
        //旋转图标
        UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
        
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];
        
        [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row];
        [self hideExtendedChooseView];
    }
}

#pragma mark -- UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dropDownDataSource numberOfRowsInSection:currentExtendSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dropCell" forIndexPath:indexPath];
    
//    static NSString * cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    cell.nameLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
    UIButton *btn = [self viewWithTag:1000+currentExtendSection];

    if (self.isNewC == 6) {
        
    }else {
        if ([cell.nameLabel.text isEqualToString:btn.titleLabel.text]) {
            cell.nameLabel.textColor = [UIColor colorWithHexString:kNavigationBgColor];
//            cell.pictureView.image = [UIImage imageNamed:[self.dropDownDataSource PictureInSelectedSection:currentExtendSection index:indexPath.row]];
        }else {
            cell.nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
//            cell.pictureView.image = [UIImage imageNamed:[self.dropDownDataSource PictureInSection:currentExtendSection index:indexPath.row]];
        }

    }
        cell.nameLabel.font = [UIFont systemFontOfSize:14];

    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
