//
//  ThirdShopCell.m
//  BianMin
//
//  Created by kkk on 16/4/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ThirdShopCell.h"
#import "CWStarRateView.h"
#import "SDPhotoBrowser.h"
#define pictureW (Bounds.size.width - Space * 5)/4
#define Space 10

@interface ThirdShopCell()<SDPhotoBrowserDelegate>

@property (nonatomic, strong)UIImageView *showImage;
@property (nonatomic, strong) SDPhotoBrowser *photoBrowser;
@property (nonatomic, strong) UIButton *lookMoreImage;

@end

@implementation ThirdShopCell

- (NSMutableArray *)pictureArray {
    if (!_pictureArray) {
        self.pictureArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _pictureArray;
}

- (NSMutableArray *)imagesBtn {
    if (!_imagesBtn) {
        self.imagesBtn = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesBtn;
}

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
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/crop.927.180.853.853.1024/006eDhv2gw1ewkqfcoylsj31kw11s1ao.jpg"]];
    self.photoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myCenterAction:)];
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 15;
    [self.photoImage addGestureRecognizer:tap];
    [self.contentView addSubview:self.photoImage];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImage.frame)+10, 5, Bounds.size.width-10, 10)];
    self.userName.text = @"X战警:天启";
    self.userName.textColor = [UIColor colorWithHexString:kTitleColor];
    self.userName.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.userName];
    
    self.starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImage.frame)+10, CGRectGetMaxY(self.userName.frame)+5, 50, 15) ];
    self.starView.userInteractionEnabled = NO;
    [self.starView setNumberOfStarts:5];
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
        make.bottom.mas_equalTo(self.pictureArrView.mas_top);
    }];
    
//    self.pictureArrView.backgroundColor = [UIColor greenColor];
    [self.pictureArrView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo(@(pictureW + Space + 10));
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
    
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *btn = [UIImageView new];
        btn.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        btn.tag = 1000+i;
        btn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnImageAction:)];
        [btn addGestureRecognizer:tap];
//        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imagesBtn addObject:btn];
        btn.frame = CGRectMake(Space + i * (pictureW + Space), Space/2, pictureW, pictureW);
        [self.pictureArrView addSubview:btn];
        
    }
    
    
    self.lookMoreImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lookMoreImage setTitle:@"显示所有图片" forState:UIControlStateNormal];
    [self.lookMoreImage setTitleColor:[UIColor colorWithHexString:kNavigationBgColor] forState:UIControlStateNormal];
    [self.lookMoreImage addTarget:self action:@selector(lookMoreImage:) forControlEvents:UIControlEventTouchUpInside];
    self.lookMoreImage.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.lookMoreImage];
    [self.lookMoreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    //用来展示数组的图片(中介)
    self.showImage = [UIImageView new];
    self.showImage.frame = CGRectMake(-10, -10, 1, 1);
   [self.pictureArrView addSubview:self.showImage];
    
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.backgroundColor = [UIColor redColor];
//    [self.pictureArrView addSubview:btn1];
//    
//    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.pictureArrView.mas_top).with.offset(10);
//        make.left.equalTo(self.pictureArrView.mas_left).with.offset(10);
//        make.width.equalTo(self.pictureArrView.mas_height).with.offset(-20);
//        make.height.equalTo(self.pictureArrView.mas_height).with.offset(-20);
//        
//    }];
    
}



- (void)myCenterAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(touchPhotoImage:)]) {
        [self.delegate touchPhotoImage:nil];
    }
}


- (void)talkImageData:(NSMutableArray *)images {
    for (UIImageView *view in self.imagesBtn) {
        view.hidden = YES;
    }
    
    if (self.pictureArray.count < 5) {
        self.lookMoreImage.hidden = YES;
    }else {
        self.lookMoreImage.hidden = NO;
    }
    for (int i = 0; i < self.pictureArray.count; i++) {
        if (i < 4) {
            NSDictionary *dic = self.pictureArray[i];
            UIImageView *btn = [self.imagesBtn objectAtIndex:i];
            [btn sd_setImageWithURL:[NSURL URLWithString:dic[@"originUrl"]]];
            btn.hidden = NO;
        }else {
            break;
        }
    }
}


- (void)btnImageAction:(UITapGestureRecognizer *)sender {
//    if ([self.delegate respondsToSelector:@selector(touchImage:)]) {
//        [self.delegate touchImage:self];
//    }
    
    self.photoBrowser = [SDPhotoBrowser new];
    self.photoBrowser.delegate = self;
    
    self.photoBrowser.currentImageIndex = sender.view.tag - 1000;
    self.photoBrowser.imageCount = self.pictureArray.count;
    self.photoBrowser.sourceImagesContainerView = self.pictureArrView;
    
    [self.photoBrowser show];
}

- (void)lookMoreImage:(UIButton *)sender {
    self.photoBrowser = [SDPhotoBrowser new];
    self.photoBrowser.delegate = self;
    
    self.photoBrowser.currentImageIndex = 4;
    self.photoBrowser.imageCount = self.pictureArray.count;
    self.photoBrowser.sourceImagesContainerView = self.pictureArrView;
    
    [self.photoBrowser show];
}


#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSDictionary *dic = self.pictureArray[index];
    [self.showImage sd_setImageWithURL:[NSURL URLWithString:dic[@"originUrl"]]];
    return self.showImage.image;
    
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
   
    return self.pictureArray[index];
}

- (void)cellGetDataWith:(RequestMerchantCommentListModel *)talkModel withController:(BaseViewController *)vc{
    [vc loadImageWithView:self.photoImage urlStr:talkModel.avatarUrl];
    self.userName.text = talkModel.userName;
    [self.starView setScorePercent:[talkModel.star floatValue]*0.2];
    self.contentLabel.text = talkModel.content;
}

@end
