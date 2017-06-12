//
//  OwnerPositionVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/24.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OwnerPositionVC.h"
#import "TripModel.h"
#import "CustomAnnotationView.h"
enum {
    AnnotationViewControllerAnnotationTypeRed = 0,
    AnnotationViewControllerAnnotationTypeGreen,
    AnnotationViewControllerAnnotationTypePurple
};
@interface OwnerPositionVC ()<MAMapViewDelegate>{
    CustomAnnotationView *_annotationView;
}
@property(nonatomic,strong)MAMapView*mapView;
@property (nonatomic ,assign)NSInteger index;
@property(nonatomic,assign) double zoomLevel;
@end
@implementation OwnerPositionVC

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
    self.title = @"车主位置";
    self.zoomLevel  = 18;
    [self addMap];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    [self kongjianfuzhi];
    //获取行程车主位置(司机点发车了才可以)

    [self requestPosition];
    
}
#pragma mark - 获取行程车主位置(司机点发车了才可以)
-(void)requestPosition{
         TripModel *model = [TripModel new];
         NSString *Token =[AuthenticationModel getLoginToken];
         model.planId = self.tripModel.planId;
    NSLog(@"%@",model.planId);
         __weak typeof(self) weakself = self;
         if (Token.length!= 0) {
             BaseRequest *baseReq = [[BaseRequest alloc] init];
             baseReq.token = [AuthenticationModel getLoginToken];
             baseReq.encryptionType = AES;
             baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
             [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/TravelDriver/requestPosition" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response)  {
                 
                 NSLog(@"获取行程车主位置(司机点发车了才可以)----%@",response);
                 if ([response[@"resultCode"] isEqualToString:@"1"]) {
                     NSDictionary * dic =response[@"data"];
                     if (dic.count !=0) {
                        
                         CLLocationCoordinate2D startclLocationCoordinate2D;
                         startclLocationCoordinate2D.latitude = [dic [@"lat"] floatValue];
                         startclLocationCoordinate2D.longitude = [dic [@"lng"] floatValue];
                         [weakself.mapView setCenterCoordinate:startclLocationCoordinate2D];
                         [weakself addAnnotationWithCooordinate:startclLocationCoordinate2D ];
                         
                     }
                     
                     
                    
                 }else{
                     [weakself showToast:response[@"msg"]];
                     
                 }
                 
             } faild:^(id error) {
                 NSLog(@"%@", error);
             }];
             
         }else {
             
         }
         

         
         
     }

-(void)kongjianfuzhi{
    
    [self.avatarUrl sd_setImageWithURL:[NSURL URLWithString:_tripModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"bg_zaijia_1-1"]];
    self.realName.text = _tripModel.realName;
    ///性别 0-女 1-男
    if ([_tripModel.gender isEqualToString:@"0"]) {
        self.gender.image = [UIImage imageNamed:@"性别－女"];
    }else{
        self.gender.image = [UIImage imageNamed:@"性别－男"];
    }
    self.carNo.text = [NSString stringWithFormat:@" · %@",_tripModel.carNo];
    [self.TwoBtn setImage:[UIImage imageNamed:@"电话－绿色"] forState:(UIControlStateNormal)];
    [self.OneBtn setImage:[UIImage imageNamed:@"刷新"] forState:(UIControlStateNormal)];
    //订单状态：1-未支付，2-待上车（已支付），3-已上车，4-已完成，5-退款中，6-已退款，7-已取消
//    if ([_tripModel.status isEqualToString:@"2"]||[_tripModel.status isEqualToString:@"3"]) {
//        [self.TwoBtn setImage:[UIImage imageNamed:@"电话－绿色"] forState:(UIControlStateNormal)];
//        self.TwoBtn.userInteractionEnabled = YES;
//        
//    }else {
//        [self.TwoBtn setImage:[UIImage imageNamed:@"定位－灰色"] forState:(UIControlStateNormal)];
//        self.TwoBtn.userInteractionEnabled = NO;
//    }
//    ///1-展示，0-不展示
//    if ([_tripModel.isShowPosition isEqualToString:@"0"]) {
//        [self.OneBtn setImage:[UIImage imageNamed:@"定位"] forState:(UIControlStateNormal)];
//        self.OneBtn.userInteractionEnabled = NO;
//    }else{
//        [self.OneBtn setImage:[UIImage imageNamed:@"定位－绿色"] forState:(UIControlStateNormal)];
//        self.OneBtn.userInteractionEnabled = YES;
//    }
    self.carColor.text =[NSString stringWithFormat:@"%@·%@",_tripModel.carColor,_tripModel.carBrand];

    
}
#pragma mark -添加地图
-(void)addMap{
    UIView * MView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.2*Width, Width, Height-0.2*Width-64)];
    [self.view addSubview:MView];
    self.mapView = [[MAMapView alloc] initWithFrame:MView.bounds];
    [self.mapView setZoomLevel:self.zoomLevel animated:YES];

    self.mapView.delegate = self;
    [MView addSubview:self.mapView];
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(Width -  CGRectGetMidX(zoomPannelView.bounds) - 20,
                                        MView.frame.size.height/2 );
    
    [MView addSubview:zoomPannelView];
    
    
}
- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 80)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 40)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 35, 40)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
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
    
    [self.mapView addAnnotation:annotation];
}




#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
      
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
            
        if (_annotationView == nil)
        {
         _annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
            _annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            _annotationView.canShowCallout = YES;
         
            _annotationView.draggable = YES;
            _annotationView.calloutOffset = CGPointMake(0, -5);
            _annotationView.portrait = [UIImage imageNamed:@"巴士"];
        }else{
           _annotationView.portrait = [UIImage imageNamed:@"巴士"];
        }
       
        

        return _annotationView;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 刷新车主位置
- (IBAction)OneBtnAction:(UIButton *)sender {
    //获取行程车主位置(司机点发车了才可以)
    
    [self requestPosition];
}
#pragma mark - 拨打电话
- (IBAction)TwoBtnAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    
    [self alertWithTitle:@"温馨提示" message:@"是否拨打司机电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",weakSelf.tripModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [weakSelf.view addSubview:callWebview];
    } withCancel:^(UIAlertAction *cancelaction) {
        
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
