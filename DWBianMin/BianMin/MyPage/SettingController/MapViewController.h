//
//  MapViewController.h
//  BianMin
//
//  Created by kkk on 16/11/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface MapViewController : BaseViewController

@property (nonatomic, copy)void(^backBlock)(CLLocationCoordinate2D centerCoordinate);

@end
