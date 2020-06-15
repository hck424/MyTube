//
//  Tube.h
//  MyTube
//
//  Created by 김학철 on 2020/06/15.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;
NS_ASSUME_NONNULL_BEGIN

@interface Tube : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *youtubeId;
@property (nonatomic, assign) NSTimeInterval videoLenght;
- (id)initWithSnapShot:(FIRDataSnapshot *)snapshot;
@end

NS_ASSUME_NONNULL_END
