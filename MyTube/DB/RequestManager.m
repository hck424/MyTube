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

#import "Category.h"
#import "Tube.h"

#define EntityNameSearch @"Search"


@interface RequestManager ()
@property (nonatomic, strong) FIRDatabaseReference *ref;

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
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

- (void)requestAllCategory:(RES_SUCCESS_ARR)success failure:(RES_FAILURE)failure {
    [[_ref child:@"categorys"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (success) {
            NSMutableArray *result = nil;
            for (FIRDataSnapshot *category in snapshot.children) {
                Category *cg = [[Category alloc] initWithSnapShot:category];
                if (result == nil) {
                    result = [NSMutableArray array];
                }
                [result addObject:cg];
            }
            success (result);
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)requestCategoryList:(NSString *)category success:(RES_SUCCESS_ARR)success failure:(RES_FAILURE)failure {
    if (category.length == 0) {
        return;
    }
    NSString *path = [NSString stringWithFormat:@"mytube/%@",category];
    
    [[_ref child:path] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (success) {
            NSMutableArray *result = nil;
            for (FIRDataSnapshot *snTube in snapshot.children) {
                if (result == nil) {
                    result = [NSMutableArray array];
                }
                Tube *tube = [[Tube alloc] initWithSnapShot:snTube];
                [result addObject:tube];
            }
            [result setArray:[[result reverseObjectEnumerator] allObjects]];
            success (result);
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    

    
}
@end
