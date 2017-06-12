//
//  TripEWMVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/2/22.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "TripEWMVC.h"
#import "LBXScanWrapper.h"
#import "TripModel.h"
@interface TripEWMVC ()
@property (weak, nonatomic) IBOutlet UIImageView *EWMImageView;

@end

@implementation TripEWMVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
    _EWMImageView.backgroundColor = [UIColor whiteColor];
    self.EWMImageView. image =[LBXScanWrapper createQRWithString:[NSString stringWithFormat:@"dwbm://%@:%@",self.tripModel.orderNo,self.tripModel.orderId] size:_EWMImageView.bounds.size];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle =UIModalPresentationCustom;
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
- (IBAction)Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
