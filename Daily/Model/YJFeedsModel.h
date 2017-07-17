//
//  YJFeedsModel.h
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YJPostModel;
@interface YJFeedsModel : NSObject
/** 文章类型（以此来判断cell（文章显示）的样式）*/
@property (nonatomic, copy) NSString *type;

/** 文章配图 */
@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) YJPostModel *post;
@end
