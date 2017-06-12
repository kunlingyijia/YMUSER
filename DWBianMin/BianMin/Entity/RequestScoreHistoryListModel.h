//
//  RequestScoreHistoryListModel.h
//  BianMin
//
//  Created by kkk on 16/7/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestScoreHistoryListModel : NSObject

@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *originUrl;
@property (nonatomic, copy) NSString *middleUrl;
@property (nonatomic, copy) NSString *smallUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;

@end
