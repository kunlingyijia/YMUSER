//
//  OnlinePayController.h
//  Go
//
//  Created by 月美 刘 on 16/8/27.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "BaseViewController.h"

@interface OnlinePayController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OContentSizeHeight;  //可滑动高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderBgHeight;
@property (weak, nonatomic) IBOutlet UITextView *remark;          //备注
@property (weak, nonatomic) IBOutlet UIImageView *merchantImage;  //商家图片
@property (weak, nonatomic) IBOutlet UILabel *merchantName;       //商家名称
@property (weak, nonatomic) IBOutlet UILabel *merchantDescribe;   //商家描述
@property (weak, nonatomic) IBOutlet UILabel *price;              //价格

@property (weak, nonatomic) IBOutlet UIImageView *chooseZhifubao; //勾选支付宝支付
@property (weak, nonatomic) IBOutlet UIImageView *chooseWeixin;   //勾选微信支付
@property (weak, nonatomic) IBOutlet UIButton *confirmPayBtn;     //确认支付的按钮
@property (weak, nonatomic) IBOutlet UIView *aliPayBgview;

@property (weak, nonatomic) IBOutlet UIView *orderBgview;


- (IBAction)ConfirmPayBtnClick:(id)sender;  //确认支付按钮的触发事件
@property (weak, nonatomic) IBOutlet UIView *wxPayBgview;

@property (nonatomic, copy) NSString *orderNo;
///订单Id(新增)
@property (nonatomic, strong) NSString  *bminOrderId ;



@end
