//
//  OrderContentViewController.m
//  BianMin
//
//  Created by kkk on 16/5/13.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "OrderContentViewController.h"
#import "RefundViewController.h"
#import "ShopContentViewController.h"
#import "RefundContentViewController.h"
#import "RequestMyGoodsOrderDetail.h"
#import "RequestMyGoodsOrderDetailModel.h"
#import "RequestMerchantDetail.h"
#import "RequestMerchantDetailModel.h"
#import "PayViewController.h"
#import "RequestMerchantGoodsListModel.h"
#import "RefundContentViewController.h"
#import "UserOrderViewController.h"
#import "TalkController.h"
#import "RequestMerchantGoodsListModel.h"
#import "RequestMerchantDetailModel.h"
#import "RefundContentViewController.h"
#import "RequestPayOrderModel.h"
@interface OrderContentViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UIView *shopView;
@property (nonatomic, strong) RequestMyGoodsOrderDetailModel *messageModel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) RequestMerchantDetailModel *shopModel;
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation OrderContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isPayBack==6) {
        [self newShowBackBtn];
    }else {
        [self showBackBtn];
    }
    self.scroller = [UIScrollView new];
    self.scroller.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scroller];
    [self.scroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_bottom).with.offset(10);
        make.right.left.bottom.equalTo(self.view);
    }];
    self.container = [UIView new];
    [self.scroller addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroller);
        make.width.equalTo(self.scroller);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopAction:)];
    [self.shopView addGestureRecognizer:tap];
    self.title = @"订单详情";
   
    
    [self getDataMessage];
}

- (void)newShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(newDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)newDoBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)createView {
    [self loadImageWithView:self.pictureImage urlStr:self.messageModel.originUrl];
    self.nameLabel.text = self.messageModel.goodsName;
    self.subNameLabel.text = self.messageModel.content;
    self.priceLaebl.text = [NSString stringWithFormat:@"¥%.2f", self.messageModel.payAmount];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:@"付款" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    buyBtn.layer.masksToBounds = YES;
    buyBtn.layer.cornerRadius = 3;
    buyBtn.backgroundColor = [UIColor colorWithHexString:kNavigationBgColor];
    [buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container);
        make.left.equalTo(self.container).with.offset(10);
        make.right.equalTo(self.container).with.offset(-10);
        make.height.mas_equalTo(@(30));
    }];
    
    NSInteger heightCount = self.messageModel.coupons.count;
    self.bgView = [[UIView alloc] init];
    [self.container addSubview:self.bgView];
    if ([self.messageModel.status isEqualToString: @"2"]) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyBtn.mas_bottom);
            make.right.left.equalTo(self.container);
            make.height.mas_equalTo(65 + heightCount*(30+5)+30);
        }];
    }else {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyBtn.mas_bottom);
            make.right.left.equalTo(self.container);
            make.height.mas_equalTo(65 + heightCount*(30+5));
        }];
    }
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    UILabel *showOrder = [UILabel new];
    [self.bgView addSubview:showOrder];
    showOrder.font = [UIFont systemFontOfSize:12];
    showOrder.text = @"易民券";
    showOrder.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [showOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    if ([self.messageModel.status isEqualToString:@"0"]) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyBtn.mas_bottom);
            make.right.left.equalTo(self.container);
            make.height.mas_equalTo(1);
        }];
        self.bgView.hidden = YES;
    }else {
        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.container);
            make.left.equalTo(self.container).with.offset(10);
            make.right.equalTo(self.container).with.offset(-10);
            make.height.mas_equalTo(@(1));
        }];
        buyBtn.hidden = YES;
    }
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switch ([self.messageModel.status intValue]) {
        case 0:
            [self.sureBtn setTitle:@"付款" forState:UIControlStateNormal];
            break;
        case 1:
            [self.sureBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            break;
        case 2:
            [self.sureBtn setTitle:@"退款中" forState:UIControlStateNormal];
            break;
        case 3:
            [self.sureBtn setTitle:@"评价" forState:UIControlStateNormal];
            break;
        case 4:
            [self.sureBtn setTitle:@"已退款" forState:UIControlStateNormal];
            break;
        case 5:
            [self.sureBtn setTitle:@"已取消" forState:UIControlStateNormal];
            break;
        case 6:
            [self.sureBtn setTitle:@"已完成" forState:UIControlStateNormal];
            break;
        case 8:
            [self.sureBtn setTitle:@"退款中" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.sureBtn.layer.borderColor = [UIColor colorWithHexString:kNavigationBgColor].CGColor;
    [self.sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.layer.borderWidth = 1;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 3;
    
    [self.sureBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.bgView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(10);
        make.right.equalTo(self.bgView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.bgView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureBtn.mas_bottom).with.offset(5);
        make.left.equalTo(self.bgView).with.offset(10);
        make.right.equalTo(self.bgView).with.offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *couponLabel = [UILabel new];
    couponLabel.font = [UIFont systemFontOfSize:12];
    couponLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self.bgView addSubview:couponLabel];
    [couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showOrder.mas_bottom).with.offset(10);
        make.left.equalTo(self.bgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    couponLabel.text = [NSString stringWithFormat:@"有效期至:%@", self.messageModel.endTime];
    
    CGFloat couponWidth = Width - 20;
    for (int i = 0; i < self.messageModel.coupons.count; i++) {
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65+(i*(30+5)), couponWidth, 30)];
        NSDictionary *dic = self.messageModel.coupons[i];
        NSString *couponStr = dic[@"couponNo"];
        NSString *text = couponStr;
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        passwordLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
        //设置label的不同颜色
        NSString *passwordStr = [NSString stringWithFormat:@"密码%d:  %@", i+1, newString];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:passwordStr];
        NSRange r;
        r=[str.string rangeOfString:newString];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:kTitleColor] range:r
         ]; //设置字体颜色
        
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:15] range:r]; //设置字体字号和字体类别
        passwordLabel.attributedText = str;
        
        passwordLabel.font = [UIFont systemFontOfSize:12];
        [self.bgView addSubview:passwordLabel];
        
        UIView *passwordLine = [UILabel new];
        passwordLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
        [self.bgView addSubview:passwordLine];
        [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(passwordLabel.mas_top).with.offset(-2.25);
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(@(1));
        }];
        
        UIButton *useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        useBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        useBtn.tag = 2000+i;
        [useBtn addTarget:self action:@selector(useAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString * status = [NSString stringWithFormat:@"%@", dic[@"status"]];
        if ([status isEqualToString:@"0"]) {
            [useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = YES;
        }else if([status isEqualToString:@"1"]){
            [useBtn setTitle:@"已使用" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = NO;
        }else if ([status isEqualToString:@"2"]) {
            [useBtn setTitle:@"退款中" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = NO;
        }else if ([status isEqualToString:@"3"]) {
            [useBtn setTitle:@"退款完成" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = NO;
        }
        [self.bgView addSubview:useBtn];
        [useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(passwordLabel);
            make.right.equalTo(self.bgView).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
    }
    
    if ([self.messageModel.status isEqualToString: @"2"]) {
        UIButton *refundMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        [refundMessage setTitle:@"退款详情" forState:UIControlStateNormal];
        refundMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [refundMessage addTarget:self action:@selector(refundMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        [refundMessage setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
        refundMessage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.bgView addSubview:refundMessage];
        [refundMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView);
            make.left.equalTo(self.bgView).with.offset(10);
            make.right.equalTo(self.bgView).with.offset(-30);
            make.height.mas_equalTo(@(30));
        }];
        
        UIImageView *refundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_class_xiangqing_right_jiantou"]];
        refundImage.contentMode = UIViewContentModeScaleAspectFit;
        //    refundImage.backgroundColor = [UIColor redColor];
        [self.bgView addSubview:refundImage];
        [refundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(refundMessage);
            make.left.equalTo(refundMessage.mas_right);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UIView *refundLine = [UIView new];
        refundLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
        [self.bgView addSubview:refundLine];
        [refundLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(refundMessage.mas_top);
            make.right.equalTo(self.bgView).with.offset(-10);
            make.left.equalTo(self.bgView).with.offset(10);
            make.height.mas_equalTo(@(1));
        }];

    }
    
    
    
    UIView *shopBgview = [UIView new];
    shopBgview.backgroundColor = [UIColor whiteColor];
    [self.container addSubview:shopBgview];
    [shopBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).with.offset(10);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@(115));
    }];
    UILabel *shopMessage = [UILabel new];
    shopMessage.text = @"商家信息";
    shopMessage.textColor = [UIColor colorWithHexString:kSubTitleColor];
    shopMessage.font = [UIFont systemFontOfSize:12];
    [shopBgview addSubview:shopMessage];
    [shopMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(shopBgview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    UILabel *talkLabel = [UILabel new];
    talkLabel.text = [NSString stringWithFormat:@"%@条评论", self.shopModel.totalComment];
    talkLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    talkLabel.textAlignment = NSTextAlignmentRight;
    talkLabel.font = [UIFont systemFontOfSize:12];
    [shopBgview addSubview:talkLabel];
    [talkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopBgview).with.offset(10);
        make.right.equalTo(shopBgview.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    UIView *secondLine = [UIView new];
    secondLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [shopBgview addSubview:secondLine];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopMessage.mas_bottom).with.offset(5);
        make.left.equalTo(shopBgview).with.offset(10);
        make.right.equalTo(shopBgview).with.offset(-10);
        make.height.mas_equalTo(@(1));
    }];
    
    UILabel *shopNameLabel = [UILabel new];
    shopNameLabel.text = self.shopModel.merchantName;
    shopNameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    shopNameLabel.font = [UIFont systemFontOfSize:12];
    [shopBgview addSubview:shopNameLabel];
    [shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLine.mas_bottom).with.offset(5);
        make.left.equalTo(shopBgview.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(Width-20, 20));
    }];
    
    UILabel *adressLabel = [UILabel new];
    adressLabel.text = self.shopModel.address;
    adressLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    adressLabel.font = [UIFont systemFontOfSize:12];
    adressLabel.userInteractionEnabled = YES;
    [shopBgview addSubview:adressLabel];
    UITapGestureRecognizer *adressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapSelectedAction:)];
    [adressLabel addGestureRecognizer:adressTap];
    
    [adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopNameLabel.mas_bottom);
        make.left.equalTo(shopBgview.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(Width-40, 30));
    }];
    
    UIImageView *adressImage = [UIImageView new];
    adressImage.contentMode = UIViewContentModeScaleAspectFit;
    adressImage.image = [UIImage imageNamed:@"btn_class_xiangqing_gps"];
    [shopBgview addSubview:adressImage];
    [adressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adressLabel.mas_bottom);
        make.left.equalTo(shopBgview).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UILabel *distanceL = [UILabel new];
    double distance = [self getStarWith:self.shopModel];
    if (distance > 1) {
        distanceL.text = [NSString stringWithFormat:@"%.1fkm", distance];
    }else {
        distanceL.text = [NSString stringWithFormat:@"%.0fm", distance*1000];
    }
    
    distanceL.textColor = [UIColor colorWithHexString:kSubTitleColor];
    distanceL.font = [UIFont systemFontOfSize:12];
    [shopBgview addSubview:distanceL];
    [distanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressImage);
        make.left.equalTo(adressImage.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
    
    UILabel *distanceMylabel = [UILabel new];
    distanceMylabel.text = @"离我最近";
    distanceMylabel.font = [UIFont systemFontOfSize:12];
    distanceMylabel.textColor = [UIColor colorWithHexString:@"#ff9712"];
    [shopBgview addSubview:distanceMylabel];
    [distanceMylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressImage);
        make.left.equalTo(distanceL.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 15));
    }];
    
    UIImageView *phoneImage = [UIImageView new];
    phoneImage.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneAction:)];
    phoneImage.userInteractionEnabled = YES;
    [phoneImage addGestureRecognizer:tap];
    phoneImage.image = [UIImage imageNamed:@"btn_class_xiangqing_call"];
    [shopBgview addSubview:phoneImage];
    [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressLabel);
        make.right.equalTo(shopBgview).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIView *goodsBgView = [UIView new];
    goodsBgView.backgroundColor = [UIColor whiteColor];
    [self.container addSubview:goodsBgView];
    [goodsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopBgview.mas_bottom).with.offset(10);
        make.right.left.equalTo(self.container);
        make.height.mas_equalTo(@(140));
    }];
    
    UILabel *orderMessageL = [UILabel new];
    orderMessageL.text = @"订单信息";
    orderMessageL.textColor = [UIColor colorWithHexString:kSubTitleColor];
    orderMessageL.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:orderMessageL];
    [orderMessageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsBgView).with.offset(10);
        make.top.equalTo(goodsBgView).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UIView *orderLine = [UIView new];
    orderLine.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [goodsBgView addSubview:orderLine];
    [orderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderMessageL.mas_bottom).with.offset(5);
        make.right.equalTo(self.container).with.offset(-10);
        make.left.equalTo(self.container).with.offset(10);
        make.height.mas_equalTo(@(1));
    }];
    
    UILabel *orderNoName = [UILabel new];
    orderNoName.text = @"订单号:";
    orderNoName.textColor = [UIColor colorWithHexString:kSubTitleColor];
    orderNoName.textAlignment = NSTextAlignmentRight;
    orderNoName.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:orderNoName];
    [orderNoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsBgView).with.offset(10);
        make.top.equalTo(orderLine).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *orderNo = [UILabel new];
    orderNo.text = self.messageModel.orderNo;
    orderNo.textColor = [UIColor colorWithHexString:kSubTitleColor];
    orderNo.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:orderNo];
    [orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderNoName.mas_right).with.offset(5);
        make.centerY.equalTo(orderNoName);
        make.right.equalTo(goodsBgView).with.offset(-10);
    }];
    
    UILabel *buyTimeName = [UILabel new];
    buyTimeName.text = @"下单时间:";
    buyTimeName.textColor = [UIColor colorWithHexString:kSubTitleColor];
    buyTimeName.textAlignment = NSTextAlignmentRight;
    buyTimeName.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:buyTimeName];
    [buyTimeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsBgView).with.offset(10);
        make.top.equalTo(orderNoName.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *buyTime = [UILabel new];
    buyTime.text = self.messageModel.createTime;
    buyTime.textColor = [UIColor colorWithHexString:kSubTitleColor];
    buyTime.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:buyTime];
    [buyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyTimeName.mas_right).with.offset(5);
        make.centerY.equalTo(buyTimeName);
        make.right.equalTo(goodsBgView).with.offset(-10);
    }];
    
    UILabel *goodsNumName = [UILabel new];
    goodsNumName.text = @"数量:";
    goodsNumName.textColor = [UIColor colorWithHexString:kSubTitleColor];
    goodsNumName.textAlignment = NSTextAlignmentRight;
    goodsNumName.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:goodsNumName];
    [goodsNumName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsBgView).with.offset(10);
        make.top.equalTo(buyTimeName.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *goodsNum = [UILabel new];
    goodsNum.text = self.messageModel.goodsNumber;
    goodsNum.textColor = [UIColor colorWithHexString:kSubTitleColor];
    goodsNum.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:goodsNum];
    [goodsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsNumName.mas_right).with.offset(5);
        make.centerY.equalTo(goodsNumName);
        make.right.equalTo(goodsBgView).with.offset(-10);
    }];
    
    UILabel *priceName = [UILabel new];
    priceName.text = @"总价:";
    priceName.textColor = [UIColor colorWithHexString:kSubTitleColor];
    priceName.textAlignment = NSTextAlignmentRight;
    priceName.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:priceName];
    [priceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsBgView).with.offset(10);
        make.top.equalTo(goodsNumName.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *price = [UILabel new];
    price.text = [NSString stringWithFormat:@"¥%.2f", self.messageModel.payAmount];
    price.textColor = [UIColor colorWithHexString:kSubTitleColor];
    price.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceName.mas_right).with.offset(5);
        make.centerY.equalTo(priceName);
        make.right.equalTo(goodsBgView).with.offset(-10);
    }];
    
    UILabel *couponName = [UILabel new];
    couponName.text = @"优惠券:";
    couponName.textColor = [UIColor colorWithHexString:kSubTitleColor];
    couponName.textAlignment = NSTextAlignmentRight;
    couponName.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:couponName];
    [couponName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsBgView).with.offset(10);
        make.top.equalTo(priceName.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UILabel *couponNo = [UILabel new];
        if (self.messageModel.couponId != nil) {
            double dvalue = self.messageModel.dValue%10;
            switch (self.messageModel.couponType) {
                case 1:
                    couponNo.text = [NSString stringWithFormat:@"满%.2f元, 减%.2f元", self.messageModel.mPrice, self.messageModel.mVaule];
                    break;
                case 2:
                    couponNo.text = [NSString stringWithFormat:@"立减%.2f元", self.messageModel.lValue];
                    break;
                case 3:
                    if (dvalue == 0) {
                        couponNo.text = [NSString stringWithFormat:@"%.0f折", self.messageModel.dValue/10.0];
                    }else {
                        couponNo.text = [NSString stringWithFormat:@"%.1f折", self.messageModel.dValue/10.0];
                    }
                    break;
                default:
                    break;
            }
        }else {
            couponNo.text = @"无";
        }
    
    couponNo.textColor = [UIColor colorWithHexString:kSubTitleColor];
    couponNo.font = [UIFont systemFontOfSize:12];
    [goodsBgView addSubview:couponNo];
    [couponNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponName.mas_right).with.offset(5);
        make.centerY.equalTo(couponName);
        make.right.equalTo(goodsBgView).with.offset(-10);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsBgView.mas_bottom);
    }];
}



- (CGFloat)getStarWith:(RequestMerchantDetailModel *)model {
    DWHelper *helper = [DWHelper shareHelper];
    CLLocationCoordinate2D statr = helper.coordinate;
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:statr.latitude  longitude:statr.longitude];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:[model.lat doubleValue] longitude:[model.lng doubleValue]];
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    return kilometers;
}

- (void)refundMessageAction:(UIButton *)sender {
    RefundContentViewController *refundC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"RefundContentViewController"];
    
    refundC.orderNo = self.messageModel.orderNo;
    refundC.goodsOrderId = self.messageModel.goodsOrderId;
    [self.navigationController pushViewController:refundC animated:YES];
    OKLog(@"退款详情");
}


- (void)sureAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"付款"]) {
        
    }else if ([sender.titleLabel.text isEqualToString:@"申请退款"]) {
        RefundViewController *refundC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"RefundViewController"];
        refundC.messageModel = self.messageModel;
        [self.navigationController pushViewController:refundC animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"退款中"]) {
        RefundContentViewController *refundContentC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"RefundContentViewController"];
        refundContentC.orderNo = self.messageModel.orderNo;
        refundContentC.goodsOrderId = self.messageModel.goodsOrderId;
        [self.navigationController pushViewController:refundContentC animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"评价"]) {
        TalkController *talkController = [[TalkController alloc] init];
        RequestMyGoodsOrderListModel *model = [RequestMyGoodsOrderListModel yy_modelWithJSON:[self.messageModel yy_modelToJSONString]];
        talkController.model = model;
        [self.navigationController pushViewController:talkController animated:YES];
    }
}

#pragma  mark - 地图选择
- (void)mapSelectedAction:(UIButton *)tap {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"百度地图",@"高德地图", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DWHelper *helper = [DWHelper shareHelper];
    CLLocationCoordinate2D startLocation = helper.coordinate;
    if (buttonIndex == 0) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
            NSString *name = @"";
            CLLocationCoordinate2D Coordinate ;
            Coordinate.latitude = [self.shopModel.lat doubleValue];
            Coordinate.longitude = [self.shopModel.lng doubleValue];
            CLLocationCoordinate2D Coordinate2D = [self BD09FromGCJ02:Coordinate];
            NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",startLocation.latitude, startLocation.longitude,  Coordinate2D.latitude, Coordinate2D.longitude, name];
           // NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",startLocation.latitude, startLocation.longitude,  [self.shopModel.lat floatValue], [self.shopModel.lng floatValue], name];
            [self openMap:urlString];
        }else {
            [self sheetAction:@"百度地图"];
        }
    }else if( buttonIndex == 1) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
            NSString *name = @"东吴科技";

            NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",name, [self.shopModel.lat floatValue], [self.shopModel.lng floatValue]];
            [self openMap:urlString];
        }else {
            [self sheetAction:@"高德地图"];
        }
    }
}
- (void)openMap:(NSString *)urlString {
    NSString *string = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    [[UIApplication sharedApplication] openURL:url];
}
// 高德坐标转百度坐标
- (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}
- (void)sheetAction:(NSString *)title {
    UIAlertView *alertController = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您还未安装%@客户端,请安装", title] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertController show];
    //    UIAlertController *noAler = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您还未安装%@客户端,请安装", title] preferredStyle:UIAlertControllerStyleAlert];
    //    [noAler addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    //    [self presentViewController:noAler animated:YES completion:nil];
}



- (void)phoneAction:(UITapGestureRecognizer *)sender {
    OKLog(@"拨打电话");
    if (self.shopModel.isCallCenter == 1) {
        [self callPhoneAction];
    }else {
        
        
        __weak typeof(self) weakSelf = self;
        
        [self alertWithTitle:@"温馨提示" message:@"是否拨打电话?" OKWithTitle:@"确定" CancelWithTitle:@"稍后再说" withOKDefault:^(UIAlertAction *defaultaction) {
           
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.shopModel.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//            UIWebView * callWebview = [[UIWebView alloc] init];
//            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//            [weakSelf.view addSubview:callWebview];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];

//        NSString *phoneUrl = [NSString stringWithFormat:@"tel://%@", self.shopModel.mobile];//tel打电话 sms发信息
//        //进行拨号操作（该拨号方式苹果不允许使用）
//        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
//        //网页拨号
//        //创建网页对象
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        [self.view addSubview:webView];
//        //利用网页对象实现拨号操作
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneUrl]]];
    }
}
- (void)buyAction:(UIButton *)sender {
    PayViewController *payController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PayViewController"];
    payController.goodsNum = [self.messageModel.goodsNumber integerValue];
    payController.sumPrice = self.messageModel.payAmount;
     RequestPayOrderModel *payModel = [RequestPayOrderModel yy_modelWithJSON:[self.messageModel yy_modelToJSONString]];
    NSLog(@"payModel--%@",[payModel yy_modelToJSONObject]);
    
    RequestMerchantGoodsListModel *goodsModel = [RequestMerchantGoodsListModel yy_modelWithJSON:[self.messageModel yy_modelToJSONString]];
    
    payController.goodsModel = goodsModel;
    NSLog(@"goodsOrderId--%@",[goodsModel yy_modelToJSONObject]);
    payController.payOrderModel = payModel;
    [self.navigationController pushViewController:payController animated:YES];
}
- (void)useAction:(UIButton *)sender {
    OKLog(@"点击使用");
    UserOrderViewController *userController = [[UserOrderViewController alloc] init];
    __weak OrderContentViewController *weakSelf = self;
    userController.backAction = ^(NSString *str) {
        [weakSelf getNewMessage];
    };
    userController.isUse = @"6";
    NSArray *couponArr = self.messageModel.coupons;
    NSInteger count = sender.tag -2000;
    NSDictionary *dic = couponArr[count];
//    userController.model = model;
    NSLog(@"%lu", (unsigned long)couponArr.count);
    

    userController.couponNo = dic[@"couponNo"];
    userController.goodsOrderCouponId = dic[@"goodsOrderCouponId"];
    userController.orderNo = dic[@"orderNo"];
    userController.goodsOrderId = dic[@"goodsOrderId"];
    
    
    //userController.orderNo = self.messageModel.orderNo;
    
    [self.navigationController pushViewController:userController animated:YES];
}

- (void)viewGetData {
    [self createView];
//    self.dateLabel.text = [NSString stringWithFormat:@"有效期至:%@", self.messageModel.endTime];
//    self.couponLabel.text = @"订单信息";
//    self.passWordLabel.text = self.messageModel.orderNo;
//    if (self.messageModel.merchantId == nil || self.messageModel.merchantId == NULL) {
//        self.couponBtn.userInteractionEnabled = YES;
//    }else {
//        [self.couponBtn setTitle:[NSString stringWithFormat:@"优惠券信息:%@", self.messageModel.merchantId] forState:UIControlStateNormal];
//    }
//    switch (self.messageModel.status) {
//        case 0:
//            [self.refundBtn setTitle:@"付款" forState:UIControlStateNormal];
//            break;
//        case 1:
//            [self.refundBtn setTitle:@"待使用" forState:UIControlStateNormal];
//            break;
//        case 2:
//            [self.refundBtn setTitle:@"退款中" forState:UIControlStateNormal];
//            break;
//        case 3:
//            [self.refundBtn setTitle:@"待评价" forState:UIControlStateNormal];
//            break;
//        case 4:
//            [self.refundBtn setTitle:@"已退款" forState:UIControlStateNormal];
//            self.refundBtn.userInteractionEnabled = NO;
//            break;
//        case 5:
//            [self.refundBtn setTitle:@"取消订单" forState:UIControlStateNormal];
//            break;
//        case 6:
//            [self.refundBtn setTitle:@"已完成" forState:UIControlStateNormal];
//            self.refundBtn.userInteractionEnabled = NO;
//            break;
//            
//        default:
//            break;
//    }
}


- (IBAction)refundAction:(id)sender {
    RefundViewController *refundController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RefundViewController"];
    refundController.messageModel = self.messageModel;
    [self.navigationController pushViewController:refundController animated:YES];
    OKLog(@"申请退款");
}
- (IBAction)refundContentAction:(id)sender {
    RefundContentViewController *refundCV = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RefundContentViewController"];
    [self.navigationController pushViewController:refundCV animated:YES];
    OKLog(@"查看退款详情");
}
- (IBAction)phoneCall:(id)sender {
    
    
    
    
    NSString *PhoneNum = [NSString stringWithFormat:@"tel:%@", @"10010"];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PhoneNum]]];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否拨打客服电话" preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    //模态跳转
//    [self presentViewController:alert animated:YES completion:nil];
    OKLog(@"拨打电话");
    if (self.shopModel.isCallCenter == 1) {
        [self callPhoneAction];
    }else {
        NSString *phoneUrl = [NSString stringWithFormat:@"tel://%@", self.shopModel.mobile];//tel打电话 sms发信息
        //进行拨号操作（该拨号方式苹果不允许使用）
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
        //网页拨号
        //创建网页对象
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:webView];
        //利用网页对象实现拨号操作
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneUrl]]];
    }
}
- (void)callPhoneAction {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[[NSDictionary dictionary] yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Sys/requestCallPlatform" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        NSLog(@"%@", response);
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在转接中..." preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
        
    }];
    
}




- (void)shopAction:(UITapGestureRecognizer *)sender {
    OKLog(@"查看详情界面");
    ShopContentViewController *shopContentV = [[ShopContentViewController alloc] init];
    shopContentV.shopModel = self.shopModel;
    shopContentV.goodsId = self.messageModel.goodsId;
   // [self.navigationController pushViewController:shopContentV animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络请求
- (void)getDataMessage {
    RequestMyGoodsOrderDetail *detail = [[RequestMyGoodsOrderDetail alloc] init];
    detail.orderNo = self.orderNo;
    detail.goodsOrderId = self.goodsOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[detail yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyGoodsOrderDetail" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.messageModel = [RequestMyGoodsOrderDetailModel yy_modelWithJSON:baseRes.data];
             [DWHelper SD_WebImage:self.pictureImage imageUrlStr:self.messageModel.originUrl placeholderImage:nil];
            [self getHeaderData];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
    }];
}
- (void)getHeaderData {
    RequestMerchantDetail *detail = [[RequestMerchantDetail alloc] init];
    detail.merchantId = self.self.messageModel.merchantId;
    detail.lat = [AuthenticationModel getlatitude];
    detail.lng = [AuthenticationModel getlongitude];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = detail;
    
    if ([self isLogin]) {
        baseReq.token = [AuthenticationModel getLoginToken];
    }
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Home/requestMerchantDetail" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            self.shopModel = [RequestMerchantDetailModel yy_modelWithJSON:baseRes.data];
        }else {
            [self showToast:baseRes.msg];// [ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
        [self createView];
    } faild:^(id error) {
        
    }];
}

- (void)getNewMessage {
    RequestMyGoodsOrderDetail *detail = [[RequestMyGoodsOrderDetail alloc] init];
    detail.orderNo = self.orderNo;
    detail.goodsOrderId = self.goodsOrderId;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = AES;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = [AESCrypt encrypt:[detail yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Order/requestMyGoodsOrderDetail" sign:[baseReq.data MD5Hash] requestMethod:GET success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        if (baseRes.resultCode == 1) {
            RequestMyGoodsOrderDetailModel *messageModel = [RequestMyGoodsOrderDetailModel yy_modelWithJSON:baseRes.data];
            [self viewGetNewData:messageModel];
        }else {
             [self showToast:baseRes.msg];//[ProcessResultCode processResultCodeWithBaseRespone:baseRes viewControll:self];
        }
    } faild:^(id error) {
    }];

}

- (void)viewGetNewData:(RequestMyGoodsOrderDetailModel *)model {
    for (int i = 0; i < model.coupons.count; i++) {
        UIButton *useBtn = [self.view viewWithTag:2000+i];
        NSDictionary *dic = model.coupons[i];
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"0"]) {
            [useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = YES;
        }else if([status isEqualToString:@"1"]){
            [useBtn setTitle:@"已使用" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = NO;
        }else if ([status isEqualToString:@"2"]) {
            [useBtn setTitle:@"退款中" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = NO;
        }else if ([status isEqualToString:@"3"]) {
            [useBtn setTitle:@"退款完成" forState:UIControlStateNormal];
            [useBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            useBtn.userInteractionEnabled = NO;
        }

    }
    switch ([model.status intValue]) {
        case 0:
            [self.sureBtn setTitle:@"付款" forState:UIControlStateNormal];
            break;
        case 1:
            [self.sureBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            break;
        case 2:
            [self.sureBtn setTitle:@"退款中" forState:UIControlStateNormal];
            break;
        case 3:
            [self.sureBtn setTitle:@"评价" forState:UIControlStateNormal];
            break;
        case 4:
            [self.sureBtn setTitle:@"已退款" forState:UIControlStateNormal];
            break;
        case 5:
            [self.sureBtn setTitle:@"已取消" forState:UIControlStateNormal];
            break;
        case 6:
            [self.sureBtn setTitle:@"已完成" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
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
