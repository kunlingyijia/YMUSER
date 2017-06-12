//
//  LoginController.m
//  BianMin
//
//  Created by kkk on 16/4/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LoginController.h"
#import "Masonry.h"
#import "RegisterController.h"
#import "AlterViewController.h"
#import "UMSocial.h"
#import "BindingViewController.h"
#import "RequestLogin.h"
#import "BaseRequest.h"
#import "LoginResponse.h"
#import "AlterViewController.h"
#import "RequestThirdPartLogin.h"
#import "ThirdUserModel.h"
#import "AFNetworking.h"
#define Bounds [UIScreen mainScreen].bounds
@interface LoginController ()
//账号
@property (nonatomic, strong)UITextField *nameField;
//密码
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) ThirdUserModel *thirdUserModel;
//标识 是QQ登录 还是微信登录
@property (nonatomic, assign) NSInteger isQQ;
@end
@implementation LoginController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    self.title = @"登录";
    [self showBackBtn];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:kNavigationTitleColor];
    [self createView];
    [self creteNavigaRightView];
}

#pragma mark - 注册
- (void)creteNavigaRightView {
    UIView *logonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    logonView.backgroundColor = [UIColor clearColor];
    UIButton *logonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logonBtn.frame = CGRectMake(0, 5, 50, 25);
    logonBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [logonBtn setTitle:@"注册" forState:UIControlStateNormal];
    [logonBtn addTarget:self action:@selector(logonAction:) forControlEvents:UIControlEventTouchUpInside];
    logonBtn.backgroundColor = MainColor;
    logonBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    logonBtn.layer.borderWidth = 1;
    logonBtn.layer.masksToBounds = YES;
    logonBtn.layer.cornerRadius = 3;
    [logonView addSubview:logonBtn];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:logonView];
}

- (void)logonAction:(UIButton *)sender {
    OKLog(@"注册");
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogonController"] animated:YES];
}

- (void)createView {
  
    UIView *importView = [[UIView alloc] initWithFrame:CGRectMake(0,  10, Bounds.size.width, 100)];
    importView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:importView];
    //账号
    self.nameField =[[UITextField alloc] initWithFrame:CGRectMake(15, 0, Bounds.size.width-30, 50)];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.font = [UIFont systemFontOfSize:17];
    self.nameField.textColor = [UIColor colorWithHexString:kTitleColor];
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.nameField.placeholder = @"请输入手机号";
    self.nameField.keyboardType = UIKeyboardTypePhonePad;
    [importView addSubview:self.nameField];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameField.frame), Bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    [importView addSubview:lineView];
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame), Bounds.size.width - 30, 50)];
    self.passwordTextField.textColor = [UIColor colorWithHexString:kTitleColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:17];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = @"请输入密码";
    UIButton *rightV = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightV setImage:[UIImage imageNamed:@"icon_common_zhuce_keshi_normal"] forState:UIControlStateNormal];
    [rightV setImage:[UIImage imageNamed:@"icon_common_zhuce_keshi_press"] forState:UIControlStateSelected];
    rightV.frame = CGRectMake(0, 0, 30, 30);
    [rightV addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    rightV.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.passwordTextField.rightView = rightV;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    [importView addSubview:self.passwordTextField];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(15, CGRectGetMaxY(importView.frame)+20, Bounds.size.width-30, importView.frame.size.height/5*2);
    loginBtn.backgroundColor = [UIColor colorWithRed:1/255.0 green:190/255.0 blue:184/255.0 alpha:1.0];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = (Bounds.size.width-30)/50;
    [self.view addSubview:loginBtn];
    //找回密码
    UIButton *setpasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setpasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [setpasswordBtn setTitleColor:[UIColor colorWithRed:1/255.0 green:190/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    setpasswordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [setpasswordBtn addTarget:self action:@selector(setPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setpasswordBtn];
    [setpasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginBtn.mas_bottom).with.offset(20);
        make.right.mas_equalTo(loginBtn.mas_right);
        make.height.mas_equalTo(@(20));
        make.width.mas_equalTo(@(50));
    }];
    
    //三方登录
    UILabel *loginLabel = [UILabel new];
    loginLabel.text = @"使用第三方账号登录";
    loginLabel.textAlignment = NSTextAlignmentCenter;
//    loginLabel.backgroundColor = [UIColor redColor];
    loginLabel.font = [UIFont systemFontOfSize:10];
    loginLabel.textColor = [UIColor grayColor];
    [self.view addSubview:loginLabel];
    //分割线
    UIView *lineOne = [UIView new];
    lineOne.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineOne];
    UIView *lineTwo = [UIView new];
    lineTwo.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineTwo];
    
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(loginLabel.mas_centerY);
        make.height.mas_equalTo(@(1));
        make.left.mas_equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(loginLabel.mas_left);
    }];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(loginLabel.mas_centerY);
        make.left.mas_equalTo(loginLabel.mas_right);
        make.height.mas_equalTo(@(1));
        make.right.equalTo(self.view.mas_right).with.offset(-15);
    }];
    
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(@(120));
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-(Bounds.size.width/4));
        make.height.mas_equalTo(@(20));
    }];
    
    //三方登录按钮
    UIButton *WXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    WXBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [WXBtn setImage:[UIImage imageNamed:@"icon_common_denglu_tubiao1"] forState:UIControlStateNormal];
    [WXBtn addTarget:self action:@selector(WXAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WXBtn];
    [WXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineOne.mas_bottom).with.offset(Bounds.size.width / 16);
        make.left.mas_equalTo(self.view .mas_left).with.offset((Width - 2 * (Bounds.size.width/9)-10)/2);
        make.width.mas_equalTo(@(Bounds.size.width/9));
        make.height.mas_equalTo(@(Bounds.size.width/9));
    }];
    
    UIButton *QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    QQBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [QQBtn setImage:[UIImage imageNamed:@"icon_common_denglu_tubiao2"] forState:UIControlStateNormal];
    [QQBtn addTarget:self action:@selector(QQAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQBtn];
    [QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineOne.mas_bottom).with.offset(Bounds.size.width / 16);
        make.left.mas_equalTo(WXBtn.mas_right).with.offset(10);
        make.width.mas_equalTo(@(Bounds.size.width/9));
        make.height.mas_equalTo(@(Bounds.size.width/9));
    }];
}


#pragma mark - 登录
- (void)loginAction:(UIButton *)sender {
    if (self.nameField.text.length == 0 ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入账号" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (self.passwordTextField.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        RequestLogin *login = [[RequestLogin alloc] init];
        login.mobile = self.nameField.text;
        login.password = [self.passwordTextField.text MD5Hash];
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.data = [login yy_modelToJSONObject];
        baseReq.encryptionType = RequestMD5;
        __weak typeof(self) weakSelf = self;
       self.view.userInteractionEnabled = YES;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestLogin" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
//            BaseResponse *baseR =[BaseResponse yy_modelWithJSON:response];
//            NSNumber *resultCode = [response objectForKey:@"resultCode"];
            
            LoginResponse *registResq = [LoginResponse yy_modelWithJSON:response];
            LoginResponse *registData = [LoginResponse yy_modelWithJSON:[registResq.data yy_modelToJSONString]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:registData.key forKey:@"loginKey"];
            [userDefaults setObject:registData.token forKey:@"loginToken"];
            if (registResq.resultCode == 1) {
                
                //[[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:registResq.data[@"pushAlias"] forKey:@"pushAlias"]];
                [weakSelf showToast:@"登录成功"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:weakSelf.nameField.text forKey:@"name"];
                [userDefaults setObject:weakSelf.passwordTextField.text forKey:@"passWord"];
                [userDefaults setObject:@(1) forKey:@"isLogin"];
                DWHelper *helper =  [DWHelper shareHelper];
                helper.isLogin = @(1);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"登录成功" object:@"登录成功" userInfo:@{}];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else {
                weakSelf.view.userInteractionEnabled = YES;
                [weakSelf showToast:registResq.msg];
            }

            
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
        }];
        
    }
//        NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl, @"act=Api/User/requestLogin",[[baseReq.data yy_modelToJSONString] MD5Hash]];
//        
//        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        
//        manager.requestSerializer.timeoutInterval = 10;
//        
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        
////        [manager.requestSerializer setValue:[self getHelpToken] forHTTPHeaderField:@"Authorization"];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//
//        
//        [manager.requestSerializer setValue:@"福" forHTTPHeaderField:@"province"];
//        
////        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//        self.view.userInteractionEnabled = NO;
//        [manager GET:url parameters:[NSDictionary dictionaryWithObject:[baseReq yy_modelToJSONString] forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@", responseObject);
//                    LoginResponse *registResq = [LoginResponse yy_modelWithJSON:responseObject];
//                    LoginResponse *registData = [LoginResponse yy_modelWithJSON:[registResq.data yy_modelToJSONString]];
//                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                    [userDefaults setObject:registData.key forKey:@"loginKey"];
//                    [userDefaults setObject:registData.token forKey:@"loginToken"];
//                    if (registResq.resultCode == 1) {
//                        [self showToast:@"登录成功"];
//                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                        [userDefaults setObject:self.nameField.text forKey:@"name"];
//                        [userDefaults setObject:self.passwordTextField.text forKey:@"passWord"];
//                        [userDefaults setObject:@(1) forKey:@"isLogin"];
//                        DWHelper *helper =  [DWHelper shareHelper];
//                        helper.isLogin = @(1);
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"登录成功" object:@"登录成功" userInfo:@{}];
//                        [self.navigationController popViewControllerAnimated:YES];
//                                                
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    }else {
//                        self.view.userInteractionEnabled = YES;
//                        [self showToast:registResq.msg];//[ProcessResultCode processResultCodeWithBaseRespone:registResq viewControll:self];
//                    }
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            self.view.userInteractionEnabled = YES;
//        }];
//    }
//    OKLog(@"登录方法");
}


- (void)passwordAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        self.passwordTextField.secureTextEntry = YES;
    }else {
        self.passwordTextField.secureTextEntry = NO;
        sender.selected = YES;
    }
    
}
- (void)WXAction:(UIButton *)sender {
    self.isQQ = 2;
    //[self showProgress];
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"username = %@----uid = %@-------token = %@ ", snsAccount.userName, snsAccount.unionId, snsAccount.accessToken);
//            
//        }
//        
//    });
//    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
             [self hideProgress];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            self.thirdUserModel = [[ThirdUserModel alloc] init];
            self.thirdUserModel.access_token = snsAccount.accessToken;
            self.thirdUserModel.uid = snsAccount.usid;
            self.thirdUserModel.screen_name = snsAccount.userName;
            self.thirdUserModel.profile_image_url = snsAccount.iconURL;
            [self thirdLoginWithToken:snsAccount.accessToken userID:snsAccount.usid];
        }
    });
    OKLog(@"微信登录");
}
- (void)QQAction:(UIButton *)sender {
    self.isQQ = 1;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
             [self hideProgress];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
//                NSLog(@"SnsInformation is %@",response);
//                self.thirdUserModel = [ThirdUserModel yy_modelWithDictionary:response.data];
//                [self thirdLoginWithToken:response.data[@"access_token"] userID:response.data[@"uid"]];
//            }];
            
            
            [self thirdLoginWithToken:snsAccount.accessToken userID:snsAccount.usid];
            //[self thirdLoginWithToken:response.data[@"access_token"] userID:response.data[@"uid"]];
            
        }});
    OKLog(@"QQ登录");
}

- (void)thirdLoginWithToken:(NSString *)token userID:(NSString *)userID {
    RequestThirdPartLogin *thirdLogin = [[RequestThirdPartLogin alloc] init];
    thirdLogin.type = self.isQQ;
    thirdLogin.thirdPartToken = token;
    thirdLogin.thirdPartUserId = userID;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = thirdLogin ;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestThirdPartLogin" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *BaseRes = [BaseResponse yy_modelWithJSON:response];
        if (BaseRes.resultCode == 12) {
            BindingViewController *bindingC = [[BindingViewController alloc] init];
            bindingC.isQQ = self.isQQ;
            bindingC.userModel = self.thirdUserModel;
            [self.navigationController pushViewController:bindingC animated:NO];
        }else if (BaseRes.resultCode == 1) {
            LoginResponse *registResq = [LoginResponse yy_modelWithJSON:response];
            LoginResponse *registData = [LoginResponse yy_modelWithJSON:[registResq.data yy_modelToJSONString]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:registData.key forKey:@"loginKey"];
            [userDefaults setObject:registData.token forKey:@"loginToken"];
            [self showToast:@"登录成功"];
            [userDefaults setObject:@(1) forKey:@"isLogin"];
            DWHelper *helper =  [DWHelper shareHelper];
            helper.isLogin = @(1);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"登录成功" object:@"登录成功" userInfo:@{}];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
           [self showToast:BaseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:BaseRes viewControll:self];
        }
        [self hideProgress];
    } faild:^(id error) {
         [self hideProgress];
        NSLog(@"%@", error);
    }];
}


- (void)setPasswordAction:(UIButton *)sender {
    OKLog(@"找回密码");
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlterViewController"] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
