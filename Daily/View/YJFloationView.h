//
//  YJFloationView.h
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YJFloatingButtonStyle)
{
	YJFloatingButtonQStyle = 1,
	YJFloatingButtonStyleClose,
	YJFloatingButtonStyleBackType,
	YJFloatingButtonStyleBackType2
};

typedef void(^YJFloatingViewBlock)();
@interface YJFloationView : UIView
/** 悬浮按钮，设置按钮样式（tag）*/
@property (nonatomic, assign) NSInteger YJFloatingButtonStyle;

/** 弹出菜单界面*/
@property (nonatomic, copy) YJFloatingViewBlock popupMenuBlock;

/** 关闭菜单界面*/
@property (nonatomic, copy) YJFloatingViewBlock closeMenuBlock;

/** 返回到homeNewsViewController*/
@property (nonatomic, copy) YJFloatingViewBlock backBlock;

/** 返回到JFMenuView*/
@property (nonatomic, copy) YJFloatingViewBlock backToMenuViewBlock;

- (void)popupMenuBlock:(YJFloatingViewBlock)block;

- (void)closeMenuBlock:(YJFloatingViewBlock)block;

- (void)backBlock:(YJFloatingViewBlock)block;

- (void)backToMenuViewBlock:(YJFloatingViewBlock)block;
@end
