//
//  IntegralViewController.m
//  BianMin
//
//  Created by kkk on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralViewCell.h"
#import "RequestScoreGoodsListModel.h"
#import "RequestScoreGoodsList.h"
#import "AdressViewController.h"
#import "AdressModel.h"
#import "RequestAddScoreOrder.h"
#import "RecordViewController.h"
#import "RequestAgreementLinksModel.h"
#import "IntegralMessageViewController.h"
@interface IntegralViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *CollectionView;
@property (nonatomic, strong)NSMutableArray *myArray;
@property (nonatomic, strong) NSMutableArray *dataSourceList;
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) NSMutableArray *labelsArr;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation IntegralViewController

- (NSMutableArray *)labelsArr {
    if (!_labelsArr) {
        self.labelsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _labelsArr;
}

- (NSMutableArray *)myArray {
    if (!_myArray) {
        self.myArray = [NSMutableArray arrayWithObjects:@"积分",@"兑换记录",@"积分规则", nil];
    }
    return _myArray;
}
- (NSMutableArray *)dataSourceList {
    if (!_dataSourceList) {
        self.dataSourceList = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分商城";
    self.pageIndex = 1;
    [self showBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCollectionView];
     
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(Bounds.size.width/2-1, Bounds.size.width/2*3/5);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.headerReferenceSize = CGSizeMake(Bounds.size.width, Bounds.size.width*3/5);
    self.CollectionView = [[UICollectionView alloc] initWithFrame:Bounds collectionViewLayout:flowLayout];
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    
    self.CollectionView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.CollectionView];
    [self.CollectionView registerClass:[IntegralViewCell class] forCellWithReuseIdentifier:@"integralCell"];
    [self.CollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];
    
    self.CollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self getTotalScore];
//        [self getGoodsList];
    }];
    
    self.CollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = self.pageIndex + 1;
        [self getTotalScore];
//        [self getGoodsList];
    }];
    
    [self getHeaderImage];
    [self getTotalScore];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择收货地址" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    __weak IntegralViewController *weakSelf = self;
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AdressViewController *adressC = [[AdressViewController alloc] init];
        adressC.isSelectedAdress = @"6";
        adressC.selectedAdress = ^(AdressModel *model) {
            UIAlertController *secondAlertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"已选择收货地址是否兑换" preferredStyle:UIAlertControllerStyleAlert];
            [secondAlertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [secondAlertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf getScoreOrder:indexPath withAdressModel:model];
            }]];
            [self presentViewController:secondAlertC animated:YES completion:nil];
        };
        [self.navigationController pushViewController:adressC animated:YES];
        
    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)getScoreOrder:(NSIndexPath *)indexPath withAdressModel:(AdressModel *)adressModel {
    RequestScoreGoodsListModel *goodsModel = self.dataSourceList[indexPath.row];
    RequestAddScoreOrder *requestScoreOrder = [[RequestAddScoreOrder alloc] init];
    requestScoreOrder.addressId = [adressModel.addressId integerValue];
    requestScoreOrder.scoreGoodsId = goodsModel.scoreGoodsId;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[requestScoreOrder yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestAddScoreOrder" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            [self showToast:@"兑换成功"];
            [self getTotalScore];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    return self.dataSourceList.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IntegralViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"integralCell" forIndexPath:indexPath];
    RequestScoreGoodsListModel *model = self.dataSourceList[indexPath.row];
    [cell cellGetDataModel:model withController:self];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    [self.labelsArr removeAllObjects];
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor colorWithHexString:kViewBg];
        self.shopImageView = [UIImageView new];
//        [photoImage sd_setImageWithURL:[NSURL URLWithString:@"http://gz3158.b0.upaiyun.com/dsq/20151009011045285.jpg"]];
//        photoImage.image = [UIImage imageNamed:@"def_my_jifenshangcheng_banner"];
        [headerView addSubview:self.shopImageView];
    
        NSArray *images = [NSArray arrayWithObjects:@"icon_my_jifenshangcheng_jifen",@"icon_my_jifenshangcheng_duihuanjilu",@"icon_my_jifenshangcheng_jifenguize", nil];
        for (int i = 0; i < 3; i++) {
            UIView *activeView = [[UIView alloc] initWithFrame:CGRectMake(i * (Bounds.size.width/3), ((Bounds.size.width-40)*2/5), Bounds.size.width/3, Bounds.size.width/3 * 2 / 5)];
            activeView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:activeView];
            
            UIImageView *image = [UIImageView new];
            image.image = [UIImage imageNamed:images[i]];
            image.contentMode = UIViewContentModeScaleAspectFit;
            [activeView addSubview:image];
            
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithHexString:kSubTitleColor];
            label.text = [self.myArray objectAtIndex:i];
            [activeView addSubview:label];
            
            [self.labelsArr addObject:label];
            
            activeView.tag = 5000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeView:)];
            [activeView addGestureRecognizer:tap];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(activeView);
                make.top.equalTo(activeView.mas_top).with.offset(5);
                make.height.mas_equalTo(@(20));
                make.width.mas_equalTo(@(20));
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(image.mas_bottom);
                make.centerX.equalTo(activeView);
                make.bottom.equalTo(activeView.mas_bottom).with.offset(5);
                make.width.mas_equalTo(@(Bounds.size.width/3));
            }];
            if (i != 2) {
                UIView *lineV = [UIView new];
                lineV.backgroundColor = [UIColor colorWithHexString:kViewBg];
                [activeView addSubview:lineV];
                [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(activeView).with.offset(-5);
                    make.top.equalTo(activeView).with.offset(5);
                    make.width.mas_equalTo(@(1));
                    make.right.equalTo(activeView);
                    
                }];
            }
        }

        
        [self.shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top);
            make.left.equalTo(headerView.mas_left).with.offset(0);
            make.right.equalTo(headerView.mas_right).with.offset(0);
            make.height.mas_equalTo(@((Bounds.size.width-40)*2/5));
        }];
        
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"   积分好礼";
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor colorWithHexString:kTitleColor];
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shopImageView.mas_bottom).with.offset(Bounds.size.width/3 * 2 / 5 + 5);
            make.bottom.equalTo(headerView.mas_bottom).with.offset(-2);
            make.left.equalTo(headerView.mas_left).with.offset(0);
            make.right.equalTo(headerView.mas_right).with.offset(0);
        }];
        return headerView;
    }
    return nil;
}

#pragma mark - 获取商品列表
- (void)getGoodsList {
    RequestScoreGoodsList *goodsList = [[RequestScoreGoodsList alloc] init];
    goodsList.pageCount = 10;
    goodsList.pageIndex = self.pageIndex;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = goodsList;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestScoreGoodsList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        if (self.pageIndex == 1) {
            [self.dataSourceList removeAllObjects];
        }
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        for (NSDictionary *dic in baseRes.data) {
            RequestScoreGoodsListModel *moedel = [RequestScoreGoodsListModel yy_modelWithDictionary:dic];
            [self.dataSourceList addObject:moedel];
        }
        [self.CollectionView.mj_header endRefreshing];
        [self.CollectionView.mj_footer endRefreshing];
        [self.CollectionView reloadData];
    } faild:^(id error) {
        
    }];
}


- (void)getHeaderImage {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = [NSArray array];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestScoreConf" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSDictionary *dic = baseRes.data;
        
        
        [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]]];
    } faild:^(id error) {
       
    }];
}

- (void)getTotalScore {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestTotalScore" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
//            UILabel *label = self.labelsArr[0];
            [self.myArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@积分", baseRes.data[@"totalScore"]]];
//            label.text = baseRes.data[@"totalScore"];
        }else {
            
        }
        [self getGoodsList];
    } faild:^(id error) {
        
    }];
}


- (void)activeView:(UITapGestureRecognizer *)sender {
    NSInteger count = sender.view.tag - 5000;
    OKLog(@"%ld", (long)count);
    if (count == 1) {
        RecordViewController *recordC = [[RecordViewController alloc] init];
        [self.navigationController pushViewController:recordC animated:YES];
    }else if (count == 0) {
        IntegralMessageViewController *integralMessage = [[IntegralMessageViewController alloc] init];
        [self.navigationController pushViewController:integralMessage animated:YES];
    }else if (count == 2) {
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
}
- (void)webController:(RequestAgreementLinksModel *)model {
    DWWebViewController *webC = [[DWWebViewController alloc] init];
    webC.title = @"积分规则";
    [webC setUrl:model.scoreLink];
    [self.navigationController pushViewController:webC animated:YES];
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
