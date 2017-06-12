//
//  FourShopCell.m
//  BianMin
//
//  Created by kkk on 16/5/5.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "FourShopCell.h"
#import "CWStarRateView.h"
#import "Masonry.h"
@implementation FourShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createView];
    }
    return self;
}

- (void)createView {
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    self.photoImage.backgroundColor = [UIColor purpleColor];
//    self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImage.userInteractionEnabled = YES;
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 15;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
    [self.photoImage addGestureRecognizer:tap];
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/crop.927.180.853.853.1024/006eDhv2gw1ewkqfcoylsj31kw11s1ao.jpg"]];
    [self.contentView addSubview:self.photoImage];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImage.frame)+10, 5, Bounds.size.width-10, 10)];
    self.userName.text = @"X战警:天启";
    self.userName.textColor = [UIColor colorWithHexString:kTitleColor];
    self.userName.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.userName];
    
    self.starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImage.frame)+10, CGRectGetMaxY(self.userName.frame)+5, 50, 15) ];
    [self.starView setNumberOfStarts:5];
    self.starView.userInteractionEnabled = NO;
    self.starNum = 0.5;
    self.starView.scorePercent = self.starNum;
    self.starView.hasAnimation = NO;
    [self.contentView addSubview:self.starView];
    
    
    self.pictureArrView = [UIView new];
    [self.contentView addSubview:self.pictureArrView];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.text = @"";
    self.contentLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.starView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
 
}

- (void)cellGetDataWith:(RequestMerchantCommentListModel *)talkModel withController:(BaseViewController *)vc{
    [vc loadImageWithView:self.photoImage urlStr:talkModel.avatarUrl];
    self.userName.text = talkModel.userName;
    [self.starView setScorePercent:[talkModel.star floatValue]*0.2];
    self.contentLabel.text = talkModel.content;
}


- (void)imageAction:(UITapGestureRecognizer *)sender {
//    self.goMyCenterBlock(@"进入主页");
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
