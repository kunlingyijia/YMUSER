//
//  ReservationController.m
//  Go
//
//  Created by 月美 刘 on 16/8/27.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "ReservationController.h"
#import "UIColor+DWColor.h"
#import "RequestTripDetail.h"
#import "RequestTripDetailModel.h"
#import "RequestAddTriporder.h"
#import "GoingOutMessageController.h"
@interface ReservationController ()<UITextFieldDelegate>

@property (nonatomic, strong) RequestTripDetailModel *tripModel;

@end

@implementation ReservationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RContentSizeHeight.constant = 650;
    [self showBackBtn];
    self.title = @"预约";
    //调整样式
    self.peopleCount.layer.borderWidth = 1;
    self.peopleCount.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.getOnPlace.layer.borderWidth = 1;
    self.getOnPlace.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.endDownPlace.layer.borderWidth = 1;
    self.endDownPlace.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.reservationBtn.layer.masksToBounds = YES;
    self.reservationBtn.layer.cornerRadius = 4;
    [self getGoOutMessage];
}

- (void)createView {
    UIScrollView *scrollerV = [UIScrollView new];
    [self.adressBgview addSubview:scrollerV];
    [scrollerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.adressBgview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UIView *corner = [UIView new];
    [scrollerV addSubview:corner];
    [corner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollerV);
        make.height.equalTo(scrollerV);
    }];
    CGFloat itemWidth = 90;
    NSInteger listCount  = self.tripModel.stationNameList.count;
    for (int i = 0; i < listCount; i++) {
       UIView *adressV = [self returnView:corner withIndex:i];
        adressV.tag = 200+i;
        if (i != 0) {
            UIView *lastV = [self.adressBgview viewWithTag:200+i - 1];
            NSString *stepL = self.tripModel.stationNameList[i];
            CGFloat stepW = [stepL getSingleLineTextWidthWithFont:[UIFont systemFontOfSize:14] withMaxWith:100000];
            if (stepW > itemWidth) {
                adressV.frame = CGRectMake(CGRectGetMaxX(lastV.frame), 20, stepW+10, itemWidth);
            }else {
                adressV.frame = CGRectMake(CGRectGetMaxX(lastV.frame), 20, itemWidth, itemWidth);
            }

        }else {
            adressV.frame = CGRectMake(10+i*itemWidth, 20, itemWidth, itemWidth);
        }
        
        if (i == listCount-1) {
            [corner mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(adressV).with.offset(10);
            }];
        }
    }
}

- (UIView *)returnView:(UIView *)corner withIndex:(NSInteger)index {
    UIView *bgView = [[UIView alloc] init];
    [corner addSubview:bgView];
    UILabel *startL = [UILabel new];
    startL.text = @"始发";
    startL.textColor = [UIColor whiteColor];
    startL.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:startL];
    [startL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(10);
        make.top.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    UIImageView *imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"圆角矩形-11"]];
    imagV.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imagV];
    [imagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView);
        make.top.equalTo(startL.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UIImageView *lineImage = [UIImageView new];
    lineImage.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imagV);
        make.left.equalTo(imagV.mas_right);
        make.right.equalTo(bgView);
        make.height.mas_equalTo(@(5));
    }];
    
    UILabel *adresL = [UILabel new];
    adresL.text = self.tripModel.stationNameList[index];
    adresL.textColor = [UIColor whiteColor];
    adresL.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:adresL];
    [adresL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(0);
        make.top.equalTo(imagV.mas_bottom);
        make.right.equalTo(bgView);
        make.height.mas_equalTo(@(20));
    }];
    UILabel *timeL = [UILabel new];
    NSString *strarT = [self.tripModel.startTime substringFromIndex:11];
    timeL.text = [strarT substringToIndex:5];
    timeL.textColor = [UIColor whiteColor];
    timeL.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(8);
        make.top.equalTo(adresL.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    if (index+1 == self.tripModel.stationNameList.count) {
        lineImage.hidden = YES;
        startL.text = @"终点";
        NSString *strarT = [self.tripModel.arriveTime substringFromIndex:11];
        timeL.text = [strarT substringToIndex:5];
        
    }
    if (index+1 != self.tripModel.stationNameList.count && index != 0) {
        startL.hidden = YES;
        timeL.hidden = YES;
    }
    
    
    return bgView;
}

- (void)viewGetData {
    self.startPlace.text = self.tripModel.startPlace;
    self.endPlace.text = self.tripModel.endPlace;
    self.carType.text = self.tripModel.carType;
    self.startTime.text = [self.tripModel.startTime substringToIndex:16];
    self.startTime.textColor = [UIColor colorWithHexString:kTitleColor];
    self.totalPeople.text = [NSString stringWithFormat:@"%@/%@", self.tripModel.hadTicketCount,self.tripModel.ticketCount];
    self.totalPeople.textColor = [UIColor colorWithHexString:kTitleColor];
    
    self.price.text = [NSString stringWithFormat:@"%.2f元", self.tripModel.price];
    self.price.textColor = [UIColor colorWithHexString:kTitleColor];
    
    NSRange range = [self.tripModel.driveTime rangeOfString:@"."];
    if ([self.tripModel.driveTime containsString:@"."]) {
        NSString *hourT = [self.tripModel.driveTime substringToIndex:range.location];
        
        NSInteger minth = [[self.tripModel.driveTime substringFromIndex:range.location] floatValue] * 60;
        self.driveTime.text = [NSString stringWithFormat:@"%@小时%ld分", hourT,(long)minth];
    }else {
        self.driveTime.text = [NSString stringWithFormat:@"%@小时", self.tripModel.driveTime];
    }
    self.driveTime.textColor = [UIColor colorWithHexString:kTitleColor];
    self.kilometer.text = [NSString stringWithFormat:@"%@公里", self.tripModel.kilometer];
    self.kilometer.textColor = [UIColor colorWithHexString:kTitleColor];
    [self createView];
}




//声明预约的触发事件
- (IBAction)ReservationBtnClick:(id)sender {
    if (self.peopleCount.text.length == 0) {
        [self showToast:@"请输入人数"];
    }else if (self.getOnPlace.text.length == 0) {
        [self showToast:@"请输入上车地点"];
    }else if (self.endDownPlace.text.length == 0) {
        [self showToast:@"请输入下车地点"];
    }else {
        
    
    [self showProgress];
    UIButton *btn = sender;
    btn.userInteractionEnabled = NO;
    RequestAddTriporder *triporder = [[RequestAddTriporder alloc] init];
    triporder.getOnPlace = self.getOnPlace.text;
    triporder.getDownPlace = self.endDownPlace.text;
    triporder.tripId = self.tripModel.tripId;
    triporder.ticketCount = self.peopleCount.text;
    triporder.regionId = [AuthenticationModel getRegionID];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[triporder yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Trip/requestAddTriporder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
            btn.userInteractionEnabled = YES;
            GoingOutMessageController *messageC = [[GoingOutMessageController alloc] initWithNibName:@"GoingOutMessageController" bundle:nil];
            NSDictionary *dic = baseRes.data;
            messageC.orderNo = dic[@"orderNo"];
            messageC.isNewC = 6;
            [messageC showSuccessWith:@"预约成功"];
            [self.navigationController pushViewController:messageC animated:YES];
            [self hideProgress];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
            btn.userInteractionEnabled = YES;
            [self hideProgress];
        }
    } faild:^(id error) {
        btn.userInteractionEnabled = YES;
        [self hideProgress];
        
    }];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.RContentSizeHeight.constant = 650+270;
    CGFloat offsetY = 420+textField.frame.origin.y;
    CGFloat Y = offsetY + 190 - (Height - 216.0);
    if (Y>0) {
        [self.scrollerView setContentOffset:CGPointMake(0, Y) animated:YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.RContentSizeHeight.constant = 650;
}

#pragma mark - networking
//出行信息
- (void)getGoOutMessage {
    RequestTripDetail *detail = [[RequestTripDetail alloc] init];
    detail.tripId = self.tripId;
    detail.regionId = [AuthenticationModel getRegionID];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = detail;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Trip/requestTripDetail" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes  = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.tripModel = [RequestTripDetailModel yy_modelWithJSON:baseRes.data];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self viewGetData];
    } faild:^(id error) {
        
    }];
}







@end
