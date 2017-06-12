//
//  WebRegistViewController.m
//  BianMin
//
//  Created by kkk on 16/9/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "WebRegistViewController.h"

@interface WebRegistViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WebRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self showBackBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUrl:(NSString *)url{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
