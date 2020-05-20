//
//  DBManager.h
//  MyTube
//
//  Created by 김학철 on 2020/05/19.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DBManager : NSObject
+ (DBManager *)instance;

- (void)GET:(NSString*)url
    success:(void (^)(id data))success
    failure:(void (^)(NSError *error))failure;

- (void)syncGET:(NSString*)url
        success:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure;

- (void)PUT:(NSString*)url
      param:(NSDictionary*)param
    success:(void (^)(id data))success
    failure:(void (^)(NSError *error))failure;

- (void)DELETE:(NSString*)url
         param:(NSDictionary*)param
       success:(void (^)(id data))success
       failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString*)url
       param:(NSDictionary*)param
     success:(void (^)(id data))success
     failure:(void (^)(NSError *error))failure;

@end

