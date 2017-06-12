//
//  WebLoginController.m
//  BianMin
//
//  Created by kkk on 16/9/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "WebLoginController.h"
#import "WebRegistViewController.h"
@interface WebLoginController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WebLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"登录";
    [self navogationAction];
}

- (void)navogationAction {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)registAction:(UIButton *)sender {
    WebRegistViewController *webRegist = [[WebRegistViewController alloc] init];
    [webRegist setUrl:self.registUrl];
    [self.navigationController pushViewController:webRegist animated:YES];
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
