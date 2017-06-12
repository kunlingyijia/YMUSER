//
//  MyCenterViewController.m
//  BianMin
//
//  Created by kkk on 16/5/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyCenterViewController.h"
#import "CenterCell.h"
#define CellHeight 76 + (Bounds.size.width - 5 * 5)/4
@interface MyCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"个人主页";
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:Bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CenterCell class] forCellReuseIdentifier:@"centerCell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    [self createHeaderView];
}

- (void)createHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Width*2/5)];
    UIImageView *pictureV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"def_my_zhuye_banner"]];
    pictureV.frame = CGRectMake(0, 0, Width, Width*2/5);
    [headerView addSubview:pictureV];
    
    UIImageView *photoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"def_my_zhuye_touxiang"]];
    [headerView addSubview:photoImage];
    [photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).with.offset(10);
        make.centerX.equalTo(headerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"索隆";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoImage.mas_bottom).with.offset(10);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UILabel *talkLabel = [UILabel new];
    talkLabel.text = @"100评价";
    talkLabel.font = [UIFont systemFontOfSize:12];
    talkLabel.textColor = [UIColor whiteColor];
    talkLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:talkLabel];
    [talkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight + 100;//cell的高度加上  评论文字的高度
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell cellgetImage:[FakeData getTalkPictureData]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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