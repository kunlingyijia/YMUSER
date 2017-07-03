//
//  TOrderDetailsVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TOrderDetailsVC.h"
#import "TOrderDetailsOneCell.h"
#import "TOrderDetailsTwoCell.h"
#import "TOrderDetailsThreeCell.h"
#import "TOrderDetailsFourCell.h"
#import "TOrderDetailsFiveCell.h"
#import "TripModel.h"
#import "TripEWMVC.h"
#import "RefundController.h"
#import "RefundDetailsVC.h"
#import "OwnerPositionVC.h"
@interface TOrderDetailsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)TripModel *trioModel;
@end

@implementation TOrderDetailsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestMyOrderInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublicReceiveIndustryVC:) name:@"跳转到行业抵用券" object:nil];
    
}
#pragma mark - 刷新
-(void)PublicReceiveIndustryVC:(NSNotification*)sender{
    [self requestMyOrderInfo];
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    self.title = @"订单详情";
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"TOrderDetailsOneCell",@"TOrderDetailsTwoCell",@"TOrderDetailsThreeCell",@"TOrderDetailsFourCell",@"TOrderDetailsFiveCell"]];

    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.trioModel = [TripModel new];
    
}
#pragma mark - 我的出行订单详情
-(void)requestMyOrderInfo{
    TripModel *model = [TripModel new];
    NSString *Token =[AuthenticationModel getLoginToken];
    model.orderNo = self.orderNo;
    model.orderId = self.orderId;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrder/requestMyOrderInfo" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@" 我的出行订单详情----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakself.trioModel = [TripModel yy_modelWithJSON:response[@"data"]];

                //刷新
                [weakself.tableView reloadData];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
    
    
}

#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.trioModel.orderNo.length==0) {
        [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:0];
        return 0;

    }else{
        return 5;
    }
   }
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
        {
            
           TOrderDetailsOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TOrderDetailsOneCell" forIndexPath:indexPath];
            [cell.OneBtn addTarget:self action:@selector(PushMap:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.TwoBtn addTarget:self action:@selector(CallUser:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell CellGetData:self.trioModel];
            
            return cell;
            break;
        }
            
        case 1:
        {
            //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
            if ([_trioModel.status isEqualToString:@"2"]||[_trioModel.status isEqualToString:@"3"]||[_trioModel.status isEqualToString:@"4"]) {
                TOrderDetailsTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TOrderDetailsTwoCell" forIndexPath:indexPath];
                [cell.oneBtn addTarget:self action:@selector(UseCoupons:) forControlEvents:(UIControlEventTouchUpInside)];
                [cell CellGetData:self.trioModel];
                return cell;
            }else {
                UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                return cell;
            }

            break;
        }
            
        case 2:
        {
    
            TOrderDetailsThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TOrderDetailsThreeCell" forIndexPath:indexPath];
                [cell CellGetData:self.trioModel];
            return cell;
            
            break;
        }
            
            
        case 3:
        {
            
            //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
            if ([_trioModel.status isEqualToString:@"2"]) {
                TOrderDetailsFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TOrderDetailsFourCell" forIndexPath:indexPath];
                [cell.AddBtn addTarget:self action:@selector(SendMessage:) forControlEvents:(UIControlEventTouchUpInside)];
                return cell;
            }else {
                UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                return cell;
            }


            break;
        }
            
        case 4:
        {
            TOrderDetailsFiveCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"TOrderDetailsFiveCell" forIndexPath:indexPath];
             DWHelper *helper = [DWHelper shareHelper];
            [cell.oneBtn addTarget:self action:@selector(oneBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [cell.TwoBtn setTitle:[NSString stringWithFormat:@"客服热线:%@",helper.configModel.plat_kfmobile] forState:(UIControlStateNormal)];
            [cell.TwoBtn addTarget:self action:@selector(TwoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell CellGetData:self.trioModel];
            return cell;
            
            break;
        }
        default:{
            UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            return cell;
            break;
            
        }
    }
   
}

#pragma mark - 跳转地图界面
-(void)PushMap:(UIButton*)sender{
    //Push 跳转
    OwnerPositionVC * VC = [[OwnerPositionVC alloc]initWithNibName:@"OwnerPositionVC" bundle:nil];
    VC.tripModel = self.trioModel;
    [self.navigationController  pushViewController:VC animated:YES];

    
    
}
#pragma mark - 拨打用户电话
-(void)CallUser:(UIButton*)sender{
    __weak typeof(self) weakSelf = self;

    [self alertWithTitle:@"温馨提示" message:@"是否拨打司机电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",weakSelf.trioModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];
    
}
#pragma mark - 使用券
-(void)UseCoupons:(UIButton*)sender{
    //Push 跳转
    TripEWMVC * VC = [[TripEWMVC alloc]initWithNibName:@"TripEWMVC" bundle:nil];
    VC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    VC.tripModel = self.trioModel;
    NSLog(@"%@",[self.trioModel yy_modelToJSONObject]);
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark - 发送信息到客户手机
-(void)SendMessage:(UIButton*)sender{
    
    if ([self.trioModel.tel isMobileNumber]) {
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                //倒计时结束 改变颜色
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"发送行程到手机" forState:UIControlStateNormal];
                    sender.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 120;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [sender setTitle:[NSString stringWithFormat:@"  还剩%@秒  ",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    sender.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        
        TripModel *model = [TripModel new];
        NSString *Token =[AuthenticationModel getLoginToken];
        model.orderNo = self.orderNo;
        model.orderId = self.orderId;
        
        __weak typeof(self) weakself = self;
        if (Token.length!= 0) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.token = [AuthenticationModel getLoginToken];
            baseReq.encryptionType = AES;
            baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrder/requestOrderToMobile" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                
               
                if ([response[@"resultCode"] isEqualToString:@"1"]) {
                    [weakself showToast:@"行程发送成功"];
                }else{
                    [weakself showToast:response[@"msg"]];
                    
                }
                
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];
            
        }else {
            
        }
        

        
    }else {
        [self alertWithTitle:@"提示" message:@"输入的手机号不正确" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
            
        }];
        
    }
    

    
}

#pragma mark - 退款/确人到达目的地
-(void)oneBtn:(PublicBtn*)sender{
    //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
    if ([_trioModel.status isEqualToString:@"1"]) {
        
    }else if ([_trioModel.status isEqualToString:@"2"]) {
        //退款
        //Push 跳转
        RefundController * VC = [[RefundController alloc]init];
        VC.tripModel = self.trioModel;
        [self.navigationController  pushViewController:VC animated:YES];

    }else if ([_trioModel.status isEqualToString:@"3"]) {
        
        [self alertWithTitle:@"温馨提示" message:@"是否到达目的地" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
            //我已到达目的地"
            [self requestOrderComplete];

        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
        
        
    }else if ([_trioModel.status isEqualToString:@"4"]) {
       
    }else if ([_trioModel.status isEqualToString:@"5"]|[_trioModel.status isEqualToString:@"6"]) {
        //退款详情"
        //Push 跳转
        RefundDetailsVC * VC = [[RefundDetailsVC alloc]initWithNibName:@"RefundDetailsVC" bundle:nil];
        VC.tripModel = self.trioModel;
        [self.navigationController  pushViewController:VC animated:YES];


        

    }else if ([_trioModel.status isEqualToString:@"7"]) {
        
    }

    
    
}
#pragma mark - 拨打客服电话
-(void)TwoBtn:(UIButton*)sender{
    
    DWHelper *helper = [DWHelper shareHelper];
    

    [self alertWithTitle:@"温馨提示" message:@"是否拨打客服电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
        
       NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",helper.configModel.plat_kfmobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:96277"];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [weakSelf.view addSubview:callWebview];
    } withCancel:^(UIAlertAction *cancelaction) {
        
    }];
 
    
}



#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            return 0.5*Width+10;
            break;
        }
        case 1:
        {
            //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
            if ([_trioModel.status isEqualToString:@"2"]||[_trioModel.status isEqualToString:@"3"]||[_trioModel.status isEqualToString:@"4"]) {
              return 0.1*Width+10;
            }else {
                 return 0;
            }
            break;
        }
            
        case 2:
        {
            //用storyboard 进行自适应布局
            self.tableView.estimatedRowHeight = 500;
            self.tableView.rowHeight = UITableViewAutomaticDimension;

           return _trioModel.remark.length<10 ?7*Width/9+10:  self.tableView.rowHeight;
            
            break;
        }
            
            
        case 3:
        {
            //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
            if ([_trioModel.status isEqualToString:@"2"]) {
                return 0.2*Width;
            }else {
                return 0;
            }

            break;
        }
        case 4:
        {
            return 0.4*Width;
            break;
        }
        default:{
            return 0;
            break;
            
        }
    }

    
}
#pragma mark - 我已到达目的地
-(void)requestOrderComplete{
    
    TripModel *model = [TripModel new];
    NSString *Token =[AuthenticationModel getLoginToken];
    model.orderNo = self.orderNo;
    model.orderId = self.orderId;
    
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrder/requestOrderComplete" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            
            NSLog(@"----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                [weakself requestMyOrderInfo];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
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

@end
