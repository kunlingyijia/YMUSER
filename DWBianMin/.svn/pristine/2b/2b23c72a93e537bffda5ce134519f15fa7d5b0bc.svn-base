//
//  CenterCell.m
//  BianMin
//
//  Created by kkk on 16/5/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CenterCell.h"
#define Space 5
#define pictureW (Bounds.size.width - Space * 5)/4
@interface CenterCell()
@property (nonatomic, strong) UIView *pictureView;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@end

@implementation CenterCell

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        self.imagesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesArray;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    UIImageView *pictureV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_my_zhuye_dianpu"]];
    [self.contentView addSubview:pictureV];
    [pictureV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(2*Space);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.text = @"满记甜点";
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pictureV);
        make.left.equalTo(pictureV.mas_right).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(Space);
        make.left.equalTo(self.contentView).with.offset(2*Space);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(1));
    }];
    
    
    self.pictureView = [UIView new];
    [self.contentView addSubview:self.pictureView];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.text = @"一顿好吃好喝，个人认为茶点类口味和样式都不输潮福城，而且位置空间宽敞舒适，这比潮福城强太多了，更好的是抽烟和非抽烟区还分开，可以干干净净的吃喝，不受二手烟的气，点赞点一百个赞，这是一个有文化有素质的老板开的店吧！总体感觉都很好。推荐强烈推荐凯逸轩，我一定会回来的。";
    self.contentLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(self.pictureView.mas_top);
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@(pictureW + Space));
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-6*Space);
    }];
    
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *btn = [UIImageView new];
        btn.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        btn.tag = 1000+i;
        btn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnImageAction:)];
        btn.backgroundColor = [UIColor redColor];
        [btn addGestureRecognizer:tap];
        [self.imagesArray addObject:btn];
        //        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(Space + i * (pictureW + Space), Space/2, pictureW, pictureW);
        [self.pictureView addSubview:btn];
        
    }
    
    self.timeLabel = [UILabel new];
    self.timeLabel.text = @"2016-04-27";
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureView.mas_bottom).with.offset(Space);
        make.left.equalTo(self.contentView).with.offset(2*Space);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    self.talkNumLabel = [UILabel new];
    self.talkNumLabel.text = @"1305人读过";
    self.talkNumLabel.font = [UIFont systemFontOfSize:10];
    self.talkNumLabel.textColor = [UIColor colorWithHexString:kSubTitleColor];
    [self.contentView addSubview:self.talkNumLabel];
    [self.talkNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureView.mas_bottom).with.offset(Space);
        make.left.equalTo(self.timeLabel.mas_right).with.offset(Space);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
}

- (void)btnImageAction:(UITapGestureRecognizer *)sender {
    
}


- (void)cellgetImage:(NSArray *)array {
    for (int i = 0; i < array.count; i++) {
        if (i < 4) {
            UIImageView *image = self.imagesArray[i];
            [image sd_setImageWithURL:[NSURL URLWithString:array[i]]];
        }else {
            break;
        }
    }
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
