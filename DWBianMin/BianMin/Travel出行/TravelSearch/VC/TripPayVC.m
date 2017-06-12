//
//  TripPayVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/22.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripPayVC.h"
#import "TripModel.h"
#import "RequestPayBminOrderModel.h"
#import "TravelOrderVC.h"

@interface TripPayVC (){
    }
@property(nonatomic,strong)NSString *payType;

@end

@implementation TripPayVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    }
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    dispatch_cancel(_timer);
    self.timer = nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    //支付成功后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessAction:) name:@"支付成功" object:nil];
    
}
- (void)paySuccessAction:(NSNotification *)sender {
    //Push 跳转
    TravelOrderVC * VC = [[TravelOrderVC alloc]initWithNibName:@"TravelOrderVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

}
-(void)addBackBtn{
    

    
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    
    __weak typeof(self) weakSelf = self;
    [self showBackBtn:^{
        
        
        [weakSelf alertWithTitle:@"温馨提示" message:@"是否取消订单?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
            ///取消订单
            [weakSelf requestOrderCancel];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];

        
        
    }];

    self.title = @"预约成功";
    __block int timeout=[self.tripModel.payTimeLimit intValue]; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     self. timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            //倒计时结束 改变颜色
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf alertWithTitle:@"温馨提示" message:@"等待时间已过,订单自动取消" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
                   //Push 跳转
                   TravelOrderVC * VC = [[TravelOrderVC alloc]initWithNibName:@"TravelOrderVC" bundle:nil];
                   [weakSelf.navigationController  pushViewController:VC animated:YES];

               }];
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                            NSString* timeoutStr =[NSString stringWithFormat:@"%d",timeout] ;
                            NSString * str =[NSString stringWithFormat:@"位置已预定成功,请在%@内完成网上支付,否则系统将自动取消本次交易",[weakSelf getMMSSFromSS:timeoutStr]];
                            NSLog(@"%@",str);
                            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
                            [AttributedStr addAttribute:NSFontAttributeName
                
                                                  value:[UIFont systemFontOfSize:18.0]
                
                                                  range:NSMakeRange(10, 5)];
                
                            [AttributedStr addAttribute:NSForegroundColorAttributeName
                
                                                  value:[UIColor redColor]
                             
                                                  range:NSMakeRange(10, 5)];
                            weakSelf.payTimeLimit.attributedText =AttributedStr;

                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);

    
}


//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%.2ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%.2ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    //NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}

-(void)requestOrderCancel{
    TripModel *model = [TripModel new];
    NSString *Token =[AuthenticationModel getLoginToken];
    model.orderNo = self.tripModel.orderNo;
    model.orderId = self.tripModel.orderId;
    
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrder/requestOrderCancel" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                //Push 跳转
                TravelOrderVC * VC = [[TravelOrderVC alloc]initWithNibName:@"TravelOrderVC" bundle:nil];
                [weakself.navigationController  pushViewController:VC animated:YES];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    

    
    
}


#pragma mark - 关于数据
-(void)SET_DATA{
    self.payType = @"1";
    [self kongjianfuzhi];
    
    
}



-(void)kongjianfuzhi{
    
    self.payAmount.text =[NSString stringWithFormat:@"支付金额:%@", self.tripModel.payAmount];
    
    
    
}
#pragma mark - 支付宝
- (IBAction)ZFBAction:(UIButton *)sender {
    self.payType = @"1";
    self.ZFBImage.image = [UIImage imageNamed:@"选中"];
    self.WXImage.image = [UIImage imageNamed:@"未选中"];
}
#pragma mark - 微信
- (IBAction)WXAction:(UIButton *)sender {
    self.payType = @"2";
    self.ZFBImage.image = [UIImage imageNamed:@"未选中"];
    self.WXImage.image = [UIImage imageNamed:@"选中"];
}
- (IBAction)submitAction:(PublicBtn *)sender {
    TripModel *model = [TripModel new];
    NSString *Token =[AuthenticationModel getLoginToken];
    model.orderNo = self.tripModel.orderNo;
    model.orderId = self.tripModel.orderId;
    model.payType = self.payType;
    __weak typeof(self) weakSelf = self;

    if (Token.length!= 0) {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrder/requestPayOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestPayBminOrderModel *payModel = [RequestPayBminOrderModel yy_modelWithJSON:baseRes.data];
            if ([_payType isEqualToString:@"1"] ) {
                [weakSelf aliPayWith:payModel];
            }else if([_payType isEqualToString:@"2"]) {
                [weakSelf WXpay:payModel];
            }
        }else {
            [weakSelf showToast:baseRes.msg];
            //[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:weakSelf];
        }
    } faild:^(id error) {
        
    }];
    }else{
        
    }
    
    
}
- (void)aliPayWith:(RequestPayBminOrderModel *)payModel {
    
    
    
    
    NSURL * myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if (![[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        [self showToast:@"尚未安装支付宝"];
        
    }else{
      [DWHelper AliPayActionWithOrderStr:payModel.prealipay];  
    }
    
}

- (void)WXpay:(RequestPayBminOrderModel *)model {
    if (        [WXApi isWXAppInstalled]
        ) {
        [DWHelper  WXpayAction:model.prepayid withpartnerId:model.partnerid withpackage:model.package withnonceStr:model.noncestr withtimeStamp:model.timestamp withsign:model.sign];
    }else{
        [self showToast:@"尚未安装微信"];
    }

    
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
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}
@end
