//
//  SubmitTGOrderVC.h
//  BianMin
//
//  Created by 席亚坤 on 2017/6/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@class RequestMerchantGoodsListModel;
@interface SubmitTGOrderVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *discountedPrice;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UIView *AddAndDelView;
@property (weak, nonatomic) IBOutlet PublicTF *textTf;
@property (weak, nonatomic) IBOutlet PublicBtn *deleteBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *addBtn;
///通用券
@property (weak, nonatomic) IBOutlet UILabel *toUseLabel;
@property (weak, nonatomic) IBOutlet UIButton *toUseBtn;

///抵用券
@property (weak, nonatomic) IBOutlet UILabel *generalLabel;



@property (weak, nonatomic) IBOutlet UILabel *alltotalLabel;


@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) RequestMerchantGoodsListModel *goodsModel;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *merchantId;
@end
