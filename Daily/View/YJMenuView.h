//
//  YJMenuView.h
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YJMenuViewBlock)();
@interface YJMenuView : UIView
/** 弹出新闻分类界面block*/
@property (nonatomic, copy) YJMenuViewBlock popupNewsClassificationViewBlock;

/** 隐藏新闻分类界面block*/
@property (nonatomic, copy) YJMenuViewBlock hideNewsClassificationViewBlock;

/// 弹出菜单界面
- (void)popupMenuViewAnimation;
/// 隐藏菜单界面
- (void)hideMenuViewAnimation;
///隐藏新闻分类菜单
- (void)hideJFNewsClassificationViewAnimation;

- (void)popupNewsClassificationViewBlock:(YJMenuViewBlock)block;

- (void)hideNewsClassificationViewBlock:(YJMenuViewBlock)block;

@end
