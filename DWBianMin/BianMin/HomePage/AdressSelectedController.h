//
//  AdressSelectedController.h
//  BianMin
//
//  Created by kkk on 16/4/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface AdressSelectedController : BaseViewController

@property (nonatomic , copy)void(^selectdeAdress)(NSString *);
///第一次
@property (nonatomic, strong) NSString  *isFrest;





@end
