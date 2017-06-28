//
//  SettingController.m
//  BianMin
//
//  Created by kkk on 16/4/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SettingController.h"
#import "WIFIViewCell.h"
#import "AboutUS.h"
#import "Feedback.h"
#import "AdressViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDImageCache.h"
#import "LoginController.h"
#import "QQAndWxTableViewCell.h"
#import "RequestUnbindSocialAccount.h"
#import "RequestThirdPartBind.h"
#import "UMSocial.h"
#import "ThirdUserModel.h"
#import "RequestAgreementLinksModel.h"
#import "UserModel.h"
#define Bounds [UIScreen mainScreen].bounds
@interface SettingController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *myArray;

@property (nonatomic, strong)UILabel *cacheLabel;
@property (nonatomic, strong) NSArray *qqAndWxArr;
@property (nonatomic, strong) UserModel *userModel;
@end

@implementation SettingController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (NSArray *)qqAndWxArr {
    if (!_qqAndWxArr) {
        self.qqAndWxArr = @[@"icon_my_shezhi_weixin",@"icon_my_shezhi_qq"];
    }
    return _qqAndWxArr;
}
- (UILabel *)cacheLabel {
    if (!_cacheLabel) {
        self.cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width-80, 10, 60, 20)];
        self.cacheLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        self.cacheLabel.textAlignment = NSTextAlignmentRight;
        self.cacheLabel.font = [UIFont systemFontOfSize:12];
    }
    return _cacheLabel;
}
- (NSArray *)myArray {
    if (!_myArray) {
        self.myArray = [NSMutableArray arrayWithObjects:@[@"仅Wi-Fi下显示图片"],@[@"邀请好友使用",@"清除缓存",@"意见反馈",@"收货地址"],@[@"微信",@"QQ"],@[@"关于我们"], nil];
    }
    return _myArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self showBackBtn];
   
    [self createTableView];
    
}

- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)cancleAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingCell"];
    [self.tableView registerClass:[WIFIViewCell class] forCellReuseIdentifier:@"wifiCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QQAndWxTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QQAndWxTableViewCell"];
    [self.view addSubview:self.tableView];
    if ([self isLogin]) {
        [self netWorkUserMessage];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 60;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0||section==1) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Width/8;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        UIView *quiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Bounds.size.width, 40)];
//        quiteView.userInteractionEnabled = YES;
//        quiteView.backgroundColor = [UIColor greenColor];
        UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
        btnn.frame = CGRectMake(15, 15, Bounds.size.width-30, 40);
        btnn.backgroundColor = [UIColor redColor];
        [btnn addTarget:self action:@selector(quiteAction:) forControlEvents:UIControlEventTouchUpInside];
        btnn.layer.masksToBounds = YES;
        if ([self isLogin]) {
            btnn.hidden = NO;
        }else {
            btnn.hidden = YES;
        }
        btnn.layer.cornerRadius = (Bounds.size.width-30)/50;
        [btnn setTitle:@"退出账号" forState:UIControlStateNormal];
        [quiteView addSubview:btnn];
        return quiteView;
    }
    return nil;
}
#pragma mark - 退出当前账号
- (void)quiteAction:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DWHelper *helper = [DWHelper shareHelper];
    [userDefaults setObject:@(0) forKey:@"isLogin"];
    helper.isLogin = @(0);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"退出账号" object:@"退出账号" userInfo:nil];
    [self.navigationController  popViewControllerAnimated:YES];
    OKLog(@"退出账号");
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if (section == 1) {
        return 4;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        WIFIViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wifiCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 2) {
        QQAndWxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QQAndWxTableViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            if (self.userModel.wechaToken.length != 0) {
                cell.isRemove.text = @"已绑定";
            }else {
                cell.isRemove.text = @"未绑定";
            }
        }else {
            if (self.userModel.qqToken.length != 0) {
                cell.isRemove.text = @"已绑定";
            }else {
                cell.isRemove.text = @"未绑定";
            }
        }
        cell.nameL.text = self.myArray[indexPath.section][indexPath.row];
        cell.imageV.image = [UIImage imageNamed:self.qqAndWxArr[indexPath.row]];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
        if (cell) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, Width/8-0.5, Bounds.size.width, 0.5)];
            line.backgroundColor = [UIColor colorWithHexString:kLineColor];
            line.tag = 1000;
            [cell addSubview:line];
        }
        UILabel *line = (UILabel *)[cell viewWithTag:1000];
        if (indexPath.section == 1) {
            if (indexPath.row == 0 || indexPath.row ==1|| indexPath.row == 2) {
                line.hidden = NO;
            }else{
                line.hidden = YES;
            }
        }else{
            line.hidden = YES;
        }
        
        if (indexPath.row == 1) {
            self.cacheLabel.text = [self checkTmpSize];
            [cell addSubview:self.cacheLabel];
        }else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = self.myArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.myArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = self.myArray[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"清除缓存"]) {
        [self alertWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小%@", [self checkTmpSize]] OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            [[SDImageCache sharedImageCache] clearDisk];
            [self.tableView reloadData];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }

    if ([title isEqualToString:@"关于我们"]) {
        [self.navigationController pushViewController:[[AboutUS alloc]init] animated:YES];
        return;
    }
    
    QQAndWxTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self isLogin]) {
        if ([title isEqualToString:@"仅Wi-Fi下显示图片"]) {
            
        }
        if ([title isEqualToString:@"邀请好友使用"]) {
            BaseRequest *baseReq = [[BaseRequest alloc] init];
            baseReq.encryptionType = RequestMD5;
            baseReq.data = [NSArray array];
            [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestAgreementLinks" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode == 1) {
                    RequestAgreementLinksModel *model = [RequestAgreementLinksModel yy_modelWithJSON:baseRes.data];
                    [[DWHelper shareHelper] UMShareWithController:self WithText:model.shareTitle WithPictureUrl:model.shareImage WithContentUrl:model.shareLink];
                }else {
                    [self showToast:baseRes.msg];//    [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
                }
            } faild:^(id error) {
                
            }];

        }
        if ([title isEqualToString:@"意见反馈"]) {
            [self.navigationController pushViewController:[[Feedback alloc]init] animated:YES];

        }
        if ([title isEqualToString:@"收货地址"]) {
            AdressViewController *adressController = [[AdressViewController alloc] init];
            [self.navigationController pushViewController:adressController animated:YES];
        }
        if ([title isEqualToString:@"微信"]) {
            if ([cell.isRemove.text isEqualToString:@"未绑定"]) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否绑定微信?" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self getQQOrWxTokenWith:2 withcell:cell];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
            }else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解绑微信?" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self removeThird:2 withIndexPaht:indexPath];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
            }

        }
        if ([title isEqualToString:@"QQ"]) {
            if ([cell.isRemove.text isEqualToString:@"未绑定"]) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否绑定QQ?" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self getQQOrWxTokenWith:1 withcell:cell];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
                
            }else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解绑QQ?" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self removeThird:1 withIndexPaht:indexPath];
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
            }

        }
       
        
    }else{
        LoginController *loginController = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
  
    }
 
}

- (void)removeThird:(NSInteger)isQQ withIndexPaht:(NSIndexPath *)indexPath {
    QQAndWxTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    RequestUnbindSocialAccount *accout = [[RequestUnbindSocialAccount alloc] init];
    accout.type = isQQ;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    
    baseReq.data = [AESCrypt encrypt:[accout yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUnbindSocialAccount" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self showToast:@"解绑成功"];
            cell.isRemove.text = @"未绑定";
        }else {
             [self showToast:baseRes.msg];//[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}

- (void)getQQOrWxTokenWith:(NSInteger)type withcell:(QQAndWxTableViewCell *)cell{
    if (type == 1) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //        //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];

                [self bindingQQOrWxWith:1 withtoken:snsAccount.accessToken withuid:snsAccount.usid withCell:cell];
//                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
//                    [self bindingQQOrWxWith:1 withtoken:response.data[@"access_token"] withuid:response.data[@"uid"] withCell:cell];
//                }];
//                
            }});
    }else {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                [self bindingQQOrWxWith:2 withtoken:snsAccount.accessToken withuid:snsAccount.usid withCell:cell];
            }
            
        });
    }
}

- (void)bindingQQOrWxWith:(NSInteger)type withtoken:(NSString *)token withuid:(NSString *)uid withCell:(QQAndWxTableViewCell *)cell
{
    RequestThirdPartBind *bind = [[RequestThirdPartBind alloc] init];
    bind.type = type;
    bind.thirdPartToken = token;
    bind.thirdPartUserId = uid;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[bind yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestThirdPartBind" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            cell.isRemove.text = @"已绑定";
            [self showToast:@"绑定成功"];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        
    } faild:^(id error) {
    
    }];
}
//缓存大小
- (NSString *)checkTmpSize {
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    // 1k = 1024, 1m = 1024k
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
}

- (void)netWorkUserMessage {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUserInfo" sign:[baseReq.data  MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseResponse = [BaseResponse yy_modelWithJSON:response];
        UserModel *innerModel = [UserModel yy_modelWithJSON:response];
        weakSelf.userModel = [UserModel yy_modelWithJSON:innerModel.data];
        if (innerModel.resultCode == 1) {
            
        }else if (innerModel.resultCode == 10) {
            
        }else {
            [weakSelf showToast:innerModel.msg];
        }
        [weakSelf.tableView reloadData];
    } faild:^(id error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
