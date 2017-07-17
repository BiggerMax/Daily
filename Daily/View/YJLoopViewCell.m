//
//  YJLoopViewCell.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "YJLoopViewCell.h"

@interface YJLoopViewCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titlelabel;
@end
@implementation YJLoopViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		UIImageView *iconView = [UIImageView new];
		[self addSubview:iconView];
		
		UILabel *titleLabel = [UILabel new];
		titleLabel.font = [UIFont systemFontOfSize:20.0f];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.numberOfLines = 0;
		[self addSubview:titleLabel];
		self.iconView = iconView;
		self.titlelabel = titleLabel;
	}
	return self;
}
-(void)setImageName:(NSString *)imageName
{
	_imageName = imageName;
	NSURL *url = [NSURL URLWithString:imageName];
	[self.iconView sd_setImageWithURL:url];
}
-(void)setTitle:(NSString *)title
{
	_title = title;
	self.titlelabel.text = title;
}
-(void)layoutSubviews
{
	[super layoutSubviews];
	self.iconView.frame = self.bounds;
	self.titlelabel.frame = CGRectMake(20, self.frame.size.height - 110, self.bounds.size.width-40, 110);
}
@end
