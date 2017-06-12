//
//  MyCollectCell.h
//  BianMin
//
//  Created by kkk on 16/7/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestMerchantListModel.h"
@interface MyCollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (nonatomic, copy)void(^blockAction)(NSString *str);

- (void)cellGetData:(RequestMerchantListModel *)model withController:(BaseViewController *)vc;

@end
