//
//  BaseViewController.m
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "MobClick.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"

@interface BaseViewController ()

@property (nonatomic ,strong) UIView *activeV;
@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *yiminL;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *webBtn;
@property(nonatomic,strong)UIView * baseBottomView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

    
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBg alpha:1];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self initWithDefaultProgressHub];
    //增加监听，当键盘出现或改变时收出消息
}










- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:[self.class description]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:[self.class description]];;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    UIImageView *navBarHairlineImageView;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
    self.view.userInteractionEnabled = YES;

}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;

}
- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBack:)
      forControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismiss:(UIButton*)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)popRootshowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(popRootdoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
}
- (void)showBackBtn:(ObjectBack)Back{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBlockBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    
#pragma mark ----- 屏幕边缘平移手势
    
//    //屏幕边缘移动手势
//    //创建屏幕边缘平移手势
//    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBlockBack:)];
//    
//    //设置平移的屏幕边界
//    
//    screenEdgePanGesture.edges = UIRectEdgeLeft;
//    //添加到视图
//    
//    [self.view addGestureRecognizer:screenEdgePanGesture];
    self.Back = Back;
}


- (void)doBlockBack:(id)sender{
    self.Back();
}
- (void)popRootdoBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//回收键盘
- (void)endEditingAction:(UIView *)endView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endtapAction:)];
    [endView addGestureRecognizer:tap];
}

- (void)endtapAction:(UITapGestureRecognizer *)sender {
    UIView *endV = sender.view;
    [endV endEditing:YES];
}

#pragma mark - 加载网络图片
//加载网络图片
- (void)loadImageWithView:(UIImageView *)imageV urlStr:(NSString *)urlStr {
    DWHelper *helper = [DWHelper shareHelper];
    if (helper.isWifiOn) {
        if ([helper.netWorking isEqualToString:@"wifi"]) {
            [imageV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        }else {
            imageV.image = [UIImage imageNamed:@"bg_zaijia_1-1"];
        }
    }else {
        if (urlStr == nil) {
            imageV.image = [UIImage imageNamed:@"bg_zaijia_1-1"];
        }else {
            NSLog(@"%@", urlStr);
           [imageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"bg_zaijia_1-1"]];
        }
    }
    
}
//是否是登录状态
- (BOOL)isLogin {
    DWHelper *helper = [DWHelper shareHelper];
    if ([helper.isLogin integerValue]==1) {
        return YES;
    }
    return NO;
}

- (void)showSuccessWith:(NSString *)str {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToast:str];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithDefaultProgressHub{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)showProgressWithText:(NSString *)text{
    [SVProgressHUD showWithStatus:text];
}

- (void)hideProgress{
    [SVProgressHUD dismiss];
}

- (void)showSucessProgress{
    [SVProgressHUD showInfoWithStatus:@"成功！"];
}

- (void)showSucessProgressWithText:(NSString *)text{
    [SVProgressHUD showInfoWithStatus:text];
}

- (void)showErrorProgress{
    [SVProgressHUD showErrorWithStatus:@"失败"];
}

- (void)showErrorProgressWithText:(NSString *)text{
    [SVProgressHUD showErrorWithStatus:text];
}

- (void)showToast:(NSString *)text{
    [self.view hideToastActivity];
    [self.view makeToast:text duration:1.5 position:CSToastPositionCenter];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - 显示
-(void)ShowNodataView{
    if (!_baseBottomView) {
        __weak typeof(self) weakSelf = self;
        self.baseBottomView = [[UIView alloc]initWithFrame:CGRectZero];
        [UIView animateWithDuration:0.0000001 animations:^{
            weakSelf.baseBottomView.frame =  CGRectMake(0, 0, Width, Height);
            self.baseBottomView.backgroundColor = [UIColor colorWithHexString:kViewBg];
            [self.view addSubview:_baseBottomView];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
            imageView.image = [UIImage imageNamed:@"暂无数据"];
            imageView.contentMode =  UIViewContentModeCenter;
            imageView.clipsToBounds  = YES;
            [_baseBottomView addSubview:imageView];
        } ];
        
        
    }
}
#pragma mark - 移除
-(void)HiddenNodataView{
    
    if (_baseBottomView) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            [_baseBottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            weakSelf.baseBottomView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
            [weakSelf.baseBottomView removeFromSuperview];
            weakSelf.baseBottomView = nil;
            
        }];
        
    }
    
}
#pragma mark - 确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle withOKDefault:(OKDefault)defaultaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultaction (action);
        
        
    }];
    
    //[OK setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    [alertC addAction:OK];
    [self presentViewController:alertC animated:YES completion:nil];
    
}



#pragma mark - 取消确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultaction (action);
        
        
    }];
   // [OK setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    [alertC addAction:OK];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
}
#pragma mark - 单个确定 居下
-(void)alertSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        defaultaction (action);
    }];
   // [cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

#pragma mark - 取消-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultaction (action);
        
        
    }];
    //[OK setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    [alertC addAction:OK];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark - 取消-确定-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OKOne = [UIAlertAction actionWithTitle:OKtitleOne style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionOne (action);
        
        
    }];
    //[OKOne setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction * OKTwo = [UIAlertAction actionWithTitle:OKtitleTwo style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionTwo (action);
        
        
    }];
    //[OKTwo setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    [alertC addAction:OKOne];
    [alertC addAction:OKTwo];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark - 取消-确定-确定 -确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo OKWithTitleThree:(NSString*)OKtitleThree  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withOKDefaultThree:(OKDefault)defaultactionThree withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OKOne = [UIAlertAction actionWithTitle:OKtitleOne style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionOne (action);
        
        
    }];
    //[OKOne setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction * OKTwo = [UIAlertAction actionWithTitle:OKtitleTwo style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionTwo (action);
        
        
    }];
    //[OKTwo setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    UIAlertAction * OKThree = [UIAlertAction actionWithTitle:OKtitleThree style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionThree (action);
        
        
    }];
    //[OKThree setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    [alertC addAction:OKOne];
    [alertC addAction:OKTwo];
    [alertC addAction:OKThree];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

@end
