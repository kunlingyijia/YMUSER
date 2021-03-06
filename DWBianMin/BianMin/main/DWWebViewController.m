//
//  DWWebViewController.m
//  BianMin
//
//  Created by z on 16/5/4.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWWebViewController.h"

@interface DWWebViewController()
@property (nonatomic, strong) UIWebView *webView;
@end
@implementation DWWebViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self showBackBtn];
}
- (void)setUrl:(NSString *)url{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

@end
