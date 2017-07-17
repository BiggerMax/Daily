//
//  YJLoopViewLayout.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "YJLoopViewLayout.h"

@implementation YJLoopViewLayout

-(void)prepareLayout
{
	[super prepareLayout];
	self.itemSize = self.collectionView.frame.size;
	self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	//设置分页
	self.collectionView.pagingEnabled = YES;
	
	//设置最小间距
	self.minimumLineSpacing = 0;
	self.minimumInteritemSpacing = 0;
	
	//隐藏水平滚动条
	self.collectionView.showsHorizontalScrollIndicator = NO;

}
@end
