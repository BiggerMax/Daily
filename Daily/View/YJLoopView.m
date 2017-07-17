//
//  YJLoopView.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "YJLoopView.h"
#import "YJLoopViewLayout.h"
#import "YJLoopViewCell.h"
@interface YJLoopView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageMutableArray;
@property (nonatomic, strong) NSMutableArray *titleMutableArray;
@property (nonatomic, weak) NSTimer *timer;
@end
@implementation YJLoopView
static NSString *ID = @"loopViewCell";
-(instancetype)initWithImageMutableArray:(NSMutableArray *)imageMutableArray titleMutableArray:(NSMutableArray *)titleMutableArray
{
	if (self = [super init]) {
		UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[YJLoopViewLayout new]];
		[collectionView registerClass:[YJLoopViewCell class] forCellWithReuseIdentifier:ID];
		collectionView.delegate = self;
		collectionView.dataSource = self;
		[self addSubview:collectionView];
		
		self.collectionView = collectionView;
		self.imageMutableArray = imageMutableArray;
		self.titleMutableArray = titleMutableArray;
		[self addSubview:self.pageControl];
		
		dispatch_async(dispatch_get_main_queue(), ^{
//			[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageMutableArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
			[self addTimer];
		});
	}
	return self;
}
-(void)setNewsUrlMutableArray:(NSMutableArray *)newsUrlMutableArray
{
	_newsUrlMutableArray = newsUrlMutableArray;
}
-(UIPageControl *)pageControl
{
	CGFloat height = 30;
	if (!_pageControl) {
		_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 270, 0, height)];
		_pageControl.numberOfPages = self.imageMutableArray.count;
		_pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
		_pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
	}
	return _pageControl;
}
-(void)didSelectCollectionItemBlock:(YJLoopViewBlock)block
{
	self.didSelectCollectionItemBlock = block;
}
#pragma mark --UICollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.imageMutableArray.count * 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	YJLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
	cell.imageName = self.imageMutableArray[indexPath.item % self.imageMutableArray.count];
	cell.title = self.titleMutableArray[indexPath.item % self.titleMutableArray.count];
	return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.didSelectCollectionItemBlock) {
		self.didSelectCollectionItemBlock(self.newsUrlMutableArray[indexPath.row % _newsUrlMutableArray.count]);
	}
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self scrollViewDidEndDecelerating:scrollView];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat offsetX = self.collectionView.contentOffset.x;
	NSInteger page = offsetX / scrollView.bounds.size.width;
	if (page == 0) {
		page = self.imageMutableArray.count;
		self.collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0);
	}else if (page == [self.collectionView numberOfItemsInSection:0] - 1){
		page = self.imageMutableArray.count - 1;
		self.collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0);
	}
	//设置UIPageControl当前页
	NSInteger currentPage = page % self.imageMutableArray.count;
	self.pageControl.currentPage =currentPage;
	//添加定时器
	[self addTimer];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.timer invalidate];
	self.timer = nil;
}
-(void)addTimer
{
	if (self.timer) {
		return;
	}
	self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)nextImage
{
	CGFloat offsetX = self.collectionView.contentOffset.x;
	NSInteger page = offsetX / self.collectionView.frame.size.width;
	[self.collectionView setContentOffset:CGPointMake((page+1) * self.collectionView.frame.size.width, 0) animated:YES];
}
-(void)layoutSubviews
{
	[super layoutSubviews];
	self.collectionView.frame = self.bounds;
}
-(void)dealloc
{
	[self.timer invalidate];
	self.timer = nil;
}
@end
