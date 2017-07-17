//
//  NetworkManager.h
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YJDataManagerBlock)(id data);
@interface NetworkManager : NSObject

@property (nonatomic,copy) YJDataManagerBlock dataBlock;

/**
 请求新闻数据
 
 @param lastKey 加载新数据的key
 */
- (void)requestHomeNewsDataWithLastKey:(NSString *)lastKey;

- (void)newsDataBlock:(YJDataManagerBlock)block;
@end
