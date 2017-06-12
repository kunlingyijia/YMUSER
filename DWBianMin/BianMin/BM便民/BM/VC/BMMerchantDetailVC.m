//
//  BMMerchantDetailVC.m
//  BianMin
//
//  Created by 席亚坤 on 17/3/8.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BMMerchantDetailVC.h"
#import "BMMerchantDetailOneCell.h"
#import "BMMerchantDetailTwoCell.h"
#import "BMMerchantDetailThreeCell.h"
@interface BMMerchantDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BMMerchantDetailVC
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
    [self.collectionView collectionViewregisterNibArray:@[@"BMMerchantDetailOneCell",@"BMMerchantDetailTwoCell",@"BMMerchantDetailThreeCell",]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    
}
#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            
            
            return 1;
            break;
        }
            
        case 1:
        {
           return  self.dataArray.count;
            
            break;
        }
        case 2:
        {
            return  self.dataArray.count ==0? 0:1;
            
            break;
        }
            
        default:{
             return 10;
            break;
            
        }
    }

   
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            
            BMMerchantDetailOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BMMerchantDetailOneCell" forIndexPath:indexPath];
            //配置item
            
            
            return cell;
            
            break;
        }
            
        case 1:
        {
            BMMerchantDetailTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BMMerchantDetailTwoCell" forIndexPath:indexPath];
            //配置item
            
            
            return cell;
            break;
        }
            
        case 2:
        {
            BMMerchantDetailThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BMMerchantDetailThreeCell" forIndexPath:indexPath];
            //配置item
            
            
            return cell;
            break;
        }
            
            
       
        default:{
            BMMerchantDetailThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BMMerchantDetailThreeCell" forIndexPath:indexPath];
            //配置item
           return cell;
            break;
            
        }
    }

    
    
}

#pragma 集合视图 --约束代理方法
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            
            
            return CGSizeMake(Width, Width);

            break;
        }
            
        case 1:
        {
            return CGSizeMake((Width-100)/2, Width*0.3);

            break;
        }
            
            
        default:{
             return CGSizeMake(Width, Width*0.3);

            break;
            
        }
    }

    
}
//设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    switch (section) {
        case 0:
        {
            
             return UIEdgeInsetsMake(0, 0, 0, 0);
            
            break;
        }
            
        case 1:
        {
             return UIEdgeInsetsMake(5, 5, 5, 5);
            break;
        }
            
            
        default:{
             return UIEdgeInsetsMake(0  , 0, 0, 0);
            break;
            
        }
    }

   
    
}
//设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10 ;
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
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
