//
//  YJMenuView.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "YJMenuView.h"

#define KHeaderViewH 200

static NSString *ID = @"menuCell";
@interface YJMenuView()<UITableViewDelegate,UITableViewDataSource>
/* 模糊效果层*/
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

/** 上半部分设置按钮的父view*/
@property (nonatomic, strong) UIView *headerView;
/** 下半部分菜单按钮的父view*/
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITableView *menuTableView;
/** 新闻分类菜单界面*/
//@property (nonatomic, strong) YJNewsClassificationView *jfNewsClassificationView;

/** 菜单cell按钮图片数组*/
@property (nonatomic, strong) NSArray *imageArray;
/** 菜单cell按钮标题数组*/
@property (nonatomic, strong) NSArray *titleArray;


@end
@implementation YJMenuView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.blurEffectView];
		[self addSubview:self.headerView];
		[self addSubview:self.footerView];
		[self.footerView addSubview:self.menuTableView];
		//[self addSubview:self.jfNewsClassificationView];
		[self addHeaderViewButtonAndLabel];

	}
	return self;
}
-(UIVisualEffectView *)blurEffectView
{
	if (!_blurEffectView) {
		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		_blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		_blurEffectView.frame = self.frame;
	}
	return _blurEffectView;
}
-(UIView *)headerView
{
	if (!_headerView) {
		_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -KHeaderViewH, SCREEN_WIDTH, KHeaderViewH)];
		_headerView.backgroundColor = [UIColor clearColor];
	}
	return _headerView;
}
-(UIView *)footerView
{
	if (!_footerView) {
		_footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, SCREENH_HEIGHT-KHeaderViewH)];
		_footerView.backgroundColor = [UIColor clearColor];
	}
	return _footerView;
}
/*
 * pop动画
 */
-(void)popAnimationWithView:(UIView *)view Offset:(CGFloat)offset speed:(CGFloat)speed
{
	POPSpringAnimation *popSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
	popSpring.toValue = @(view.center.y + offset);
	popSpring.beginTime = CACurrentMediaTime();
	popSpring.springBounciness = 8.0f;
	popSpring.springSpeed = speed;
	[view pop_addAnimation:popSpring forKey:@"positionY"];
}
//弹出
-(void)popupMenuViewAnimation
{
	[self setHidden:NO];
	if (-KHeaderViewH == self.headerView.layer.frame.origin.y) {
		[self popAnimationWithView:self.headerView Offset:KHeaderViewH speed:15];
	}
	if (SCREENH_HEIGHT == self.footerView.layer.frame.origin.y) {
		[self popAnimationWithView:self.footerView Offset:-(SCREENH_HEIGHT-KHeaderViewH) speed:15];
	}
}
//隐藏
-(void)hideMenuViewAnimation
{
	[UIView animateWithDuration:0.1 animations:^{
		[self headerViewOffsetY:-KHeaderViewH];
		[self footerViewOffsetY:SCREENH_HEIGHT];
	}completion:^(BOOL finished) {
		[self setHidden:YES];
	}];
}
/// 改变headerView的Y值
- (void)headerViewOffsetY:(CGFloat)offsetY {
	CGRect headerTempFrame = self.headerView.frame;
	headerTempFrame.origin.y = offsetY;
	self.headerView.frame = headerTempFrame;
}

/// 改变footerView的Y值
- (void)footerViewOffsetY:(CGFloat)offsetY {
	CGRect footerTempFrame = self.footerView.frame;
	footerTempFrame.origin.y = offsetY;
	self.footerView.frame = footerTempFrame;
}
//弹出分类菜单
- (void)popupJFNewsClassificationViewAnimation{
//	[UIView animateWithDuration:0.5 animations:^{
//		[self menuTableViewOffsetX:SCREEN_WIDTH];
//	}completion:^(BOOL finished) {
//		POPSpringAnimation *popSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//		popSpring.toValue = 
//	}]
}
/// 改变menuTableView的X值
- (void)menuTableViewOffsetX:(CGFloat)offsetX {
	CGRect footerTempFrame = self.menuTableView.frame;
	footerTempFrame.origin.x = offsetX;
	self.menuTableView.frame = footerTempFrame;
}
-(void)addHeaderViewButtonAndLabel
{
	UILabel *sign = [UILabel new];
	sign.text = @"Daily日报";
	sign.textAlignment = NSTextAlignmentCenter;
	sign.textColor = [UIColor whiteColor];
	[self.headerView addSubview:sign];
	
	[sign mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.offset(200);
		make.height.offset(21);
		make.top.equalTo(self.headerView.mas_top).offset(KHeaderViewH * 0.2);
		make.centerX.equalTo(self.headerView.mas_centerX);
	}];
	
	NSArray *iconNameArray = @[@"setting_icon",
							   @"github_icon",
							   @"off_line_icon",
							   @"share_icon"];
	for (int i = 0; i < iconNameArray.count; i ++) {
		UIButton *headBtn = [UIButton new];
		[headBtn addTarget:self action:@selector(headerViewButtonEvents:) forControlEvents:UIControlEventTouchDown];
		headBtn.tag = i;
		NSString *imageName = iconNameArray[i];
		[headBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		[self.headerView addSubview:headBtn];
		
		[headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(38);
			make.height.offset(57);
			make.top.equalTo(self.headerView.mas_top).offset(KHeaderViewH * 0.4);
			make.right.equalTo(self.headerView.mas_left).offset(((SCREEN_WIDTH - 4 * 38) / 5 + 38) * (i + 1));
		}];

	}
}
- (void)headerViewButtonEvents:(UIButton *)sender {
	MBProgressHUD *hud = [[MBProgressHUD alloc] init];
	hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.label.text = @"后续支持";
	[hud hideAnimated:YES afterDelay:1.3];;
}
-(NSArray *)imageArray
{
	if (!_imageArray) {
		_imageArray = @[@"menu_about",
						@"menu_category",
						@"menu_column",
						@"menu_lab",
						@"menu_noti",
						@"menu_user",
						@"menu_home"];

	}
	return _imageArray;
}
-(NSArray *)titleArray
{
	if (!_titleArray) {
		_titleArray = @[@"关于我们",
						@"新闻分类",
						@"栏目中心",
						@"悄悄控件",
						@"我的消息",
						@"个人中心",
						@"首页"];

	}
	return _titleArray;
}
-(UITableView *)menuTableView
{
	if (!_menuTableView) {
		_menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 190, SCREENH_HEIGHT - KHeaderViewH - 80) style:UITableViewStylePlain];
		_menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_menuTableView.backgroundColor = [UIColor clearColor];
		_menuTableView.delegate = self;
		_menuTableView.dataSource = self;
	}
	return _menuTableView;
}
#pragma mark --- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.imageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
		cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
		cell.textLabel.text = self.titleArray[indexPath.row];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.backgroundColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (indexPath.row == 1) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
	return cell;

}
#pragma mark --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([cell.textLabel.text isEqualToString:@"新闻分类"]) {
		[self popupJFNewsClassificationViewAnimation];
//		[self.jfNewsClassificationView popupSuspensionView];
		if (self.popupNewsClassificationViewBlock) {
			self.popupNewsClassificationViewBlock();
		}
	}else {
		MBProgressHUD *hud = [[MBProgressHUD alloc] init];
		hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
		hud.mode = MBProgressHUDModeText;
		hud.label.text = @"后续支持";
		[hud hideAnimated:YES afterDelay:0.7];
	}
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (SCREENH_HEIGHT -KHeaderViewH - 80) / _imageArray.count;
}
- (void)popupNewsClassificationViewBlock:(YJMenuViewBlock)block {
	self.popupNewsClassificationViewBlock = block;
}

- (void)hideNewsClassificationViewBlock:(YJMenuViewBlock)block {
	self.hideNewsClassificationViewBlock = block;
}
@end
