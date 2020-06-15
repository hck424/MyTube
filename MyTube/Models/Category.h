//
//  Category.h
//  MyTube
//
//  Created by 김학철 on 2020/06/15.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface Category : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *titleEn;
@property (nonatomic, strong) NSString *titleKo;

- (id)initWithSnapShot:(FIRDataSnapshot *)snapshot;
@end

NS_ASSUME_NONNULL_END
