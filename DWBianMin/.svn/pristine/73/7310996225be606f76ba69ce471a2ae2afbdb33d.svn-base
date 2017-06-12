//
//  SearchBarView.h
//  jdmobile
//
//  Created by matrix on 15/6/13.
//  Copyright (c) 2015年 SYETC02. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchBarViewDelegate;

@interface DWSearchBarView : UIView


@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, weak) id <SearchBarViewDelegate> delegate;
@property (nonatomic, strong)UIButton *adressBtn;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIImageView *img;
@end

@protocol SearchBarViewDelegate <NSObject>

@optional

- (void)searchBarAudioButtonClicked:(DWSearchBarView *)searchBarView;
- (void)searchBarSearchButtonClicked:(DWSearchBarView *)searchBarView;
- (void)adressSelected:(id)sender;
@end

@interface RoundedView : UIView
@end