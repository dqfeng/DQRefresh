//
//  ViewController.m
//  DQRefresh
//
//  Created by dqfeng   on 15/3/10.
//  Copyright (c) 2015年 dqfeng. All rights reserved.
//

#import "RefreshViewController.h"
#import "UIScrollView+DQRefresh.h"

@interface RefreshViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIBarButtonItem *  rightBarButtonItem;

@end

@implementation RefreshViewController

#pragma mark- view live cycle
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.dqRefreshHeader begainRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"下拉刷新";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    [self addViews];
}

#pragma mark setup views
- (void)addViews
{
    [self.view addSubview:self.tableView];
    [self layoutViews];
}

- (void)layoutViews
{
    self.tableView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 64);
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  iden];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

#pragma mark- action
- (void)refreshButton:(UIBarButtonItem *)sender
{
    [self.tableView.dqRefreshHeader begainRefreshing];
}

- (void)topRefresh:(DQRefresh *)refresh
{
    NSLog(@"toRefreshing");
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView.dqRefreshHeader endRefreshing];
    });
}

- (void)bottomRefresh:(DQRefresh *)refresh
{
    NSLog(@"bottomRefreshing");
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView.dqRefreshFooter endRefreshingWithMoreData:NO];
    });
}

#pragma mark- getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        [_tableView addDQRefreshHeaderWithTarget:self action:@selector(topRefresh:)];
        [_tableView addDQRefreshFooterWithTarget:self action:@selector(bottomRefresh:)];
        [_tableView.dqRefreshHeader setTitle:@"下拉刷新" forRefreshState:DQRefreshStateNormal];
    }
    return _tableView;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButton:)];
    }
    return _rightBarButtonItem;
}

@end
