//
//  UserOrderViewController.m
//  BianMin
//
//  Created by kkk on 16/5/17.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UserOrderViewController.h"
#import "LBXScanWrapper.h"
#import "DrawView.h"
#import "RequestMyGoodsOrderDetail.h"
#import "RequestMyGoodsOrderDetailModel.h"
#define Space 5
@interface UserOrderViewController ()
@property (nonatomic, strong) UIImageView* qrImgView;
@property (nonatomic, strong) RequestMyGoodsOrderDetailModel *messageModel;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIView *container;
@end

@implementation UserOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newShowBackBtn];
    self.title = @"优惠券";
    self.scroller = [UIScrollView new];
    self.scroller.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scroller];
    [self.scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.left.bottom.equalTo(self.view);
    }];
    self.container = [UIView new];
    [self.scroller addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroller);
        make.width.equalTo(self.scroller);
    }];
    if ([self.isUse isEqualToString:@"6"]) {
        [self createView];
    } else {
        [self getDataMessage];
    }
}

- (void)newShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(newDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)newDoBack:(id)sender{
    self.backAction(nil);
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)getDataMessage {
    RequestMyGoodsOrderDetail *detail = [[RequestMyGoodsOrderDetail alloc] init];
    detail.orderNo = self.model.orderNo;
    detail.goodsOrderId = self.model.goodsOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[detail yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyGoodsOrderDetail" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        
        if (baseRes.resultCode == 1) {
            self.messageModel = [RequestMyGoodsOrderDetailModel yy_modelWithJSON:baseRes.data];
        }else {
           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self createCouponsView];
    } faild:^(id error) {

    }];
}






- (void)createCouponsView {
 
    for (int i = 0; i < self.messageModel.coupons.count; i++) {
        NSDictionary *dic = self.messageModel.coupons[i];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 10 + i *(Width/2 + 10), Width - 40, Width/2)];
        bgView.backgroundColor = [UIColor redColor];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.container addSubview:bgView];
        UIImageView *pictureView = [[UIImageView alloc] init];
        pictureView.contentMode = UIViewContentModeScaleAspectFill;
        pictureView.clipsToBounds = YES;
        pictureView.hidden = YES;
        pictureView.backgroundColor = [UIColor redColor];
        [pictureView sd_setImageWithURL:[NSURL URLWithString:self.model.originUrl]];
        [bgView addSubview:pictureView];
        [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(bgView).with.offset(3*Space);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        UILabel *nameLabel =[UILabel new];
        nameLabel.text = self.model.goodsName;
        nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        nameLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).with.offset(2*Space);
            make.left.equalTo(pictureView.mas_right).with.offset(Space);
            make.size.mas_equalTo(CGSizeMake(100, 15));
        }];
        UILabel *timeLabel = [UILabel new];
        timeLabel.text = @"有效期至:2016-08-12 23:59";
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
        [bgView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom);
            make.left.equalTo(pictureView.mas_right).with.offset(Space);
            make.size.mas_equalTo(CGSizeMake(Width - 50, 15));
        }];
        
        UILabel *line = [UILabel new];
        line.backgroundColor = [UIColor colorWithHexString:kLineColor];
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom);
            make.left.equalTo(bgView.mas_left).with.offset(2*Space);
            make.right.equalTo(bgView.mas_right).with.offset(-2*Space);
            make.height.mas_equalTo(@(1));
        }];
        
        UILabel *passwordLabel = [UILabel new];
        passwordLabel.text = [NSString stringWithFormat:@"密码%d:  %@",i+1, dic[@"couponNo"]];
        passwordLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        passwordLabel.textAlignment = NSTextAlignmentCenter;
        passwordLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:passwordLabel];
        [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.right.left.equalTo(bgView);
            make.height.mas_equalTo(@(20));
        }];
        
        UIImageView *qrImgView = [[UIImageView alloc]init];
        qrImgView.contentMode = UIViewContentModeScaleAspectFit;
        qrImgView.frame = CGRectMake(0, 0, (Width / 2) - 51, (Width / 2) - 51);
        
        //    _qrImgView.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
        [bgView addSubview:qrImgView];
        [qrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.top.equalTo(passwordLabel.mas_bottom).with.offset(Space);
            make.bottom.equalTo(bgView).with.offset(-2*Space);
            make.size.mas_equalTo(@((Width / 2)-71));
        }];
        
        qrImgView.image = [LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@:%@",self.messageModel.orderNo,dic[@"couponNo"]] size:qrImgView.bounds.size];
        
        DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(10, 5, bgView.frame.size.width-20, bgView.frame.size.height - 10)];
        [drawView setLineColorWith:[UIColor colorWithHexString:kLineColor]];
        [bgView addSubview:drawView];
        if (i == self.messageModel.coupons.count-1) {
            [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bgView.mas_bottom).with.offset(10);
            }];
        }
        
    }
}


- (void)createView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, Width , Width)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
//    UIImageView *pictureView = [[UIImageView alloc] init];
//    pictureView.contentMode = UIViewContentModeScaleAspectFill;
//    pictureView.clipsToBounds = YES;
//    pictureView.hidden = YES;
//    pictureView.backgroundColor = [UIColor redColor];
//    [pictureView sd_setImageWithURL:[NSURL URLWithString:self.model.originUrl]];
//    [bgView addSubview:pictureView];
//    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(bgView).with.offset(3*Space);
//        make.size.mas_equalTo(CGSizeMake(25, 25));
//    }];
//    UILabel *nameLabel =[UILabel new];
//    nameLabel.text = self.model.goodsName;
//    nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
//    nameLabel.font = [UIFont systemFontOfSize:12];
//    [bgView addSubview:nameLabel];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView).with.offset(2*Space);
//        make.left.equalTo(pictureView.mas_right).with.offset(Space);
//        make.size.mas_equalTo(CGSizeMake(100, 15));
//    }];
//    UILabel *timeLabel = [UILabel new];
//    timeLabel.text = @"有效期至:2016-08-12 23:59";
//    timeLabel.font = [UIFont systemFontOfSize:10];
//    timeLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
//    [bgView addSubview:timeLabel];
//    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameLabel.mas_bottom);
//        make.left.equalTo(pictureView.mas_right).with.offset(Space);
//        make.size.mas_equalTo(CGSizeMake(Width - 50, 15));
//    }];
//    
//    UILabel *line = [UILabel new];
//    line.backgroundColor = [UIColor colorWithHexString:kLineColor];
//    [bgView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(timeLabel.mas_bottom);
//        make.left.equalTo(bgView.mas_left).with.offset(2*Space);
//        make.right.equalTo(bgView.mas_right).with.offset(-2*Space);
//        make.height.mas_equalTo(@(1));
//    }];
//    
//    UILabel *passwordLabel = [UILabel new];
//    passwordLabel.text = [NSString stringWithFormat:@"密码:  %@", self.couponNo];
//    passwordLabel.textColor = [UIColor colorWithHexString:kTitleColor];
//    passwordLabel.textAlignment = NSTextAlignmentCenter;
//    passwordLabel.font = [UIFont systemFontOfSize:12];
//    [bgView addSubview:passwordLabel];
//    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line.mas_bottom);
//        make.right.left.equalTo(bgView);
//        make.height.mas_equalTo(@(20));
//    }];
//    
//    self.qrImgView = [[UIImageView alloc]init];
//    self.qrImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.qrImgView.frame = CGRectMake(0, 0, (Width / 2) - 51, (Width / 2) - 51);
//
////    _qrImgView.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
//    [bgView addSubview:self.qrImgView];
//    [self.qrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(bgView);
//        make.top.equalTo(passwordLabel.mas_bottom).with.offset(Space);
//        make.bottom.equalTo(bgView).with.offset(-2*Space);
//        make.size.mas_equalTo(@((Width / 2)-71));
//    }];
//    
//    self.qrImgView.image = [LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@:%@", self.orderNo, self.couponNo] size:_qrImgView.bounds.size];
//    
//    DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(10, 5, bgView.frame.size.width-20, bgView.frame.size.height - 10)];
//    [drawView setLineColorWith:[UIColor colorWithHexString:kLineColor]];
//    [bgView addSubview:drawView];
    
    UILabel *passWordLabel = [UILabel new];
    passWordLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    passWordLabel.font = [UIFont systemFontOfSize:12];
    passWordLabel.text = @"密码";
    [bgView addSubview:passWordLabel];
    [passWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(15);
        make.left.equalTo(bgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    UILabel *couponLabel = [UILabel new];
    couponLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    couponLabel.font = [UIFont systemFontOfSize:12];
    couponLabel.textAlignment = NSTextAlignmentRight;
    couponLabel.text = self.couponNo;
    [bgView addSubview:couponLabel];
    [couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(15);
        make.right.equalTo(bgView).with.offset(-20);
        make.left.equalTo(passWordLabel);
        make.height.mas_equalTo(@(20));
    }];
        self.qrImgView = [[UIImageView alloc]init];
        self.qrImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    //    _qrImgView.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
        [bgView addSubview:self.qrImgView];
        [self.qrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.centerY.equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(Width*2/3, Width*2/3));
        }];
//    NSDictionary * dic =@{@"orderNo":self.orderNo,@"couponNo":self.couponNo,@"goodsOrderId":self.goodsOrderId,@"goodsOrderCouponId":self.goodsOrderCouponId};
//    NSString * str = [dic yy_modelToJSONString];
    self.qrImgView.image = [LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@:%@:%@:%@", self.orderNo,self.couponNo,self.goodsOrderId,self.goodsOrderCouponId] size:CGSizeMake(Width*2/3, Width*2/3)];
        //self.qrImgView.image = [LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@",str] size:CGSizeMake(Width*2/3, Width*2/3)];
    UILabel *showMessage = [UILabel new];
    showMessage.text = @"向商家出示以上券码即可消费";
    showMessage.textColor = [UIColor colorWithHexString:kTitleColor];
    showMessage.textAlignment = NSTextAlignmentCenter;
    showMessage.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:showMessage];
    [showMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrImgView.mas_bottom).with.offset(10);
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(@(20));
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
