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
#import <FirebaseFirestore.h>
 
#define EntityNameSearch @"Search"


@interface RequestManager ()
//@property (nonatomic, strong) NSManagedObjectContext *viewContext;
@property (nonatomic, strong) FIRDatabaseReference *ref;
@property (nonatomic, readwrite) FIRFirestore *db;
@property (nonatomic, strong) FIRCollectionReference *mytubeRef;
@property (nonatomic, strong) FIRCollectionReference *categoryRef;
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
//        self.viewContext = [AppDelegate instace].persistentContainer.viewContext;
        self.ref = [[FIRDatabase database] reference];
        self.db = [FIRFirestore firestore];
        self.mytubeRef = [_db collectionWithPath:@"mytube"];
        self.categoryRef = [_db collectionWithPath:@"category"];
    }
    return self;
}

- (void)requestAllCategory:(RES_SUCCESS_ARR)success failure:(RES_FAILURE)failure {
    [[_categoryRef queryOrderedByField:@"timestamp" descending:YES] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            if (failure) {
                failure (error);
            }
        }
        else {
            NSMutableArray *result = [NSMutableArray array];
            for (FIRQueryDocumentSnapshot *sn in snapshot.documents) {
                NSDictionary *item = sn.data;
                [result addObject:item];
            }
            if (success) {
                success(result);
            }
        }
    }];
//    [_categoryRef getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
//        if (error != nil) {
//            if (failure) {
//                failure (error);
//            }
//        }
//        else {
//            NSMutableArray *result = [NSMutableArray array];
//            for (FIRQueryDocumentSnapshot *sn in snapshot.documents) {
//                NSDictionary *item = sn.data;
//                [result addObject:item];
//            }
//            if (success) {
//                success(result);
//            }
//        }
//    }];
}
- (void)requestCategoryList:(NSString *)category success:(RES_SUCCESS_ARR)success failure:(RES_FAILURE)failure {
    if (category.length == 0) {
        return;
    }
    
    [[[_mytubeRef queryWhereField:@"category" isEqualTo:category] queryOrderedByField:@"timestamp" descending:YES] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            if (failure) {
                failure (error);
            }
        }
        else {
            NSMutableArray *result = [NSMutableArray array];
            for (FIRQueryDocumentSnapshot *shot in snapshot.documents) {
                NSDictionary *item = shot.data;
                [result addObject:item];
            }
            
            if (success) {
                success(result);
            }
        }
    }];
}

//Local DB 히스토리
//- (void)fetchAllSearchList:(RES_SUCCESS_ARR)success failure:(RES_FAILURE)failure {
    
    
//    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
//    NSArray *arrSortedDes = @[sortDes];
//    NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:EntityNameSearch];
//    [fetchReq setSortDescriptors:arrSortedDes];
//
//    NSError *error = nil;
//    NSArray *result = [_viewContext executeFetchRequest:fetchReq error:&error];
//    if (error != nil) {
//        if (failure) {
//            failure(error);
//        }
//    }
//    else {
//        NSMutableArray *arrFixed = [NSMutableArray array];
//        NSMutableArray *arrNotFixed = [NSMutableArray array];
//        NSMutableArray *arrData = [NSMutableArray array];
//        for (Search *search in result) {
//            if (search.fixed) {
//                [arrFixed addObject:search];
//            }
//            else {
//                [arrNotFixed addObject:search];
//            }
//        }
//
//        [arrData addObjectsFromArray:arrFixed];
//        [arrData addObjectsFromArray:arrNotFixed];
//
//        if (success) {
//            success(arrData);
//        }
//    }
//}

//- (void)insertSearchKeyWord:(NSString *)serachWord fixed:(BOOL)fixed success:(RES_SUCCESS_VOID)success failure:(RES_FAILURE)failure {
//    NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:EntityNameSearch];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"keyword", serachWord];
//    [fetchReq setPredicate:predicate];
//
//    NSError *error = nil;
//    NSArray *arr = [_viewContext executeFetchRequest:fetchReq error:&error];
//    //이미 똑같은 키워드로 저장된 놈이 있으면 날짜만 업데이트 해준다.
//    if (arr.count > 0) {
//        Search *search = [arr firstObject];
//        search.date = [NSDate date];
//        search.fixed = fixed;
//        NSError *error = nil;
//        if ([_viewContext save:&error] == NO) {
//            if (failure) {
//                failure(error);
//            }
//        }
//        else {
//            if (success) {
//                success();
//            }
//        }
//    }
//    else {
//        Search *search = [NSEntityDescription insertNewObjectForEntityForName:EntityNameSearch inManagedObjectContext:_viewContext];
//        search.keyword = serachWord;
//        search.date = [NSDate date];
//        search.fixed = fixed;
//        NSError *error = nil;
//        if ([_viewContext save:&error] == NO) {
//            if (failure) {
//                failure(error);
//            }
//        }
//        else {
//            if (success) {
//                success();
//            }
//        }
//    }
//}
//
//- (void)deleteSearchHistory:(Search *)search success:(RES_SUCCESS_VOID)success failure:(RES_FAILURE)failure {
//    [_viewContext deleteObject:search];
//    NSError *error = nil;
//    if ([_viewContext save:&error] == NO) {
//        if (failure) {
//            failure(error);
//        }
//    }
//    else {
//        if (success) {
//            success();
//        }
//    }
//}
//
//- (void)requestYoutubeSearchList:(NSString *)search
//                      maxResults:(NSInteger)maxResults
//                         pageKey:(NSString *)pageKey
//                         success:(RES_SUCCESS_DIC)success
//                         failure:(RES_FAILURE)failure
//{
//    NSMutableString *url = [NSMutableString string];
//    [url appendFormat:@"search?q=%@", search];
//    [url appendFormat:@"&key=%@", YoutubeAPIKEY];
////    [url appendString:@"&videoEmbeddable=true"];    //videoEmbeddable : any, true, 퍼갈수 있는지 여부
//    [url appendString:@"&part=snippet"];
////    [url appendString:@"&order=date"];
////    [url appendString:@"&type=video"];
////    [url appendString:@"&videoDefinition=high"];
//    [url appendFormat:@"&maxResults=%ld", maxResults];
//    if (pageKey.length > 0) {
//        [url appendFormat:@"&nextPageToken=%@", pageKey];
//    }
//
//    [[DBManager instance] GET:url success:^(id data) {
//        if (success) {
//            success(data);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}

@end
