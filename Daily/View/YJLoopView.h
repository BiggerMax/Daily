//
//  YJLoopView.h
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJLoopViewBlock)(NSString *Url);
@interface YJLoopView : UIView
/** 点击collectionView的item跳转Block*/
@property (nonatomic, copy) YJLoopViewBlock didSelectCollectionItemBlock;

@property (nonatomic, strong) NSMutableArray *newsUrlMutableArray;

- (instancetype)initWithImageMutableArray:(NSMutableArray *)imageMutableArray
						titleMutableArray:(NSMutableArray *)titleMutableArray;

- (void)didSelectCollectionItemBlock:(YJLoopViewBlock)block;
@end
