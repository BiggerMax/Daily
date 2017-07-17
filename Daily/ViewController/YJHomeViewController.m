//
//  YJHomeViewController.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "YJHomeViewController.h"
#import "NetworkManager.h"
#import "YJResponseModel.h"
#import "YJFeedsModel.h"
#import "YJBannerModel.h"
#import "YJLoopView.h"
#import "YJHomeTableViewCell.h"
#import "YJReadViewController.h"
@interface YJHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, copy) NSArray *feedsArray;
@property (nonatomic, copy) NSArray *bannersArray;
@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, strong)YJHomeTableViewCell *cell;
@property (nonatomic, strong) YJResponseModel *reponseModel;
@property (nonatomic, strong) NetworkManager *manager;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;
@end

@implementation YJHomeViewController
{
	NSString *_last_key;
	NSString *_has_more;
	CGFloat _contentOffset_Y;
}
-(NetworkManager *)manager
{
	if (!_manager) {
		_manager = [[NetworkManager alloc] init];
		__weak typeof(self) weakSelf = self;
		[_manager newsDataBlock:^(id data) {
			__strong typeof(self) strongSelf = weakSelf;
			if (strongSelf) {
				strongSelf.reponseModel = [YJResponseModel mj_objectWithKeyValues:data];
				_last_key = strongSelf.reponseModel.last_key;
				_has_more = strongSelf.reponseModel.has_more;
				
				strongSelf.feedsArray = [YJFeedsModel mj_objectArrayWithKeyValuesArray:[data valueForKey:@"feeds"]];
				[strongSelf.dataArray addObjectsFromArray:strongSelf.feedsArray];
				
				strongSelf.bannersArray = [YJFeedsModel mj_objectArrayWithKeyValuesArray:[data valueForKey:@"banners"]];
				[strongSelf.refreshHeader endRefreshing];
				[strongSelf.refreshFooter endRefreshing];
				[strongSelf addLoopView];
				[strongSelf.mainTable reloadData];
			}
		}];
	}
	return _manager;
}
-(UITableView *)mainTable
{
	if (!_mainTable) {
		_mainTable = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
		[_mainTable registerClass:[YJHomeTableViewCell class] forCellReuseIdentifier:@"1"];
		_mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
		_mainTable.delegate = self;
		_mainTable.dataSource = self;
	}
	return _mainTable;
}
-(void)addLoopView
{
	if (!self.mainTable.tableHeaderView) {
		NSMutableArray *imageArray = [NSMutableArray new];
		NSMutableArray *titleArray = [NSMutableArray new];
		NSMutableArray *newArray = [NSMutableArray new];
		for (YJBannerModel *banner in self.bannersArray) {
			[imageArray addObject:banner.post.image];
			[titleArray addObject:banner.post.title];
			[newArray addObject:banner.post.appview];
		}
		YJLoopView *loopView = [[YJLoopView alloc] initWithImageMutableArray:imageArray titleMutableArray:titleArray];
		loopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
		loopView.newsUrlMutableArray = newArray;
		
		__weak typeof(self) weakSelf = self;
#pragma mark
		[loopView didSelectCollectionItemBlock:^(NSString *Url) {
			[weakSelf.navigationController pushViewController:[UIViewController new] animated:YES];
		}];
		self.mainTable.tableHeaderView = loopView;
	}
}
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
	self.dataArray = [[NSMutableArray alloc] init];
	self.imageArray = [[NSArray alloc] init];
	[self.manager requestHomeNewsDataWithLastKey:@"0"];
	
	//设置下拉刷新
	self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		
		[self refreshData];
	}];
	self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
	self.refreshHeader.stateLabel.hidden = YES;
	self.mainTable.mj_header = self.refreshHeader;
	
	//设置上拉加载
	self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
		[self loadData];
	}];
	[self.refreshFooter setTitle:@"加载更多 ..." forState:MJRefreshStateRefreshing];
	[self.refreshFooter setTitle:@"没有更多内容了" forState:MJRefreshStateNoMoreData];
	self.mainTable.mj_footer = self.refreshFooter;
}
-(void)loadView
{
	[super loadView];
	[self.view addSubview:self.mainTable];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
	self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)config
{
	self.dataArray = [NSMutableArray new];
	self.imageArray = [[NSArray alloc] init];
	self.feedsArray = [NSArray new];
	self.bannersArray = [NSArray new];
	
}
//下拉刷新
-(void)refreshData
{
	self.dataArray = [NSMutableArray new];
	[self.manager requestHomeNewsDataWithLastKey:@"0"];
}
/// 上拉加载数据
- (void)loadData {
	//判断是否还有更多数据
	if ([_has_more isEqualToString:@"1"]) {
		[self.manager requestHomeNewsDataWithLastKey:_last_key];
	}else if ([_has_more isEqualToString:@"0"]) {
		[self.refreshFooter setState:MJRefreshStateNoMoreData];
	}
}
-(void)setupNav
{
	[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
	
}
-(void)setupTableView
{
	//下拉刷新
	self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[self refreshData];
	}];
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateFormat = @"yyyy-MM-dd HH:mm";
	NSString *dateString = [formatter stringFromDate:date];
	//self.refreshHeader.lastUpdatedTimeText(date);
	self.refreshHeader.stateLabel.hidden = YES;
	self.mainTable.mj_header = self.refreshHeader;
	
	//设置上拉加载
	self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
		[self loadData];
	}];
	[self.refreshFooter setTitle:@"加载更多 ..." forState:MJRefreshStateRefreshing];
	[self.refreshFooter setTitle:@"没有更多内容了" forState:MJRefreshStateNoMoreData];
	self.mainTable.mj_footer = self.refreshFooter;
	[self.view addSubview:self.mainTable];
}
-(void)setupUI
{
	
}
#pragma mark --UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	YJHomeTableViewCell *cell = self.cell;
	if ([cell.cellType isEqualToString:@"0"]) {
		return 330;
	}else if ([cell.cellType isEqualToString:@"2"]){
		return 360;
	}else{
		return 130;
	}
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	YJFeedsModel *model = self.dataArray[indexPath.row];
	_cell = [tableView dequeueReusableCellWithIdentifier:model.type];
	if (!_cell) {
		_cell = [[YJHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.type];
	}
	_cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (![model.type isEqualToString:@"1"]) {
		_cell.subhead = model.post.subhead;
	}
	return _cell;

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	YJFeedsModel *feed = self.dataArray[indexPath.row];
	_cell.cellType = feed.type;
	_cell.newsImageName = feed.post.image;
	_cell.newsTitle = feed.post.title;
	_cell.newsType = feed.post.category.title;
	_cell.time = feed.post.publish_time;
	_cell.commentCount = [NSString stringWithFormat:@"%ld",(long)feed.post.comment_count];
	_cell.praiseCount = [NSString stringWithFormat:@"%ld",(long)feed.post.praise_count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	YJFeedsModel *feed = self.dataArray[indexPath.row];
	if (![feed.type isEqualToString:@"0"]) {
		YJReadViewController *readVC = [YJReadViewController new];
		readVC.newsUrl = feed.post.appview;
		[self.navigationController pushViewController:readVC animated:YES];
	}else {
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.mode = MBProgressHUDModeText;
		hud.label.text = @"加载失败";
		[hud hideAnimated:YES afterDelay:1.5];
	}
}
#pragma mark --UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	if (scrollView.contentOffset.y) {
//		<#statements#>
//	}
}
@end
