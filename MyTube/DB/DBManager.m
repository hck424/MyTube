//
//  DBManager.m
//  MyTube
//
//  Created by 김학철 on 2020/05/19.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "DBManager.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"
#import "AppDelegate.h"

#define YOUTUBE_PREFIX_URL @"https://www.googleapis.com/youtube/v3"
@interface DBManager ()
@property (nonatomic, strong) AFHTTPSessionManager *ytManager;
@end

@implementation DBManager
@synthesize ytManager = ytManager;
+ (DBManager *)instance {
    static DBManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.allowsCellularAccess = YES;
        config.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
        config.HTTPShouldSetCookies = YES;
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.timeoutIntervalForResource = 40.0;
        //서버에서 10초로 끊으니 클라이언트는 걍 바꾸지 말자.
        self.ytManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:YOUTUBE_PREFIX_URL] sessionConfiguration:config];
        [ytManager.requestSerializer setTimeoutInterval:120];
        ytManager.requestSerializer = [AFJSONRequestSerializer serializer];
        ytManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)GET:(NSString *)url
    success:(void (^)(id data))success
    failure:(void (^)(NSError *error))failure {
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[AppDelegate instace] startIndicator];
    
    [ytManager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate instace] stopIndicator];
            if (success) {
                success(responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate instace] stopIndicator];
            failure(error);
        });
    }];
}

- (void)syncGET:(NSString*)url
        success:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure {
    
}

- (void)PUT:(NSString*)url
      param:(NSDictionary*)param
    success:(void (^)(id data))success
    failure:(void (^)(NSError *error))failure {
    
}

- (void)DELETE:(NSString*)url
         param:(NSDictionary*)param
       success:(void (^)(id data))success
       failure:(void (^)(NSError *error))failure {
    
}

- (void)POST:(NSString*)url
       param:(NSDictionary*)param
     success:(void (^)(id data))success
     failure:(void (^)(NSError *error))failure {
}


@end
