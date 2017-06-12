//
//  SearchResultController.m
//  BianMin
//
//  Created by kkk on 16/8/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SearchResultController.h"
#import "GoingOutSearchListCell.h"
#import "RequestTripListModel.h"
#import "ReservationController.h"
@interface SearchResultController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"搜索列表";
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 77;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoingOutSearchListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GoingOutSearchListCell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBg];
    [self.view addSubview:self.tableView];
    if (self.dataSource.count == 0) {
        [self showToast:@"无此车次"];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReservationController *reserva = [[ReservationController alloc] initWithNibName:@"ReservationController" bundle:nil];
    RequestTripListModel *model = self.dataSource[indexPath.row];
    reserva.tripId = model.tripId;
    [self.navigationController pushViewController:reserva animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoingOutSearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoingOutSearchListCell" forIndexPath:indexPath];
    RequestTripListModel *model = self.dataSource[indexPath.row];
    [cell cellGetDataWithModel:model];
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
