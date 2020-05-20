//
//  RequestManager.h
//  MyTube
//
//  Created by 김학철 on 2020/05/19.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchHistory+CoreDataProperties.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^RES_SUCCESS_DIC)(NSDictionary *result);
typedef void(^RES_SUCCESS_ARR)(NSArray *result);
typedef void(^RES_SUCCESS_VOID)(void);
typedef void(^RES_FAILURE)(NSError *error);

@interface RequestManager : NSObject
+ (RequestManager *)instance;

//Local DB Query
- (void)requestSerchList:(NSString *)search success:(RES_SUCCESS_DIC)success failure:(RES_FAILURE)failure;
- (void)insertSearchKeyWord:(NSString *)serachWord success:(RES_SUCCESS_VOID)success failure:(RES_FAILURE)failure;
- (void)deleteSearchHistory:(SearchHistory *)search success:(RES_SUCCESS_VOID)success failure:(RES_FAILURE)failure;

//Youtube Search Query
- (void)fetchAllSearchHistory:(RES_SUCCESS_ARR)success failure:(RES_FAILURE)failure;
@end

NS_ASSUME_NONNULL_END