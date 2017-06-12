//
//  IntegralViewCell.m
//  BianMin
//
//  Created by kkk on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IntegralViewCell.h"
#import "RequestScoreGoodsListModel.h"
#define LabelHight 15
#define CellFrame self.contentView.frame
@implementation IntegralViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createView {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, Bounds.size.width/2-10, LabelHight)];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.text = @"三眼陶瓷表";
    
    self.subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameLabel.frame), Bounds.size.width/2-10, LabelHight)];
    [self.contentView addSubview:self.subNameLabel];
    self.subNameLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.subNameLabel.text = @"5积分限时抢购";
    self.subNameLabel.font = [UIFont systemFontOfSize:10];
    
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.subNameLabel.frame),(CellFrame.size.height - 2*LabelHight-10)*3/2, CellFrame.size.height - 2*LabelHight-10)];
    [self.contentView addSubview:self.photoImage];
    self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *priceImage = [UIImageView new];
//    priceImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:priceImage];
    
    self.priceLabel = [UILabel new];
    self.priceLabel.text = @"";
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.priceLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-5);
        make.left.mas_equalTo(self.photoImage.mas_right).with.offset(5);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(15));
    }];
    
    
    [priceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.priceLabel.mas_left);
        make.bottom.mas_equalTo(self.priceLabel.mas_bottom);
        make.width.height.mas_equalTo(@(15));
    }];
    
    
}

- (void)cellGetDataModel:(RequestScoreGoodsListModel *)model withController:(BaseViewController *)vc{
    self.nameLabel.text = model.goodsName;
    self.subNameLabel.text = [NSString stringWithFormat:@"%ld积分限时兑换", (long)model.score];
    [vc loadImageWithView:self.photoImage urlStr:model.originUrl];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元", model.price];
    
}



@end
