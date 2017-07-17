//
//  NetworkManager.m
//  Daily
//
//  Created by 袁杰 on 2017/7/17.
//  Copyright © 2017年 BiggerMax. All rights reserved.
//

#import "NetworkManager.h"

#define kTimeOutInterval 10
@implementation NetworkManager
-(AFHTTPSessionManager *)manager
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.requestSerializer.timeoutInterval = kTimeOutInterval;
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
														 @"text/html",
														 @"image/jpeg",
														 @"image/png",
														 @"application/octet-stream",
														 @"text/json",
														 nil];
	return manager;

}
-(void)requestHomeNewsDataWithLastKey:(NSString *)lastKey
{
	AFHTTPSessionManager *manager = [self manager];
	NSString *urlString = [NSString stringWithFormat:@"http://app3.qdaily.com/app3/homes/index/%@.json?",lastKey];
	WeakSelf(self);
	[manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if (weakself.dataBlock) {
			weakself.dataBlock([dic valueForKey:@"response"]);
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"获取数据失败");
	}];
}
-(void)newsDataBlock:(YJDataManagerBlock)block
{
	self.dataBlock = block;
}
@end
