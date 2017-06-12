//
//  TalkController.m
//  BianMin
//
//  Created by kkk on 16/5/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "TalkController.h"
#import "CWStarRateView.h"
#import "Imageupload.h"
#import "AFNetworking.h"
#import "RequestAddGoodsComment.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#define BtnWidth (Width - 4)/5
#define ImageWidth (Width - 120)/3
@interface TalkController ()<LQPhotoPickerViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) CWStarRateView *starRate;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic ,strong) UIButton *thirdLabel;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, strong) UILabel *showLabel;
@end

@implementation TalkController

- (NSMutableArray *)imagesArr {
    if (!_imagesArr) {
        self.imagesArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesArr;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        self.buttonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttonArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价";
    self.star = 5;
    [self showBackBtn];
     [self getConfig];
    self.scrollerView = [UIScrollView new];
    self.scrollerView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.scrollerView];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0,0,0,0));
    }];
    self.container = [UIView new];
    [self.scrollerView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollerView);
        make.width.equalTo(self.scrollerView);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.container addGestureRecognizer:tap];
    [self createView];
}
- (void)endEditing {
    [self.view endEditing:YES];
}
- (void)createView {
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"发布" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    NSArray * arr = @[@"差",@"一般",@"满意",@"很满意",@"强烈推荐"];
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(talkAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0 + i * (BtnWidth + 1),30 , BtnWidth, BtnWidth);
        [self.buttonArray addObject:btn];
        [self.scrollerView addSubview:btn];
        if (i == 4) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#ff9712"] forState:UIControlStateNormal];
        }
    }
    [self createStarRate:1];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40 + BtnWidth + 10, Width, 80)];
    self.textView.delegate = self;
    [self.container addSubview:self.textView];
    self.showLabel = [UILabel new];
        self.showLabel.textColor = [UIColor colorWithHexString:kTitleColor];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"还需十五个字,即可发表"];
//    NSRange r;
//    r = [str.string rangeOfString:@"十五"];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:r];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12] range:r];
//    self.showLabel.attributedText = str;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"还需15个字,即可发表"];
    NSRange r;
    r=[str.string rangeOfString:@"15"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:r
     ]; //设置字体颜色
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15] range:r]; //设置字体字号和字体类别
    self.showLabel.attributedText = str;
    self.showLabel.textAlignment = NSTextAlignmentRight;
    self.showLabel.font = [UIFont systemFontOfSize:12];
    self.showLabel.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:self.showLabel];
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollerView);
        make.right.equalTo(self.scrollerView).with.offset(-10);
        make.top.equalTo(self.textView.mas_bottom);
        make.height.mas_equalTo(@(30));
    }];
    UILabel *secondLabel = [UILabel new];
    secondLabel.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showLabel.mas_right);
        make.right.equalTo(self.scrollerView);
        make.top.equalTo(self.textView.mas_bottom);
        make.height.mas_equalTo(@(30));
    }];
//

    self.LQPhotoPicker_superView = self.scrollerView;
    self.LQPhotoPicker_imgMaxCount = 9;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    [self LQPhotoPicker_updatePickerViewFrameY:160 + BtnWidth + 10];
    
    self.thirdLabel = [UIButton new];
    [self.thirdLabel setTitle:@"上传照片" forState:UIControlStateNormal];
    self.thirdLabel.hidden = YES;
    [self.thirdLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.thirdLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.thirdLabel addTarget:self action:@selector(soureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.thirdLabel.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    //    thirdLabel.backgroundColor = [UIColor redColor];
    [self.container addSubview:self.thirdLabel];
    
    self.thirdLabel.frame = CGRectMake(10,[self LQPhotoPicker_getPickerViewFrame].origin.y+[self LQPhotoPicker_getPickerViewFrame].size.height - 50, Width-20, 30);
    
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thirdLabel.mas_bottom).with.offset(20);
    }];
}

- (void)updateViewsFrame {
    self.thirdLabel.frame = CGRectMake(10,[self LQPhotoPicker_getPickerViewFrame].origin.y+[self LQPhotoPicker_getPickerViewFrame].size.height+10, Width-20, 20);
}

- (void)LQPhotoPicker_pickerViewFrameChanged{
    [self updateViewsFrame];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)soureAction:(UIButton *)sender {
    OKLog(@"上传照片和评论");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否上传评论和照片" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    //模态跳转
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)talkAction:(UIButton *)sender {
    NSInteger count = sender.tag - 100;
    CGFloat number = 0;
    switch (count) {
        case 0:
            number = 0.2;
            self.star = 1;
            break;
        case 1:
            number = 0.4;
            self.star = 2;
            break;
        case 2:
            number = 0.6;
            self.star = 3;
            break;
        case 3:
            number = 0.8;
            self.star = 4;
            break;
        case 4:
            number = 1.0;
            self.star = 5;
            break;
        default:
            break;
    }
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = self.buttonArray[i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor colorWithHexString:@"#ff9712"] forState:UIControlStateNormal];
    [self.starRate setScorePercent:number];
}

- (void)createStarRate:(CGFloat)number {
    self.starRate = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    self.starRate.userInteractionEnabled = NO;
    [self.starRate setNumberOfStarts:5];
    self.starRate.scorePercent = number;
    [self.scrollerView addSubview:self.starRate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"icon_arrows_left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAction:(UIButton *)sender {
    if (self.textView.text.length < 15) {
        [self showToast:@"评论未满15个字"];
    }else {
        self.imagesArr = [self LQPhotoPicker_getSmallImageArray];
        if (self.imagesArr.count == 0) {
            [self showProgress];
            [self settingMessage:nil];
            return;
        }
        [self commitImage];
    }
}


- (void)commitImage {
    [self showProgress];
    DWHelper *helper = [DWHelper shareHelper];
    NSLog(@"%@, %@", helper.configModel.image_password, helper.configModel.image_account);
    [self showProgress];
    Imageupload *upload = [[Imageupload alloc] init];
    upload.isThumb = @"1";
    upload.image_account = helper.configModel.image_account;
    upload.image_password = [[NSString stringWithFormat:@"%@%@%@",helper.configModel.image_account, helper.configModel.image_hostname,helper.configModel.image_password] MD5Hash];
    
    upload.waterSwitch = helper.configModel.waterSwitch;
    upload.waterLogo = helper.configModel.waterLogo;
    upload.isWater = @"0";
    //头像上传
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < self.imagesArr.count; i++) {
            NSData *data = UIImageJPEGRepresentation(self.imagesArr[i], 0.4);
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%d", i] fileName:[NSString stringWithFormat:@"curr%d.png", i] mimeType:@"image/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:responseObject];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:baseRes.data];
        if (baseRes.resultCode == 1) {
            [self settingMessage:arr];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgress];
        [self showToast:@"图片上传失败"];
    }];
    
}
- (void)settingMessage:(NSMutableArray *)arr {
    RequestAddGoodsComment *comment = [[RequestAddGoodsComment alloc] init];
    comment.merchantId = self.model.merchantId;
    comment.goodsId = self.model.goodsId;
    comment.orderNo = self.model.orderNo;
    comment.goodsOrderId = self.model.goodsOrderId;
    comment.content = self.textView.text;
    comment.star = self.star;
    if (arr.count == 0) {
    }else {
       comment.images = arr;
    }
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[comment yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestAddGoodsComment" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self hideProgress];
            [self showToast:@"评论成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else {
             [self hideProgress];
           [self showToast:baseRes.msg];//  [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
         [self hideProgress];
    }];
    
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = textView.text.length;
    if (count > 14) {
       self.showLabel.text = @"";
    }else {
        NSString *string = [NSString stringWithFormat:@"还需%ld字,即可发表", 15-count];
        NSString *colorStr = [NSString stringWithFormat:@"%ld", 15-count];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange r;
        r=[str.string rangeOfString:colorStr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:r
         ]; //设置字体颜色
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15] range:r]; //设置字体字号和字体类别
        self.showLabel.attributedText = str;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thirdLabel.mas_bottom).with.offset(200);
    }];
}




- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"评论上传中"];
}
- (void)hideProgress{
    [SVProgressHUD dismiss];
}
- (void)showToast:(NSString *)text{
    [self.view hideToastActivity];
    [self.view makeToast:text duration:1.5 position:CSToastPositionCenter];
}
#pragma mark -  //获取系统配置信息
- (void)getConfig {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @[];
    __weak typeof(self) weakSelf = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestConfig" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode ==1) {
            RequestConfigModel *model = [RequestConfigModel yy_modelWithJSON:baseRes.data];
            DWHelper *helper = [DWHelper shareHelper];
            helper.configModel = model;
        }else{
            [weakSelf showToast:baseRes.msg];
        }
    } faild:^(id error) {
        
    }];
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
