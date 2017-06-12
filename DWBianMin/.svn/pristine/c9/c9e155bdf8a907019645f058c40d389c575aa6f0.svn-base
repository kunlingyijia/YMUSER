//
//  SearchAdressController.m
//  BianMin
//
//  Created by kkk on 16/8/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SearchAdressController.h"

@interface SearchAdressController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SearchAdressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    [self createView];
}

- (void)createView {
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, Width, 35)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.textColor = [UIColor colorWithHexString:kTitleColor];
    self.textField.placeholder = @"请输入车站名称(如福州南, 厦门北)";
    UIView *imageBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_sousuo_narmal"]];
     [imageBg addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageBg);
        make.right.equalTo(imageBg).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
   
    self.textField.leftView = imageBg;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.textField];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, Width, Height- 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"福州站";
    cell.textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
