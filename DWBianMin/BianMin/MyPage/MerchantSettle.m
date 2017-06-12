//
//  MerchantSettle.m
//  BianMin
//
//  Created by z on 16/5/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MerchantSettle.h"
#import "CityModel.h"
#import "RequestMerchantApply.h"
#import "RequestAgreementLinksModel.h"
@interface MerchantSettle()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UITextField *merchantName;
@property (nonatomic, strong) UITextField *merchantAddress;
@property (nonatomic, strong) UITextField *merchantContact;
@property (nonatomic, strong) UIButton *addressBtn;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *firstDataSource;
@property (nonatomic, strong) NSMutableArray *secondDataSource;
@property (nonatomic, strong) NSMutableArray *secondCity;
@property (nonatomic, strong) NSMutableArray *thirdDataSource;
@property (nonatomic, strong) NSMutableArray *thirdCity;
@property (nonatomic, assign) NSInteger firstRegionID;
@property (nonatomic, assign) NSInteger secondRegionID;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pickerBgView;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, assign) NSInteger secondIndex;
@property (nonatomic, assign) NSInteger thirdIndex;
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) CityModel *provinceModel;
@property (nonatomic, strong) CityModel *secondModel;
@property (nonatomic, strong) UIButton *imageBtn;

@end

@implementation MerchantSettle

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


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"商家入驻";
    [self showBackBtn];
    
    float cellHeight = 40;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, cellHeight*4)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.merchantName = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, Width - 20, 20)];
    self.merchantName.placeholder = @"商家名字";
    self.merchantName.font = [UIFont systemFontOfSize:14];
    self.merchantName.textColor = [UIColor colorWithHexString:kTitleColor];
    [bgView addSubview:self.merchantName];
    
    self.merchantAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, Width - 20, 20)];
    self.merchantAddress.placeholder = @"联系电话";
    self.merchantAddress.keyboardType = UIKeyboardTypeNumberPad;
    self.merchantAddress.font = [UIFont systemFontOfSize:14];
    self.merchantAddress.textColor = [UIColor colorWithHexString:kTitleColor];
    [bgView addSubview:self.merchantAddress];
    
    self.merchantContact = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, Width - 20, 20)];
    self.merchantContact.placeholder = @"商家地址";
    self.merchantContact.font = [UIFont systemFontOfSize:14];
    
    self.merchantContact.textColor = [UIColor colorWithHexString:kTitleColor];
    [bgView addSubview:self.merchantContact];
    
    
    self.addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressBtn.frame = CGRectMake(10, 90, Width-20, 20);
//    self.addressBtn.frame = CGRectMake(10, 130, Width-20, 20);
    [self.addressBtn setTitle:@"所在地区" forState:UIControlStateNormal];
    self.addressBtn.backgroundColor = [UIColor whiteColor];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.addressBtn setTitleColor:[UIColor colorWithHexString:@"#c9c9c9"] forState:UIControlStateNormal];
    [self.addressBtn addTarget:self action:@selector(selectedAdressAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.addressBtn];
    
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageBtn setImage:[UIImage imageNamed:@"icon_common_zhuce_tongyi"] forState:UIControlStateNormal];
    [self.imageBtn addTarget:self action:@selector(selectedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    self.imageBtn.frame = CGRectMake(10, bgView.frame.size.height + bgView.frame.origin.y+10 +2.5, 15, 15);
    [self.view addSubview:self.imageBtn];
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, bgView.frame.size.height + bgView.frame.origin.y+10, 90, 20)];
    warnLabel.font = [UIFont systemFontOfSize:12];
    warnLabel.text = @"我已阅读并同意";
    warnLabel.textColor = [UIColor blackColor];
    [self.view addSubview:warnLabel];
    
    UIButton *dealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dealBtn setTitle:@"入驻协议" forState:UIControlStateNormal];
    [dealBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [dealBtn addTarget:self action:@selector(dealAction:) forControlEvents:UIControlEventTouchUpInside];
    dealBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    dealBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    dealBtn.frame = CGRectMake(25+90, bgView.frame.size.height + bgView.frame.origin.y+10, 60, 20);
    [self.view addSubview:dealBtn];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor colorWithHexString:kNavigationBgColor]];
    [btn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, warnLabel.frame.origin.y + 40, Width - 20, 30);
    btn.layer.cornerRadius = 4;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"立即入驻" forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    self.firstIndex = 0;
    self.secondIndex = 0;
    self.thirdIndex = 0;
    
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
    
}

- (void)dealAction:(UIButton *)sender {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = [NSArray array];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestAgreementLinks" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestAgreementLinksModel *model = [RequestAgreementLinksModel yy_modelWithJSON:baseRes.data];
            [self webController:model];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
}

- (void)webController:(RequestAgreementLinksModel *)model {
    DWWebViewController *webC = [[DWWebViewController alloc] init];
    webC.title = @"入驻协议";
    [webC setUrl:model.merapplyLink];
    [self.navigationController pushViewController:webC animated:YES];
}

- (void)selectedImageAction:(UIButton *)sender {
//    if (sender.selected) {
//        sender.selected = NO;
//        [sender setImage:[UIImage imageNamed:@"icon_common_zhuce_tongyi"] forState:UIControlStateNormal];
//    }else {
//        sender.selected = YES;
//        [sender setImage:[UIImage imageNamed:@"btn_my_zhifudingdan_dagou"] forState:UIControlStateNormal];
//    }
}

- (void)selectedAdressAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self createPickerView];
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

- (void)commitAction:(UIButton *)sender {
    if (self.merchantName.text.length == 0 || self.merchantAddress.text.length == 0 || self.merchantContact.text.length == 0) {
        [self showToast:@"填写信息不完整"];
    }else {
        RequestMerchantApply *merchant = [[RequestMerchantApply alloc] init];
        merchant.merchantName = self.merchantName.text;
        merchant.mobile = self.merchantAddress.text;
        merchant.address = self.merchantContact.text;
        merchant.regionId = self.cityModel.regionId;
        merchant.provinceId = self.provinceModel.regionId;
        merchant.cityId = self.secondModel.regionId;
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.encryptionType = RequestMD5;
        baseReq.data = merchant;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=MerApi/Merchant/requestMerchantApply" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                [self showToast:@"入驻申请提交成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else {
                [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            }
        } faild:^(id error) {
            
        }];

    }
   }

- (void)sureAction:(UIButton *)sender {
    if (self.thirdCity.count == 0 || self.secondCity.count == 0) {
        
    }else {
        self.cityModel = self.thirdCity[self.thirdIndex];
        self.provinceModel = self.firstDataSource[self.firstIndex];
        self.secondModel = self.secondCity[self.secondIndex];
      
            if ([self.secondModel.regionName isEqualToString:@"北京市"]) {
                [self.addressBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
                [self.addressBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.provinceModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
            }else {
                [self.addressBtn setTitleColor:[UIColor colorWithHexString:kTitleColor] forState:UIControlStateNormal];
                [self.addressBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@", self.provinceModel.regionName, self.secondModel.regionName, self.cityModel.regionName] forState:UIControlStateNormal];
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
//    if (self.thirdCity.count == 0 && self.secondCity.count != 0) {
//        return 2;
//    }
//    if (self.secondCity.count == 0) {
//        return 1;
//    }
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



@end