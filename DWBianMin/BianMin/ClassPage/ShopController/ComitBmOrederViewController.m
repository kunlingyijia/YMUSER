//
//  ComitBmOrederViewController.m
//  BianMin
//
//  Created by kkk on 16/8/26.
//  Copyright © 2016年 bianming. All rights reserved.
//  
#import "ComitBmOrederViewController.h"
#import "BMselectedTimeController.h"
#import "RequestBminserviceListModel.h"
#import "RequestAddBminorder.h"
#import "OrderDetailViewController.h"
#import "AdressCell.h"
#import "AdressModel.h"
#import "RequestListAddress.h"
#import "RequestUpdateAddress.h"
#import "AdressViewController.h"
@interface ComitBmOrederViewController ()<UITextViewDelegate,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, assign) CGFloat myVHeight;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footView;
//日期时间
@property (nonatomic, strong) UILabel *timeLabel;
//备注
@property (nonatomic, strong) UITextView *remarkView;
//地址
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) AdressModel *model;
//电话姓名
@property (nonatomic, strong) UILabel *name;
//地址bg
@property (nonatomic, strong) UIView *adressBg;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *thirtLabel;
//未选择地址前的提示
@property (nonatomic, strong) UILabel *fourLabel;
@property(nonatomic,assign)NSInteger headerViewHeight;
@end

@implementation ComitBmOrederViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"填写信息";
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self showBackBtn];
    [self init_UI];
//    self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    self.cornerHeight.constant = Height;
//    self.myVHeight = self.cornerHeight.constant;
//    self.orderHeight.constant  = 500;
//    [self createOrederList];
}


#pragma mark - init_UI
- (void)init_UI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AdressCell class] forCellReuseIdentifier:@"adressCell"];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 100)];
    [self createOrederList];
    _headerViewHeight=100;
    self.headerView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
   
    [self.view addSubview:self.tableView];
    
    
    
    UIView *timeBg = [UIView new];
    timeBg.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:timeBg];
    [timeBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).with.offset(-10);
        make.left.right.equalTo(self.headerView);
        make.height.mas_equalTo(@(45));
    }];
    
    UILabel *showTime = [UILabel new];
    showTime.text = @"上门时间";
    showTime.textColor = [UIColor colorWithHexString:kTitleColor];
    showTime.font = [UIFont systemFontOfSize:16];
    [timeBg addSubview:showTime];
    [showTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeBg);
        make.left.equalTo(timeBg).with.offset(20);
        make.width.mas_equalTo(@(80));
    }];
    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_my_right_jiantou"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [timeBg addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeBg);
        make.right.equalTo(timeBg).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    self.timeLabel = [UILabel new];
    self.timeLabel.text = @"请选择上门时间";
    self.timeLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [timeBg addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeBg);
        make.left.equalTo(showTime.mas_right).with.offset(10);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(selectedTime:) forControlEvents:UIControlEventTouchUpInside];
    [timeBg addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(timeBg);
    }];
    
    
    //区尾
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 500)];
    self.footView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    self.tableView.tableFooterView = self.footView;
    [self initFootView];
    //请求数据
//    [self getAdressDataList];
}

- (void)initFootView {
    self.adressBg = [UIView new];
    self.adressBg.backgroundColor = [UIColor whiteColor];
    [self.footView addSubview:self.adressBg];
//    self.adressBg.frame = CGRectMake(0, 10, Width, 90);
    [self.adressBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.footView);
        make.top.equalTo(self.footView).with.offset(10);
        make.height.mas_equalTo(@(50));
    }];
    
    self.thirtLabel = [UILabel new];
    self.thirtLabel.text = @"联系人:";
    self.thirtLabel.hidden = YES;
    self.thirtLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    self.thirtLabel.font = [UIFont systemFontOfSize:kFirstFont];
    [self.adressBg addSubview:self.thirtLabel];
    [self.thirtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adressBg).with.offset(10);
        make.left.equalTo(self.adressBg).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    self.name = [UILabel new];
    self.name.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.name.text = @"";
    self.name.hidden = YES;
    self.name.font = [UIFont systemFontOfSize:kFirstFont];
    [self.adressBg addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirtLabel);
        make.left.equalTo(self.thirtLabel.mas_right).with.offset(10);
    }];
    
    self.firstLabel = [UILabel new];
    self.firstLabel.text = @"上门地址:";
    self.firstLabel.hidden = YES;
    self.firstLabel.font = [UIFont systemFontOfSize:kThirtFont];
    self.firstLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self.adressBg addSubview:self.firstLabel];
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirtLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.adressBg).with.offset(20);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(40);
    }];

    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_my_right_jiantou"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self.adressBg addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.adressBg);
        make.right.equalTo(self.adressBg).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    self.adressLabel = [UILabel new];
    self.adressLabel.font = [UIFont systemFontOfSize:kThirtFont];
    self.adressLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.adressLabel.text = @"请选择地址";
    self.adressLabel.hidden = YES;
    self.adressLabel.numberOfLines = 2;
    self.adressLabel.font = [UIFont systemFontOfSize:14];
    self.adressLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.adressBg addSubview:self.adressLabel];
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirtLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.firstLabel.mas_right).with.offset(5);
        make.right.equalTo(img.mas_left);
        //make.height.mas_equalTo(@(40));
    }];
    
    self.fourLabel = [UILabel new];
    self.fourLabel.font = [UIFont systemFontOfSize:kFirstFont];
    self.fourLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.fourLabel.text = @"选择地址";
    [self.adressBg addSubview:self.fourLabel];
    [self.fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adressBg).with.offset(20);
        make.centerY.equalTo(self.adressBg);
    }];
    
    
    UIButton *adressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [adressBtn setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateHighlighted];
    [adressBtn addTarget:self action:@selector(selectedAdress:) forControlEvents:UIControlEventTouchUpInside];
    [self.adressBg addSubview:adressBtn];
    [adressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.adressBg);
    }];
    
    UILabel *showSecondLabel = [UILabel new];
    showSecondLabel.text = @"备注:";
    showSecondLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    showSecondLabel.font = [UIFont systemFontOfSize:16];
    [self.footView addSubview:showSecondLabel];
    [showSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adressBg.mas_bottom).with.offset(20);
        make.left.equalTo(self.footView).with.offset(20);
    }];
    
    self.remarkView = [UITextView new];
    self.remarkView.font = [UIFont systemFontOfSize:kFirstFont];
    self.remarkView.backgroundColor = [UIColor whiteColor];
    self.remarkView.layer.masksToBounds = YES;
    self.remarkView.layer.cornerRadius = 8;
    self.remarkView.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.footView addSubview:self.remarkView];
    [self.remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showSecondLabel.mas_bottom).with.offset(10);
        make.right.equalTo(self.footView).with.offset(-20);
        make.left.equalTo(self.footView).with.offset(20);
        make.height.mas_equalTo(@(100));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkView.mas_bottom).with.offset(20);
        make.right.equalTo(self.footView).with.offset(-20);
        make.left.equalTo(self.footView).with.offset(20);
        make.height.mas_equalTo(@(40));
    }];
}

- (void)createOrederList {
    CGFloat viewWidth = (Width - 50)/2;
    NSInteger count = 0;
    NSInteger arrCount = self.orderArr.count/2;
    NSInteger indexIndex = self.orderArr.count%2;
    NSInteger maxI = 0;
    if (self.orderArr.count == 0) {
        maxI = 0;
    }else if (self.orderArr.count < 3) {
        maxI = 1;
    }else if (indexIndex == 0) {
        maxI = arrCount;
    }else if (indexIndex != 0) {
        maxI = arrCount + 1;
    }
    for (int i = 0; i< maxI; i++) {
        for (int j = 0; j < 2; j++) {
            UIView *orderV = [self getOrderView:count];
            orderV.frame = CGRectMake(20 + j*(viewWidth+10), 10 + i * (viewWidth/2 + 10), viewWidth, viewWidth/2);
            count = count + 1;
            if (i == maxI-1) {
                if (indexIndex == 0 && j == 1) {
                    self.headerView.frame = CGRectMake(0, 0, Width, (viewWidth/2 + 10)*arrCount+10 +70);
                    _headerViewHeight=(viewWidth/2 + 10)*arrCount+10 +70;
                    break;
                }else if (indexIndex != 0 && j == 0) {
                    self.headerView.frame = CGRectMake(0, 0, Width, (viewWidth/2 + 10) * arrCount+90 + 70);
                    _headerViewHeight= (viewWidth/2 + 10) * arrCount+90 + 70;
                    break;
                }
            }
        }
    }
    
}

- (UIView *)getOrderView:(NSInteger)count {
    RequestBminserviceListModel *model = self.orderArr[count];
    UIView *orderV = [[UIView alloc] init];
    orderV.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedAction:)];
    [orderV addGestureRecognizer:tap];
    
    [self.headerView addSubview:orderV];
    UILabel *price = [UILabel new];
    price.textAlignment = NSTextAlignmentCenter;
    price.text = [NSString stringWithFormat:@"¥%.2f", model.price];
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    [orderV addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orderV);
        make.left.equalTo(orderV);
        make.bottom.equalTo(orderV);
        make.height.mas_equalTo(@(20));
    }];
    UIView *cancelBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"打钩"]];
    cancelBtn.hidden = YES;
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [orderV addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderV).with.offset(2);
        make.right.equalTo(orderV).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    UILabel *nameL = [UILabel new];
    nameL.text = model.serviceName;
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.textColor = [UIColor colorWithHexString:@"#888888"];
    nameL.font = [UIFont systemFontOfSize:12];
    nameL.numberOfLines =2;
    [orderV addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderV.mas_top).offset(5);
        make.left.equalTo(orderV.mas_left).offset(5);
        make.right.equalTo(orderV.mas_right).offset(-5);
        make.bottom.equalTo(price.mas_top);
    }];
        orderV.tag = (count + 1) * 100;
        cancelBtn.tag = (count + 1) * 100 +1;
    return orderV;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AdressModel *model = self.dataSource[indexPath.row];
    RequestUpdateAddress *reqAddress = [[RequestUpdateAddress alloc] init];
    reqAddress.userName = model.userName;
    reqAddress.regionId = model.regionId;
    reqAddress.mobile = model.mobile;
    reqAddress.postcode = model.postcode;
    reqAddress.isDefault = 1;

    reqAddress.address = model.address;
    reqAddress.zone = model.zone;
    reqAddress.addressId = model.addressId;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[reqAddress yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUpdateAddress" sign:[baseReq.data  MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakSelf getAdressDataList];
        }else {
            [weakSelf showToast:baseRes.msg];

           
        }
    } faild:^(id error) {
        
    }];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adressCell" forIndexPath:indexPath];
    AdressModel *model = self.dataSource[indexPath.row];
    [cell cellGetData:model];
    return cell;
}

- (void)selectedAction:(UITapGestureRecognizer *)sender {
    NSInteger viewTag = sender.view.tag;
    NSInteger count = viewTag/100 - 1;
    RequestBminserviceListModel *model = self.orderArr[count];
    UIImageView *img = [self.headerView viewWithTag:sender.view.tag + 1];
    if (img.hidden) {
        [self.selectedArr addObject:model];
        img.hidden = NO;
    }else {
        for (RequestBminserviceListModel *str in self.selectedArr) {
            if ([model.bminServiceId isEqualToString:str.bminServiceId]) {
                [self.selectedArr removeObject:str];
                break;
            }
        }
        img.hidden = YES;
    }
}

#pragma mark - priveFun
- (void)selectedTime:(UIButton *)sender {
    BMselectedTimeController *bmC = [[BMselectedTimeController alloc] initWithNibName:@"BMselectedTimeController" bundle:nil];
    __weak ComitBmOrederViewController *weakSelf = self;
    bmC.backBlockAction = ^(NSString *date, NSString *startTime, NSString *endTime) {
        weakSelf.date = date;
        weakSelf.startTime = startTime;
        weakSelf.endTime = endTime;
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@", date, startTime,endTime];
//        [weakSelf.timeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:bmC animated:YES];
}

- (void)selectedAdress:(UIButton *)sender {
    AdressViewController *adressC = [[AdressViewController alloc] init];
    adressC.isSelectedAdress = @"8";
    __weak ComitBmOrederViewController *weakSelf = self;
    adressC.selectedAdress = ^(AdressModel *model) {
        weakSelf.model = model;
        weakSelf.adressLabel.text =[NSString stringWithFormat:@"%@ %@ %@",model.zone,model.address, model.street];
        weakSelf.name.text = [NSString stringWithFormat:@"%@ %@", model.userName, model.mobile];
        CGFloat adressH = [model.address getTextHeightWithFont:[UIFont systemFontOfSize:kThirtFont] withMaxWith:Width-180];
        weakSelf.adressLabel.numberOfLines = 0;
       // weakSelf.adressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [weakSelf.adressBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100+adressH-40-5);
        }];
        [weakSelf.adressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(adressH*1.2));
        }];
        [weakSelf.firstLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(adressH*1.2));
        }];
        
        weakSelf.thirtLabel.hidden = NO;
        weakSelf.fourLabel.hidden = YES;
        weakSelf.adressLabel.hidden = NO;
        weakSelf.name.hidden = NO;
        weakSelf.firstLabel.hidden = NO;
        
        self.footView.frame = CGRectMake(0, 0, Width, 340+adressH);
        self.tableView.tableFooterView = self.footView;
    };
    [self.navigationController pushViewController:adressC animated:YES];
}


#pragma mark - init_Data
- (void)getAdressDataList {
    
    RequestListAddress *reqListAdress = [[RequestListAddress alloc] init];
    reqListAdress.pageCount = 10;
    reqListAdress.pageIndex = 1;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[reqListAdress yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.token = [AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;

    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestListAddress" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [weakSelf.dataSource removeAllObjects];
            for (NSDictionary *dic in baseRes.data) {
                AdressModel *model = [AdressModel yy_modelWithDictionary:dic];
                [weakSelf.dataSource addObject:model];
            }
            [weakSelf.tableView reloadData];
            
        }else{
            [weakSelf showToast:baseRes.msg];
            
        }        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    } faild:^(id error) {
        
    }];
}



- (void)sureAction:(UIButton *)sender {
    if (self.selectedArr.count == 0 ) {
        [self showToast:@"请选择服务项目"];
        
    }else if ([self.timeLabel.text isEqualToString:@"请选择上门时间"]) {
        [self showToast:@"请选择上门时间"];
    }else if (self.model == nil) {
        [self showToast:@"请选择地址"];
    }
//    else if (self.nameLabel.text.length == 0) {
//        [self showToast:@"请输入姓名"];
//    }else if (self.mobilLabel.text.length == 0) {
//        [self showToast:@"请输入手机号"];
//    }else if (![self.mobilLabel.text isMobileNumber]) {
//        [self showToast:@"请输入正确的手机号"];
//    }else if (self.adressLabel.text.length==0) {
//        [self showToast:@"请输入地址"];
//    }else if ([self.timeBtn.titleLabel.text isEqualToString:@"请选择上门时间"]) {
//        [self showToast:@"请选择上门时间"];
//    }
    else {
        [self showProgress];
    UIButton *btn = sender;
    btn.userInteractionEnabled =    NO;
    RequestAddBminorder *addBm = [[RequestAddBminorder alloc] init];
    addBm.name = self.model.userName;
    addBm.tel = self.model.mobile;
    addBm.address =[NSString stringWithFormat:@"%@ %@ %@",self.model.zone,self.model.address,self.model.street] ;
    addBm.merchantId = self.merchantId;
    addBm.lat = self.model.lat;
    addBm.lng = self.model.lng;
    CGFloat price = 0;
    for (RequestBminserviceListModel *model in self.selectedArr) {
        price = price + model.price;
    }
    addBm.price = [NSString stringWithFormat:@"%.2f", price];
    addBm.bminServiceList = self.selectedArr;
    addBm.content = self.remarkView.text;
        
    addBm.bookingStartTime = [NSString stringWithFormat:@"%@ %@", self.date, self.startTime];
    addBm.bookingEndTime = [NSString stringWithFormat:@"%@ %@", self.date, self.endTime];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[addBm yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestAddBminorder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            OrderDetailViewController *orderDeta = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
            orderDeta.backBlockAction = ^(NSString *str) {
                NSLog(@"订单取消");
            };
            NSDictionary *dic = baseRes.data;
            orderDeta.commitOrderC = 6;
            [orderDeta showSuccessWith:@"预约成功"];
            orderDeta.orderNo = dic[@"orderNo"];
            orderDeta.bminOrderId = dic[@"bminOrderId"];
            btn.userInteractionEnabled = YES;
            [self.navigationController pushViewController:orderDeta animated:YES];
            [self hideProgress];
        }else {
            btn.userInteractionEnabled = YES;
            [self showToast:baseRes.msg];  
            [self hideProgress];
        }
    } faild:^(id error) {
        [self hideProgress];
        btn.userInteractionEnabled = YES;
    }];
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length != 0) {
        self.showLabel.hidden = YES;
    }else {
        self.showLabel.hidden = NO;
    }
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        self.selectedArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArr;
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
