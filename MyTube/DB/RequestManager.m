//
//  RequestManager.m
//  MyTube
//
//  Created by 김학철 on 2020/05/19.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "RequestManager.h"
#import "DBManager.h"
#import "AFURLSessionManager.h"
#import "AppDelegate.h"


#define EntityNameSearch @"SearchHistory"
@interface RequestManager ()
@property (nonatomic, strong) NSManagedObjectContext *viewContext;
@end
@implementation RequestManager
+ (RequestManager *)instance {
    static RequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RequestManager alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (self = [super init]) {
        self.viewContext = [AppDelegate instace].persistentContainer.viewContext;
    }
    return self;
}
//Local DB 히스토리
- (void)fetchAllSearchHistory:(RES_SUCCESS_ARR)success failure:(RES_FAILURE)failure {
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSArray *arrSortedDes = @[sortDes];
    NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:EntityNameSearch];
    
    [fetchReq setSortDescriptors:arrSortedDes];
    NSError *error = nil;
    NSArray *result = [_viewContext executeFetchRequest:fetchReq error:&error];
    if (error != nil) {
        if (failure) {
            failure(error);
        }
    }
    else {
        if (success) {
            success(result);
        }
    }
}

- (void)insertSearchKeyWord:(NSString *)serachWord success:(RES_SUCCESS_VOID)success failure:(RES_FAILURE)failure {
    NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:EntityNameSearch];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"keyword", serachWord];
    [fetchReq setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *arr = [_viewContext executeFetchRequest:fetchReq error:&error];
    //이미 똑같은 키워드로 저장된 놈이 있으면 날짜만 업데이트 해준다.
    if (arr.count > 0) {
        SearchHistory *search = [arr firstObject];
        search.date = [NSDate date];
        NSError *error = nil;
        if ([_viewContext save:&error] == NO) {
            if (failure) {
                failure(error);
            }
        }
        else {
            if (success) {
                success();
            }
        }
    }
    else {
        SearchHistory *search = [NSEntityDescription insertNewObjectForEntityForName:EntityNameSearch inManagedObjectContext:_viewContext];
        search.keyword = serachWord;
        search.date = [NSDate date];
        NSError *error = nil;
        if ([_viewContext save:&error] == NO) {
            if (failure) {
                failure(error);
            }
        }
        else {
            if (success) {
                success();
            }
        }
    }
}

- (void)deleteSearchHistory:(SearchHistory *)search success:(RES_SUCCESS_VOID)success failure:(RES_FAILURE)failure {
    [_viewContext deleteObject:search];
    NSError *error = nil;
    if ([_viewContext save:&error] == NO) {
        if (failure) {
            failure(error);
        }
    }
    else {
        if (success) {
            success();
        }
    }
}

- (void)requestSerchList:(NSString *)search success:(RES_SUCCESS_DIC)success failure:(RES_FAILURE)failure {
    NSMutableString *url = [NSMutableString string];
    [url appendFormat:@"search?q=%@", search];
    [url appendFormat:@"&key=%@", YoutubeAPIKEY];
    [url appendString:@"&videoEmbeddable=true"];    //any, true, 퍼갈수 있는지 여부
    [url appendString:@"&part=snippet"];
    [url appendString:@"&order=viewCount"];
    [url appendString:@"&type=video"];
    [url appendString:@"&videoDefinition=high"];
    [url appendString:@"&maxResults=30"];
    [[DBManager instance] GET:url success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
