//
//  RefundController.m
//  DWduifubao
//
//  Created by 月美 刘 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "RefundController.h"
#import "RefundHintCell.h"
#import "RefundMoneyCell.h"
#import "RefundReasonsCell.h"
#import "OtherRefundReasonCell.h"
#import "RefundApplyBtnCell.h"
#import "TripModel.h"
#import "RefundModel.h"
#import "RefundDetailsVC.h"

@interface RefundController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,assign)CGFloat heightCell;
@property(nonatomic,strong)RefundModel *refundModel;

///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSString * content;

@end

@implementation RefundController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    [self ShowNodataView];
    _heightCell =0;
    self.title = @"退款申请";
   // [self endEditingAction:self.view];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //设置TableView自定义注册Cell
    [self.tableView tableViewregisterNibArray:@[@"RefundHintCell",@"RefundMoneyCell",@"RefundReasonsCell",@"OtherRefundReasonCell",@"RefundApplyBtnCell"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    //设置tableViewCell之间的那条线隐藏掉
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置隐藏tableView多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];

    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.refundModel = [RefundModel new];
    self.content = @"";
    [self requestRefundconfig];
    
    
}
#pragma mark - 申请退款-获取退款配置
-(void)requestRefundconfig{
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
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrderRefund/requestRefundconfig" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"申请退款-获取退款配置--%@",response);
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
               
                [weakself.dataArray removeAllObjects];
                weakself.refundModel = [RefundModel yy_modelWithJSON:response[@"data"]];
                NSMutableArray *ListArr = [NSMutableArray arrayWithCapacity:0];
                NSMutableDictionary * DataDic =response[@"data"];
                ListArr = response[@"data"][@"reasonList"];
                NSMutableArray *reasonrArr = DataDic[@"reasonList"];
                for (NSDictionary* dic in reasonrArr ) {
                    RefundModel *model = [RefundModel yy_modelWithJSON:dic];
                    [weakself.dataArray addObject:model];
                
                    
                }
                NSLog(@"%@",self.dataArray);
                [weakself.tableView reloadData];
                 [weakself HiddenNodataView];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }

    
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
//设置cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count==0) {
        return 0;
    }else{
        switch (section) {
            case 0:
            {
                return 2;
                
                
                break;
            }
                
            case 1:
            {
                
                return self.dataArray.count;
                break;
            }
                
            case 2:
            {
                return 2;
                break;
            }
                
                
                
            default:{
                return 0;
                break;
                
            }
        }
  
    }
    
    
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                if (self.refundModel.reason.length!=0) {
                    RefundHintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundHintCell" forIndexPath:indexPath];
                    cell.reason.text = self.refundModel.reason;
                    //设置点击cell不会变成灰色
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;

                }else{
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                    //设置点击cell不会变成灰色
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
               
            }else{
                RefundMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundMoneyCell" forIndexPath:indexPath];
                [cell CellGetData:self.refundModel];
                //设置点击cell不会变成灰色
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            
            break;
        }
            
        case 1:
        {
            RefundReasonsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundReasonsCell" forIndexPath:indexPath];
            [cell CellGetData:self.dataArray[indexPath.row]];
            //设置点击cell不会变成灰色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
            
        case 2:
        {
            if (indexPath.row==0) {
                if (self.heightCell != 0) {
                    OtherRefundReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherRefundReasonCell" forIndexPath:indexPath];
                    cell.content.text = self.content;
                    cell.content.indexPath = indexPath;
                        [cell.content addTarget:self action:@selector(contentEditingDidEnd:) forControlEvents:(UIControlEventEditingDidEnd)];
                    //设置点击cell不会变成灰色
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else{
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                    
                    //设置点击cell不会变成灰色
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }

            }else{
                RefundApplyBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundApplyBtnCell" forIndexPath:indexPath];
                [cell.RefunBtn addTarget:self action:@selector(RefunBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [cell CellGetData:self.refundModel];
                //设置点击cell不会变成灰色
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            break;
        }
            
            
        
        default:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            //设置点击cell不会变成灰色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
            
        }
    }

    
    
    
    
}
-(void)contentEditingDidEnd:(PublicTF*)sender{
    self.content = sender.text;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    
}
-(void)RefunBtnAction:(PublicBtn*)sender{
    
    if (self.content.length==0) {
        [self showToast:@"请选择退款理由"];
        return;
    }
    
    RefundModel *model = [RefundModel new];
    NSString *Token =[AuthenticationModel getLoginToken];
    model.orderNo = self.tripModel.orderNo;
    model.orderId = self.tripModel.orderId;
    model.content = self.content;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelOrderRefund/requestApplyRefund" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
            NSLog(@"提交退款申请--%@",response);
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                //TripModel * model = [TripModel yy_modelWithJSON:response[@"data"] ];
                
                //Push 跳转
                RefundDetailsVC * VC = [[RefundDetailsVC alloc]initWithNibName:@"RefundDetailsVC" bundle:nil];
                VC.tripModel = weakself.tripModel;
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
#pragma mark - UITableViewDelegate
//设置每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            
            if (indexPath.row==0) {
                if (self.refundModel.reason.length!=0) {
                    
                    self.tableView.estimatedRowHeight = 200;
                    self.tableView.rowHeight = UITableViewAutomaticDimension;
                    return self.tableView.rowHeight;
                    
                }
                else{
                   return 0;
                }
                
                
            }else{
                return 10+0.5*Width;
            }

            
            break;
        }
            
        case 1:
        {
            return 0.5+0.1*Width;
            break;
        }
            
        case 2:
        {
            if (indexPath.row==0) {
                return self.heightCell;
            }else{
                return 0.3*Width;
            }

            break;
        }
            
            
            
        default:{
             return 10;
            break;
            
        }
    }

    
}

//设置每个cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        RefundModel * model = self.dataArray[indexPath.row];
        if ([model.isOther isEqualToString:@"0"]) {
            _heightCell =0*Width
            ;
            self.content = model.title;
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            _heightCell =0.2*Width
            ;
            self.content = @"";
            //一个section刷新
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            

        }
    }
    
    
   
}
@end
