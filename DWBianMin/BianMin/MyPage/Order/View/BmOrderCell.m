//
//  BmOrderCell.m
//  BianMin
//
//  Created by kkk on 16/8/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BmOrderCell.h"
#import "RequestBminserviceListModel.h"
@interface BmOrderCell ()
@property (nonatomic, strong) RequestMyBminorderListModel *model;
@end

@implementation BmOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellGetDataWithModel:(RequestMyBminorderListModel *)model {
    self.model = model;
    [self.shopLogo sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.shopName.text = model.merchantName;
    NSString *bmContent = nil;

    for (int i = 0; i < model.bminServiceList.count; i++) {
        RequestBminserviceListModel *dic = [RequestBminserviceListModel yy_modelWithJSON:model.bminServiceList[i]];
        if (i == 0) {
            bmContent = [NSString stringWithFormat:@"%@",  dic.serviceName];
        }else {
             bmContent = [NSString stringWithFormat:@"%@+%@", bmContent, dic.serviceName];
        }
    }
    self.shopContent.text = bmContent;
    self.firstBtn.hidden = NO;
    self.secondBtn.hidden = NO;
    if (model.status == 2) {
        [self.firstBtn setTitle:@"支付" forState:UIControlStateNormal];
        self.secondBtn.hidden = YES;
    }else if (model.status == 3) {
        [self.firstBtn setTitle:@"已完成" forState:UIControlStateNormal];
        self.firstBtn.hidden = YES;
        self.secondBtn.hidden = YES;
    }else {
        [self.firstBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.secondBtn.hidden = NO;
    }
    
    switch (model.status) {
        case 0:
            self.orderStatus.text = @"未接单";
            break;
        case 1:
            self.orderStatus.text = @"已接单";
            [self.firstBtn setTitle:@"催单" forState:UIControlStateNormal];
            self.secondBtn.hidden = YES;
            break;
        case 2:
            self.orderStatus.text = @"待支付";
            break;
        case 3:
            self.orderStatus.text = @"已完成";
            self.firstBtn.hidden = YES;
            self.secondBtn.hidden = YES;
            break;
        case 4:
            self.orderStatus.text = @"订单已取消";
            self.firstBtn.hidden = YES;
            self.secondBtn.hidden = YES;
            break;
        case 5:
            self.orderStatus.text = @"商家拒单";
            self.firstBtn.hidden = YES;
            self.secondBtn.hidden = YES;
            break;
        default:
            break;
    }
    
}
- (IBAction)cancelOrderAction:(id)sender{
    UIButton *btn = sender;
    self.cancelOrderBlock(self.model.orderNo, btn.titleLabel.text,self.model.bminOrderId);
}

- (IBAction)upOrderAction:(id)sender {
    self.secondBtnAction(self.model.orderNo,self.model.bminOrderId);
}

@end
