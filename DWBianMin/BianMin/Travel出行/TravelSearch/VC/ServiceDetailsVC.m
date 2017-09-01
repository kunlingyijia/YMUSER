//
//  ServiceDetailsVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/21.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ServiceDetailsVC.h"
#import "TripModel.h"
#import "CustomAnnotationView.h"
#import "TripAppointmentController.h"
enum {
    AnnotationViewControllerAnnotationTypeRed = 0,
    AnnotationViewControllerAnnotationTypeGreen,
    AnnotationViewControllerAnnotationTypePurple
};
@interface ServiceDetailsVC ()<MAMapViewDelegate>
@property(nonatomic,strong)MAMapView*mapView;
@property (nonatomic ,assign)NSInteger index;
@property(nonatomic,assign) double zoomLevel;
@end

@implementation ServiceDetailsVC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CLLocationCoordinate2D startclLocationCoordinate2D;
    startclLocationCoordinate2D.latitude = [self.tripModel.startPlaceLat floatValue];
    startclLocationCoordinate2D.longitude = [self.tripModel.startPlaceLng floatValue];
    CLLocationCoordinate2D endclLocationCoordinate2D;
    endclLocationCoordinate2D.latitude = [self.tripModel.endPlaceLat floatValue];
    endclLocationCoordinate2D.longitude = [self.tripModel.endPlaceLng floatValue];
    [self addAnnotationWithCooordinate:startclLocationCoordinate2D ];
    [self addAnnotationWithCooordinate:endclLocationCoordinate2D];
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
    self.title = @"车次详情";
    self.avatarUrl.layer.masksToBounds = YES;
    self.avatarUrl.layer.cornerRadius =(0.2*Width-20)/2;
    self.zoomLevel  = 15;
    [self addMap];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.index = 0;
    [self kongjianfuzhi];
}


-(void)kongjianfuzhi{
    
    [self.avatarUrl sd_setImageWithURL:[NSURL URLWithString:self.tripModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"bg_zaijia_1-1"]];
    self.realName.text = self.tripModel.realName;
    ///性别 0-女 1-男
    if ([self.tripModel.gender isEqualToString:@"0"]) {
        self.gender.image = [UIImage imageNamed:@"性别－女"];
    }else{
        self.gender.image = [UIImage imageNamed:@"性别－男"];
    }
    self.carNo.text = [NSString stringWithFormat:@" · %@",self.tripModel.carNo];
    ///1-正常，2-满员，3-已发车，4-已结束
    if ([self.tripModel.planStatus isEqualToString:@"1"]) {
        [self.submitBtn setTitle:@"立即预约" forState:(UIControlStateNormal)];
        self.submitBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
        self.submitBtn.userInteractionEnabled = YES;
        
    }else {
        [self.submitBtn setTitle:@"立即预约" forState:(UIControlStateNormal)];
        self.submitBtn.backgroundColor = [UIColor colorWithHexString:kViewBg];
        self.submitBtn.userInteractionEnabled = NO;
    }

    if ([self.tripModel.restNumber isEqualToString:@"0"]) {
//        self.seatNumber.hidden = YES;
        self.seatNumber.text = @"当前已满员";
    }else{
        self.seatNumber.text = [NSString stringWithFormat:@"剩余%@座",self.tripModel.restNumber];
       //self.seatNumber.hidden = NO;
    }
    self.carColor.text =[NSString stringWithFormat:@"%@·%@",self.tripModel.carColor,self.tripModel.carBrand];
    self.startPlace.text = self.tripModel.startPlace;
    self.endPlace.text = self.tripModel.endPlace;
    self.price.text =[NSString stringWithFormat:@"支付金额:%@元", self.tripModel.price];
    
}
#pragma mark - 提交
- (IBAction)submitBtnAction:(PublicBtn *)sender {
    if ([self isLogin]) {
    self.view.userInteractionEnabled = NO;
    //Push 跳转
    TripAppointmentController * VC = [[TripAppointmentController alloc]initWithNibName:@"TripAppointmentController" bundle:nil];
    VC.tripModel = self.tripModel;
    [self.navigationController  pushViewController:VC animated:YES];
    }else{
    LoginController *loginController = [[LoginController alloc] init];
    [self.navigationController pushViewController:loginController animated:YES];
 }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -添加地图
-(void)addMap{
   
    self.mapView = [[MAMapView alloc] initWithFrame:self.Map.bounds];
    [self.mapView setZoomLevel:self.zoomLevel animated:YES];
    CLLocationCoordinate2D startclLocationCoordinate2D;
    startclLocationCoordinate2D.latitude = [self.tripModel.startPlaceLat floatValue];
    startclLocationCoordinate2D.longitude = [self.tripModel.startPlaceLng floatValue];
    [self.mapView setCenterCoordinate:startclLocationCoordinate2D];
    self.mapView.delegate = self;
    [self.Map addSubview:self.mapView];
    UIView *zoomPannelView = [self makeZoomPannelView];
    NSLog(@"%f",self.Map.frame.size.height);
    NSLog(@"%f",self.view.frame.size.height);
    zoomPannelView.center = CGPointMake(Width -  CGRectGetMidX(zoomPannelView.bounds) - 20,
                                        self.Map.frame.size.height/2 );
    [self.Map addSubview:zoomPannelView];
    
    
}
- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 80)];
    //ret.backgroundColor =[UIColor redColor];
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    //[incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 35, 40)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    //[decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}
- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    self.zoomLevel= oldZoom + 1;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    self.zoomLevel= oldZoom - 1;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

#pragma mark - Utility

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
//    annotation.title    = @"AutoNavi";
//    annotation.subtitle = @"CustomAnnotationView";
    [self.mapView addAnnotation:annotation];
}




#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        self.index ++;
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        if (self.index==1) {
            annotationView.portrait = [UIImage imageNamed:@"起"];
        }else if (self.index==2){
            annotationView.portrait = [UIImage imageNamed:@"终"];
        }
        
                
        return annotationView;
    }
    
    return nil;
}
/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    self.zoomLevel =mapView.zoomLevel;
}


@end
