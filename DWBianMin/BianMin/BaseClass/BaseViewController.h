//
//  BaseViewController.h
//  BianMin
//
//  Created by kkk on 16/4/22.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OKDefault)(UIAlertAction*defaultaction);
typedef void(^Cancel)(UIAlertAction *cancelaction);typedef void(^ObjectBack)();
@interface BaseViewController : UIViewController
///ObjectBack
@property (nonatomic, copy) ObjectBack  Back ;


- (void)showBackBtn;
- (void)showBackBtn:(ObjectBack)Back;
- (void)popRootshowBackBtn;
//加载网络图片
- (void)loadImageWithView:(UIImageView *)imageV urlStr:(NSString *)urlStr;

//回收键盘
- (void)endEditingAction:(UIView *)endView;
//是否是登录状态
- (BOOL)isLogin;

- (void)showSuccessWith:(NSString *)str;

- (void)showProgress;
- (void)showProgressWithText:(NSString *)text;

- (void)showSucessProgress;
- (void)showSucessProgressWithText:(NSString *)text;

- (void)showErrorProgress;
- (void)showErrorProgressWithText:(NSString *)text;

- (void)hideProgress;

- (void)showToast:(NSString *)text;

///显示底图
-(void)ShowNodataView;
///移除底图
-(void)HiddenNodataView;

///确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle withOKDefault:(OKDefault)defaultaction ;
///取消确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction;
///单个确定 居下
-(void)alertSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction;
///取消确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction;
///取消-确定-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withCancel:(Cancel)cancelaction;
@end
