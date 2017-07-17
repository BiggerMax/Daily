//
//  YJPostModel.h
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YJCategoryModel;

@interface YJPostModel : NSObject
/** 新闻标题*/
@property (nonatomic, copy) NSString *title;
/** 副标题*/
@property (nonatomic, copy) NSString *subhead;
/** 出版时间*/
@property (nonatomic, assign) NSInteger publish_time;
/** 配图*/
@property (nonatomic, copy) NSString *image;
/** 评论数*/
@property (nonatomic, assign) NSInteger comment_count;
/** 点赞数*/
@property (nonatomic, assign) NSInteger praise_count;
/** 新闻文章链接（html格式）*/
@property (nonatomic, copy) NSString *appview;
@property(nonatomic,strong)YJCategoryModel *category;
@end
