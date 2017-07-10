//
//  SettingMessageController.m
//  BianMin
//
//  Created by kkk on 16/5/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SettingMessageController.h"
#import "UserModel.h"
#import "RequestModifyUserInfo.h"
#import "HZQDatePickerView.h"
#import "AFNetworking.h"
#import "Imageupload.h"
#import "ImageUploadModel.h"
@interface SettingMessageController ()<HZQDatePickerViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    HZQDatePickerView *_pikerView;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTexy;
@property (weak, nonatomic) IBOutlet UITextField *signNameText;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UITextField *birthdayText;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic ,strong) NSMutableArray *photoArr;
@end

@implementation SettingMessageController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.title = @"个人信息";
    [self getConfig];
    NSLog(@"%ld", (long)self.userModel.gender);
    self.nameTexy.text = self.userModel.userName;
    if (self.userModel.gender == 0) {
        self.genderLabel.text = @"女";
    }else {
        self.genderLabel.text = @"男";
    }
    self.birthdayText.text = self.userModel.birthday;
    self.signNameText.text = self.userModel.signature;
    if (self.userModel.avatarUrl == nil) {
        self.photoImage.image = [UIImage imageNamed:@"def_my_zhuye_touxiang"];
    }else {
      [self loadImageWithView:self.photoImage urlStr:self.userModel.avatarUrl];
    }
    [self.birthdayBtn setTitle:self.userModel.birthday forState:UIControlStateNormal];
    [self showBackBtn];
    [self showSaveBtn];
    [self createView];
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.navigationController.navigationBar.translucent = NO;
    [self saveImage:self.photoImage.image withName:@"currentImage.png"];
}

- (void)createView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PhotoAction:)];
    self.photoImage.userInteractionEnabled = YES;
    [self.photoImage addGestureRecognizer:tap];
}

- (void)PhotoAction:(UITapGestureRecognizer *)sender {
    OKLog(@"选择头像");
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"选择相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectedCameraOrLibray:UIImagePickerControllerSourceTypeCamera];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"选择相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectedCameraOrLibray:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)selectedCameraOrLibray:(UIImagePickerControllerSourceType)type {
        //1.创建UIImagePickerController
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        //2.设置图片选着的来源
        imagePicker.sourceType  = type;//从图片库中选取图片
        //3.设置代理人
        imagePicker.delegate = self;
        //4.确定当前选择的图片是否进行剪辑
        imagePicker.allowsEditing = YES;
        //5.进行界面间切换
        [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.photoImage.image = image;
    [self saveImage:image withName:@"currentImage.png"];
}

#pragma mark - UINavigationControllerDelegate
#pragma mark - 保存图片到本地
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    //将文件写入
    [imageData writeToFile:fullPath atomically:NO];
}
- (void)showSaveBtn {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
//    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedGender:)];
    [self.genderView addGestureRecognizer:tap];
    
}

- (void)selectedGender:(UITapGestureRecognizer *)sender {
    OKLog(@"选择性别");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.genderLabel.text = @"男";
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.genderLabel.text = @"女";
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //模态跳转
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)birthdayAction:(id)sender {
    [self setupDateView:DateTypeOfStart];
}
- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView:@"0"];
    _pikerView.frame = CGRectMake(0, 0, Width, Height + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    // 今天开始往后的日期
//    [_pikerView.datePickerView setMinimumDate:[NSDate date]];
    // 在今天之前的日期
    //    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
    
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    NSString * str = [date substringToIndex:10];
    NSLog(@"%@ - %@", str, date);

    switch (type) {
        case DateTypeOfStart:
            [self.birthdayBtn setTitle:str forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)saveAction:(UIBarButtonItem *)sender {
    OKLog(@"保存");
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
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:helper.configModel.image_hostname parameters:[upload yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *saveImage = self.photoImage.image;
        NSData *data = UIImageJPEGRepresentation([self imageWithImageSimple:saveImage withSize:CGSizeMake(100, 100)], 0.5);
        [formData appendPartWithFileData:data name:@"file" fileName:@"currentImage.png" mimeType:@"jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:responseObject];
        if (baseRes.resultCode == 1) {
            for (NSDictionary *dic in baseRes.data) {
                ImageUploadModel *model = [ImageUploadModel yy_modelWithDictionary:dic];
                [self.photoArr addObject:model];
            }
            ImageUploadModel *model = self.photoArr[0];
            [self saveMessageWithPictureUrl:model.originUrl];
            [self hideProgress];
        }else {
         [self showToast:baseRes.msg];//    [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            [self hideProgress];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgress];
        [self showToast:@"头像上传失败"];
    }];
}

//压缩图片
- (UIImage *)imageWithImageSimple:(UIImage *)image withSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveMessageWithPictureUrl:(NSString *)pictureUrl {
    //保存修改信息
    RequestModifyUserInfo *modifyUser = [[RequestModifyUserInfo alloc] init];
    modifyUser.userName = self.nameTexy.text;
    modifyUser.birthday = self.birthdayBtn.titleLabel.text;
    modifyUser.signature = self.signNameText.text;
    modifyUser.avatarUrl = pictureUrl;
    if ([self.genderLabel.text isEqualToString:@"男"]) {
        modifyUser.gender = 1;
    }else {
        modifyUser.gender = 0;
    }
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[modifyUser yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    baseReq.encryptionType = AES;
    NSLog(@"%@", baseReq.data);
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString]  act:@"act=Api/User/requestModifyUserInfo" sign:[baseReq.data  MD5Hash] requestMethod:POST success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            UserModel *userModel = [[UserModel alloc] init];
            userModel.userName = self.nameTexy.text;
            userModel.signature = self.signNameText.text;
            self.messageBlock(userModel);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
           [self showToast:baseRes.msg];//  
        }
        [self hideProgress];
    } faild:^(id error) {
        
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
- (void)viewDidLayoutSubviews {
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = self.photoImage.frame.size.width/2;
}
- (NSMutableArray *)photoArr {
    if (!_photoArr) {
        self.photoArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArr;
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

@end
