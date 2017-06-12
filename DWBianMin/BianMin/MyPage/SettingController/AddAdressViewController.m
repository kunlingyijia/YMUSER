//
//  AddAdressViewController.m
//  BianMin
//
//  Created by kkk on 16/5/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AddAdressViewController.h"
#import "AdressModel.h"
#import "RequestAddAddress.h"
#import "CityModel.h"
#import "RequestUpdateAddress.h"
#import "MapViewController.h"
#import "GDPoiVC.h"
@interface AddAdressViewController ()<UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, assign) NSInteger secondIndex;
@property (nonatomic, assign) NSInteger thirdIndex;
@property (nonatomic, strong) NSMutableArray *firstDataSource;
@property (nonatomic, strong) NSMutableArray *secondDataSource;
@property (nonatomic, strong) NSMutableArray *secondCity;
@property (nonatomic, strong) NSMutableArray *thirdDataSource;
@property (nonatomic, strong) NSMutableArray *thirdCity;
@property (nonatomic, assign) NSInteger firstRegionID;
@property (nonatomic, assign) NSInteger secondRegionID;
@property (nonatomic, strong) CityModel *cityModel;

@property (nonatomic,strong)AMapPOI *poi;
@property(nonatomic,strong)AMapGeoPoint *GeoPoint;
///省市区
@property(nonatomic,strong)NSString * SSQ;
@property(nonatomic,strong) NSString * name;


@end

@implementation AddAdressViewController
- (NSMutableArray *)firstDataSource {
    if (!_firstDataSource) {
        self.firstDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _firstDataSource;
}
- (NSMutableArray *)secondDataSource {
    if (!_secondDataSource) {
        self.secondDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondDataSource;
}
- (NSMutableArray *)thirdDataSource {
    if (!_thirdDataSource) {
        self.thirdDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdDataSource;
}
- (NSMutableArray *)secondCity {
    if (!_secondCity) {
        self.secondCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondCity;
}
- (NSMutableArray *)thirdCity {
    if (!_thirdCity) {
        self.thirdCity = [NSMutableArray arrayWithCapacity:0];
    }
    return _thirdCity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.poi = [AMapPOI new];
    self.GeoPoint = [AMapGeoPoint new];
    self.firstIndex = 0;
    self.secondIndex = 0;
    self.thirdIndex = 0;
    self.title = @"收货地址";
    self.adress.placeholder = @"详细地址";
    self.selectedBtn.titleLabel.numberOfLines = 0;
    if ([self.isChange isEqualToString:@"6"]) {
        self.nameText.text = self.model.userName;
        self.phoneNum.text = self.model.mobile;
        self.postCode.text = self.model.postcode;
        [self.selectedBtn setTitle:[NSString stringWithFormat:@"%@ %@",self.model.zone,self.model.address] forState:UIControlStateNormal];
        //[self.selectedBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
        self.adress.text = self.model.street;
        self.GeoPoint.latitude = [self.model.lat doubleValue];
        self.GeoPoint.longitude = [self.model.lng doubleValue];
        self.SSQ =self.model.zone;
        self.name = self.model.address;
        [self.sureBtn setTitle:@"修改地址" forState:UIControlStateNormal];
        if (self.adress.text.length != 0) {
            self.textPlacehode.hidden = YES;
        }
        if (self.model.isDefault == 1) {
            self.onSwitch.on = YES;
        }else {
            self.onSwitch.on = NO;
        }
    }
    
    for (NSDictionary *dic in [DWHelper getCityData]) {
        CityModel *model = [CityModel yy_modelWithDictionary:dic];
        if (model.regionType == 1) {
            [self.firstDataSource addObject:model];
        }else if (model.regionType == 2) {
            [self.secondDataSource addObject:model];
        }else if (model.regionType == 3) {
            [self.thirdDataSource addObject:model];
        }
    }
    
    CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
    for (CityModel *model in self.secondDataSource) {
        if (beijingModel.regionId == model.superId) {
            [self.secondCity addObject:model];
        }
    }
    
    CityModel *secondModel = self.secondCity[0];
    for (CityModel *model in self.thirdDataSource) {
        if (secondModel.regionId == model.superId) {
            [self.thirdCity addObject:model];
        }
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calcelText)];
    [self.scrollerView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
}

- (void)calcelText {
    [self.scrollerView endEditing:YES];
}


- (IBAction)addAdressAcion:(id)sender {
    //地图选择
//    MapViewController *mapViewC = [[MapViewController alloc] init];
//    [self.navigationController pushViewController:mapViewC animated:YES];
//    return;
    
    
    
    
    
    if (![self.phoneNum.text isMobileNumber]) {
        [self showToast:@"请输入手机号"];
    }else if (self.nameText.text.length == 0 ){
        [self showToast:@"请输入姓名"];
    }else if (self.postCode.text.length == 0 ){
        [self showToast:@"请输入邮政编码"];
    }else if (self.postCode.text.length != 6) {
        [self showToast:@"邮政编码错误"];
    }else if ([self.selectedBtn.titleLabel.text isEqualToString:@"地址"]) {
        [self showToast:@"请选择地址"];
    }else if (self.adress.text.length == 0 ) {
        [self showToast:@"请输入详细地址"];
    }else{
    if ([self.isChange isEqualToString:@"6"]) {
        RequestUpdateAddress *reqAddress = [[RequestUpdateAddress alloc] init];
        reqAddress.userName = self.nameText.text;
        reqAddress.regionId = self.cityModel.regionId;
        reqAddress.mobile = self.phoneNum.text;
        reqAddress.postcode = self.postCode.text;
        if (self.onSwitch.on) {
            reqAddress.isDefault = 1;
        }else {
            reqAddress.isDefault = 0;
        }
        reqAddress.address = self.name;
        reqAddress.zone = self.SSQ;
        reqAddress.street = self.adress.text;
        reqAddress.lat =[NSString stringWithFormat:@"%f", self.GeoPoint.latitude] ;
        reqAddress.lng =[NSString stringWithFormat:@"%f", self.GeoPoint.longitude];
        reqAddress.addressId = self.model.addressId;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[reqAddress yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        self.view.userInteractionEnabled = NO;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUpdateAddress" sign:[baseReq.data  MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                weakSelf.amendAdressBlock(nil);
                [weakSelf showToast:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else {
                weakSelf.view.userInteractionEnabled = YES;
                [weakSelf showToast:baseRes.msg];
            }
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
        }];
    }else {
        RequestAddAddress *reqAddress = [[RequestAddAddress alloc] init];
        reqAddress.userName = self.nameText.text;
        reqAddress.regionId = self.cityModel.regionId;
        reqAddress.mobile = self.phoneNum.text;
        reqAddress.postcode = self.postCode.text;
        if (self.onSwitch.on) {
            reqAddress.isDefault = 1;
        }else {
            reqAddress.isDefault = 0;
        }
//        reqAddress.address = self.adress.text;
//        reqAddress.zone = self.selectedBtn.titleLabel.text;
        reqAddress.address = self.name;
        reqAddress.zone = self.SSQ;
        reqAddress.street = self.adress.text;
        reqAddress.lat =[NSString stringWithFormat:@"%f", self.GeoPoint.latitude] ;
        reqAddress.lng =[NSString stringWithFormat:@"%f", self.GeoPoint.longitude];
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[reqAddress yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        self.view.userInteractionEnabled = NO;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestAddAddress" sign:[baseReq.data  MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                weakSelf.amendAdressBlock(nil);
                [weakSelf showToast:@"添加成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else {
                weakSelf.view.userInteractionEnabled = YES;
                [weakSelf showToast:baseRes.msg];

                
            }
            
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;

        }];
    }
    }
}
- (IBAction)selectedAdressAction:(id)sender {
    [self.view endEditing:YES];
    //[self createPickerView];
    //Push 跳转
    GDPoiVC * VC = [[GDPoiVC alloc]initWithNibName:@"GDPoiVC" bundle:nil];
    __weak typeof(self) weakSelf = self;
    [VC ReturnGDPoiVCPOI:^(AMapPOI *poi) {
        [weakSelf.selectedBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@ %@",poi.province,poi. city,poi.district,poi.name] forState:(UIControlStateNormal)];
        weakSelf.adress.text = poi.address;
        self.poi = poi;
        self.GeoPoint = poi.location;
        self.SSQ = [NSString stringWithFormat:@"%@ %@ %@",poi.province,poi. city,poi.district];
        self.name = poi.name;
        //NSLog(@"-------address:%@\n----name:%@----district:%@----city%@----businessArea%@----province:%@" ,poi.address,poi.name,poi.district,poi. city ,poi.businessArea,poi.province);
        //省   poi.province
        //市  poi. city
        //区县  poi.district
        //名称 poi.name
        //详细地址  poi.address
        

//        weakSelf.startPlace.text = poi.name;
//        weakSelf.startpoi = poi;
//
//        if ([self.titleStr isEqualToString:@"编辑路线"]) {
//            self.startGeoPoint.latitude =poi.location.latitude ;
//            self.startGeoPoint.longitude =poi.location.longitude;
//            
//        }
        
        
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];
    
}
- (void)createPickerView {
    self.bgView = [[UIView alloc] initWithFrame:Bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canaelTapAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    self.bgView.alpha = 0.2;
    [self.view addSubview:self.bgView];
    self.pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, Height, Width, 300)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerBgView];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 170)];
    self.pickerView.userInteractionEnabled = YES;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView selectRow:self.firstIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.secondIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.thirdIndex inComponent:2 animated:NO];
    [self.pickerBgView addSubview:self.pickerView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBgView);
        make.right.equalTo(self.pickerBgView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
        
    }];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.pickerBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBgView);
        make.left.equalTo(self.pickerBgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(Width/2, 30));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height - 300, Width, 300);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sureAction:(UIButton *)sender {
    if (self.thirdCity.count == 0 || self.secondCity.count == 0) {
        
    }else {
        self.cityModel = self.thirdCity[self.thirdIndex];
        CityModel *firstModel = self.firstDataSource[self.firstIndex];
        CityModel *secondModel = self.secondCity[self.secondIndex];
        
        if ([secondModel.regionName isEqualToString:@"北京市"]) {
            [self.selectedBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.selectedBtn setTitle:[NSString stringWithFormat:@"%@ %@", firstModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
        }else {
            [self.selectedBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
            [self.selectedBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@", firstModel.regionName, secondModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

- (void)cancelAction:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}
- (void)canaelTapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBgView.frame = CGRectMake(0, Height, Width, 200);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        CityModel *model = self.firstDataSource[row];
        return model.regionName;
    }else if (component == 1) {
        CityModel *model = self.secondCity[row];
        return model.regionName;
    }else {
        CityModel *model = self.thirdCity[row];
        return model.regionName;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.firstDataSource.count;
    }else if (component == 1) {
        return self.secondCity.count;
    }else {
        return self.thirdCity.count;
    }
    return 10;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    return 60;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component == 0) {
        self.firstIndex = row;
        CityModel *model = self.firstDataSource[row];
        [self.secondCity removeAllObjects];
        [self.thirdCity removeAllObjects];
        
        if (row == 0) {
            CityModel *beijingModel = [self.firstDataSource objectAtIndex:0];
            for (CityModel *model in self.secondDataSource) {
                if (beijingModel.regionId == model.superId) {
                    [self.secondCity addObject:model];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *model in self.thirdDataSource) {
                if (secondModel.regionId == model.superId) {
                    [self.thirdCity addObject:model];
                }
            }
        }else {
            self.firstRegionID = model.regionId;
            for (CityModel *addressModel in self.secondDataSource) {
                if (addressModel.superId == model.regionId) {
                    [self.secondCity addObject:addressModel];
                }
            }
            CityModel *secondModel = self.secondCity[0];
            for (CityModel *thirdModel in self.thirdDataSource) {
                if (secondModel.regionId == thirdModel.superId) {
                    [self.thirdCity addObject:thirdModel];
                }
            }
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
        }
        [self.pickerView reloadAllComponents];
    }else if (component == 1) {
        [self.thirdCity removeAllObjects];
        self.secondIndex = row;
        CityModel *model = self.secondCity[row];
        self.secondRegionID = model.regionId;
        for (CityModel *addressModel in self.thirdDataSource) {
            if (addressModel.superId == model.regionId) {
                [self.thirdCity addObject:addressModel];
            }
        }
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self.pickerView reloadAllComponents];
    }else {
        self.thirdIndex = row;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
//    if (textView.text.length > 0) {
//        self.textPlacehode.hidden = YES;
//    }else {
//        self.textPlacehode.hidden = NO;
//    }
    
}


//- (void)amendAdress:(AdressModel *)model {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.nameText.text = model.name;
//        self.phoneNum.text = model.mobile;
//        self.adress.text = model.address;
//        if (model.isDefault) {
//            [self.onSwitch setOn:YES];
//        }else {
//            [self.onSwitch setOn:NO];
//        }
//    });
//  
//}


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
