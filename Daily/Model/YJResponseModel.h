//
//  YJResponseModel.h
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YJFeedsModel;
@interface YJResponseModel : NSObject
/** 下拉加载时判断是否还有更多文章 false：没有 true：有*/
@property (nonatomic, copy) NSString *has_more;

/** 下拉加载时需要拼接到URL中的key*/
@property (nonatomic, copy) NSString *last_key;
@property (nonatomic, strong) YJFeedsModel *feeds;
@end
