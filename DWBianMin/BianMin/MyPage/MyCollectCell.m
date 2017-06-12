//
//  MyCollectCell.m
//  BianMin
//
//  Created by kkk on 16/7/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyCollectCell.h"

@implementation MyCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)cellGetData:(RequestMerchantListModel *)model withController:(BaseViewController *)vc {
    [vc loadImageWithView:self.pictureV urlStr:model.iconUrl];
    self.nameL.text = model.merchantName;
}

- (IBAction)collertAction:(id)sender {
    self.blockAction(nil);
}

@end
