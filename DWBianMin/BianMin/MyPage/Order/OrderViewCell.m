//
//  OrderViewCell.m
//  BianMin
//
//  Created by kkk on 16/5/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "OrderViewCell.h"
#define Space 5
@implementation OrderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.contentView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(15));
    }];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineV.mas_bottom).with.offset(Space);
        make.left.equalTo(self.contentView).with.offset(4*Space);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    self.isOrNotPay = [UILabel new];
    self.isOrNotPay.font = [UIFont systemFontOfSize:10];
    self.isOrNotPay.textColor = [UIColor colorWithHexString:kNavigationBgColor];
    self.isOrNotPay.text = @"未付款";
    [self.contentView addSubview:self.isOrNotPay];
    [self.isOrNotPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).with.offset(-2*Space);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    UILabel *firstLine = [UILabel new];
    firstLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.contentView addSubview:firstLine];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(Space);
        make.left.equalTo(self.contentView.mas_left).with.offset(2*Space);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(1));
    }];
    
    self.pictureView = [[UIImageView alloc] init];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFill;
    self.pictureView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.pictureView];
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine).with.offset(2*Space);
        make.left.equalTo(self.contentView).with.offset(2*Space);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    
    self.numberLabel = [UILabel new];
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.numberLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.numberLabel.text = @"数量:1";
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLine.mas_bottom).with.offset(2*Space);
        make.left.equalTo(self.pictureView.mas_right).with.offset(2*Space);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    self.onePrice = [UILabel new];
    self.onePrice.font = [UIFont systemFontOfSize:12];
    self.onePrice.text = @"总价:¥1";
    self.onePrice.textAlignment = NSTextAlignmentRight;
    self.onePrice.textColor = [UIColor redColor];
    [self.contentView addSubview:self.onePrice];
    
    
    
    self.priceLabel = [UILabel new];
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.priceLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.priceLabel.text = @"单价:¥10";
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberLabel.mas_bottom).with.offset(2*Space);
        make.left.equalTo(self.pictureView.mas_right).with.offset(2*Space);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self.onePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.right.equalTo(self.contentView.mas_right).with.offset(-2*Space);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *secondLine = [UILabel new];
    secondLine.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.contentView addSubview:secondLine];
    [secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureView.mas_bottom).with.offset(2*Space);
        make.left.equalTo(self.contentView.mas_left).with.offset(Space);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(1));
    }];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    self.dateLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.dateLabel.text = @"";
    [self.contentView addSubview:self.dateLabel];
    
    self.payOrTalkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payOrTalkBtn setTitle:@"评价" forState:UIControlStateNormal];
    [self.payOrTalkBtn addTarget:self action:@selector(talkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.payOrTalkBtn setTitleColor:[UIColor colorWithHexString:@"#fa7251"] forState:UIControlStateNormal];
    self.payOrTalkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.payOrTalkBtn];
    [self.payOrTalkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLine.mas_bottom).with.offset(Space);
        make.right.equalTo(self.contentView).with.offset(-2*Space);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    self.payOrTalkBtn.layer.borderColor = [UIColor colorWithHexString:@"#fa7251"].CGColor;
    self.payOrTalkBtn.layer.borderWidth = 1;
    self.payOrTalkBtn.layer.masksToBounds = YES;
    self.payOrTalkBtn.layer.cornerRadius = 3;
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.hidden = YES;
    [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"#fa7251"] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLine.mas_bottom).with.offset(Space);
        make.right.equalTo(self.payOrTalkBtn.mas_left).with.offset(-2*Space);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#fa7251"].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 3;
    
    
   
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payOrTalkBtn);
        make.left.equalTo(self.contentView).with.offset(2*Space);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    
}

- (void)talkAction:(UIButton *)sender {
    
    self.talkBlock(self);
}

- (void)cancelBtnAction:(UIButton *)sender {
    self.cancelAction(nil);
}

- (void)cellGetDataWithModel:(RequestMyGoodsOrderListModel *)model WithController:(BaseViewController *)vc {
    self.nameLabel.text = model.goodsName;
    self.numberLabel.text = [NSString stringWithFormat:@"数量:x%@", model.goodsNumber];
    self.priceLabel.text = [NSString stringWithFormat:@"单价:¥%.2f", model.price];
    [vc loadImageWithView:self.pictureView urlStr:model.originUrl];
    self.dateLabel.text = model.createTime;
    self.onePrice.text = [NSString stringWithFormat:@"总价:¥%.2f",model.payAmount];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
