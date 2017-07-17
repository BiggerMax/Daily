//
//  YJHomeTableViewCell.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "YJHomeTableViewCell.h"

@interface YJHomeTableViewCell()

@property (nonatomic, strong) UIView *cellSeparator;
@property (nonatomic, strong) UIImageView *newsImageView;
@property (nonatomic, strong) UILabel *newsTitleLabel;
@property (nonatomic, strong) UILabel *subheadLabel;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *praiseImageView;
@property (nonatomic, strong) UILabel *newsTypeLabel;
@property (nonatomic, strong) UILabel *commentlabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end
@implementation YJHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		UIImageView *newsImageView = [[UIImageView alloc] init];
		[self addSubview:newsImageView];
		
		UILabel *newsTitleLabel = [[UILabel alloc] init];
		newsTitleLabel.textColor = JFRGBAColor(42, 42, 42, 0.99);
		newsTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
		newsTitleLabel.numberOfLines = 5;
		[self addSubview:newsTitleLabel];
		
		UILabel *subheadLabel = [[UILabel alloc] init];
		subheadLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
		subheadLabel.textColor = [UIColor grayColor];
		subheadLabel.numberOfLines = 3;
		[self addSubview:subheadLabel];
		
		UILabel *newsTypeLabel = [[UILabel alloc] init];
		newsTypeLabel.font = [UIFont systemFontOfSize:12.0];
		newsTypeLabel.textColor = [UIColor grayColor];
		[self addSubview:newsTypeLabel];
		
		UILabel *commentLabel = [[UILabel alloc] init];
		commentLabel.textAlignment = NSTextAlignmentCenter;
		commentLabel.font = [UIFont systemFontOfSize:13.0];
		commentLabel.textColor = [UIColor grayColor];
		[self addSubview:commentLabel];
		
		UILabel *praiseLabel = [[UILabel alloc] init];
		praiseLabel.textAlignment = NSTextAlignmentCenter;
		praiseLabel.font = [UIFont systemFontOfSize:13.0];
		praiseLabel.textColor = [UIColor grayColor];
		[self addSubview:praiseLabel];
		
		UILabel *timeLabel = [[UILabel alloc] init];
		timeLabel.textAlignment = NSTextAlignmentCenter;
		timeLabel.font = [UIFont systemFontOfSize:13.0];
		timeLabel.textColor = [UIColor grayColor];
		[self addSubview:timeLabel];
		
		UIView *cellSeparator = [[UIView alloc] init];
		cellSeparator.backgroundColor = JFRGBAColor(238, 238, 238, 1);
		[self addSubview:cellSeparator];
		
		UIImageView *commentImageView = [[UIImageView alloc] init];
		commentImageView.image = [UIImage imageNamed:@"feedComment"];
		[self addSubview:commentImageView];
		
		UIImageView *praiseImageView = [[UIImageView alloc] init];
		praiseImageView.image = [UIImage imageNamed:@"feedPraise"];
		[self addSubview:praiseImageView];
		
		self.newsImageView = newsImageView;
		self.newsTitleLabel = newsTitleLabel;
		self.newsTypeLabel = newsTypeLabel;
		self.commentlabel = commentLabel;
		self.praiseLabel = praiseLabel;
		self.timeLabel = timeLabel;
		self.cellSeparator = cellSeparator;
		self.commentImageView = commentImageView;
		self.praiseImageView = praiseImageView;
		self.subheadLabel = subheadLabel;

	}
	return self;
}
- (void)setCellType:(NSString *)cellType {
	_cellType = cellType;
}

- (void)setSubhead:(NSString *)subhead {
	_subhead = subhead;
	self.subheadLabel.text = subhead;
}
-(void)setNewsImageName:(NSString *)newsImageName
{
	_newsImageName = newsImageName;
	NSURL *imageUrl = [NSURL URLWithString:newsImageName];
	[self.newsImageView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
		if (cacheType == SDImageCacheTypeDisk) {
			return ;
		}else{
			self.newsImageView.alpha = 0.0;
			[UIView transitionWithView:self.newsImageView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				self.newsImageView.alpha = 1.0f;
			} completion:nil];
		}
	}];
}
- (void)setNewsTitle:(NSString *)newsTitle {
	_newsTitle = newsTitle;
	self.newsTitleLabel.text = newsTitle;
}

- (void)setNewsType:(NSString *)newsType {
	_newsType = newsType;
	self.newsTypeLabel.text = newsType;
}

- (void)setCommentCount:(NSString *)commentCount {
	_commentCount = commentCount;
	self.commentlabel.text = commentCount;
}

- (void)setPraiseCount:(NSString *)praiseCount {
	_praiseCount = praiseCount;
	self.praiseLabel.text = praiseCount;
}
- (void)setTime:(NSInteger)time {
	_time = time;
	//时间转换有问题
	//    NSString *timeString = [NSString getShowDateWithTime:[NSString stringWithFormat:@"%lu",time]];
	//    self.timeLabel.text = timeString;
}
-(void)layoutSubviews
{
	[super layoutSubviews];
	[self.cellSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.offset(SCREEN_WIDTH);
		make.height.offset(5);
		make.left.equalTo(self.mas_left);
		make.top.equalTo(self.mas_top);
	}];
	
	if ([_cellType isEqualToString:@"1"]) {
		[self.newsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset((SCREEN_WIDTH / 2) - 40);
			make.height.offset(80);
			make.top.equalTo(self.mas_top).offset(20);
			make.left.equalTo(self.mas_left).offset(20);
		}];
		
		[self.newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(SCREEN_WIDTH / 2);
			make.height.offset(125);
			make.top.equalTo(self.mas_top).offset(5);
			make.right.equalTo(self.mas_right).offset(-1);
		}];
	}
	
	if (![_cellType isEqualToString:@"0"]) {
		[self.newsTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(30);
			make.height.offset(21);
			make.left.equalTo(self.newsTitleLabel.mas_left);
			make.bottom.equalTo(self.mas_bottom).offset(-3);
		}];
		
		[self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(12.5);
			make.height.offset(11.5);
			make.left.equalTo(self.newsTypeLabel.mas_right).offset(3);
			make.centerY.equalTo(self.newsTypeLabel.mas_centerY);
		}];
		
		[self.commentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(30);
			make.height.offset(21);
			make.left.equalTo(self.commentImageView.mas_right).offset(0);
			make.centerY.equalTo(self.newsTypeLabel.mas_centerY);
		}];
		
		[self.praiseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(13);
			make.height.offset(11.5);
			make.left.equalTo(self.commentlabel.mas_right).offset(3);
			make.centerY.equalTo(self.newsTypeLabel.mas_centerY);
		}];
		
		[self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(30);
			make.height.offset(21);
			make.left.equalTo(self.praiseImageView.mas_right).offset(0);
			make.centerY.equalTo(self.newsTypeLabel.mas_centerY);
		}];
		
		[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.offset(40);
			make.height.offset(21);
			make.left.equalTo(self.praiseLabel.mas_right).offset(0);
			make.centerY.equalTo(self.newsTypeLabel.mas_centerY);
		}];
	}
	
	if (![_cellType isEqualToString:@"1"]) {
		self.newsImageView.frame = CGRectMake(0, 5, SCREEN_WIDTH, 220);
		self.newsTitleLabel.frame = CGRectMake(20, 230, SCREEN_WIDTH - 40, 60);
		self.subheadLabel.frame = CGRectMake(20, 290, SCREEN_WIDTH - 40, 40);
	}

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
