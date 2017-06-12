//
//  SignInViewController.m
//  BianMin
//
//  Created by kkk on 16/5/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SignInViewController.h"
#import "BQLCalendar.h"
#import "DataModel.h"
#import "SignListViewController.h"
@interface SignInViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SignInViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到";
    [self newShowBackBtn];
    [self signAction];
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
    self.navigationController.navigationBar.translucent = NO;
}

- (void)newDoBack:(id)sender{
    self.backAction(nil);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)signAction {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestSignin" sign:[baseReq.data  MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showToast:@"自动签到成功"];
            });
        }else {
//            [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self createView];
    } faild:^(id error) {
    }];
}


- (void)createView {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestSigninList" sign:[baseReq.data  MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSMutableArray *dataArr = baseRes.data;
        for (NSDictionary *dic in dataArr) {
            DataModel *model = [DataModel yy_modelWithDictionary:dic];
            [self.dataArr addObject:model];

        }
        if (baseRes.resultCode == 1) {
            [self createDateView:self.dataArr];
        }else {
            
        }
    } faild:^(id error) {
        
    }];

    
    

}

- (void)createDateView:(NSMutableArray *)arr {
    BQLCalendar *headerView = [[BQLCalendar alloc] initWithFrame:CGRectMake(0, 10, Width, 300)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    NSMutableArray *signArr = [NSMutableArray arrayWithCapacity:0];
    for (DataModel *model in arr) {
        if (model.day.length == 1) {
            [signArr addObject:[NSString stringWithFormat:@"0%@", model.day]];
        }else {
            [signArr addObject:model.day];
        }
    }
    
    __weak SignInViewController *weakSelf = self;
    [headerView initSign:signArr Touch:^(NSString *date) {
    
    }];

    
    UILabel *recordLabel = [UILabel new];
    recordLabel.text = @"   我的签到记录";
    recordLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    recordLabel.font = [UIFont systemFontOfSize:13];
    recordLabel.backgroundColor = [UIColor whiteColor];
    recordLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signInAction)];
    [recordLabel addGestureRecognizer:tap];
    [self.view addSubview:recordLabel];
    [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).with.offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.mas_equalTo(@(40));
    }];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setImage:[UIImage imageNamed:@"btn_class_xiangqing_right_jiantou"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(signInAction) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageBtn];
    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordLabel);
        make.left.equalTo(recordLabel.mas_right);
        make.height.equalTo(recordLabel);
        make.right.equalTo(self.view);
    }];
    
    
    
    UILabel *label = [UILabel new];
    label.text = @"签到说明";
    label.textColor = [UIColor colorWithHexString:kTitleColor];
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordLabel.mas_bottom);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *signInlabel = [UILabel new];
    signInlabel.text = @"连续签到可以获得神秘大礼";
    signInlabel.font = [UIFont systemFontOfSize:12];
    signInlabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self.view addSubview:signInlabel];
    [signInlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
}


- (void)signInAction {
    OKLog(@"我的签到记录");
    SignListViewController *signListC = [[SignListViewController alloc] init];
    [self.navigationController pushViewController:signListC animated:YES];
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
