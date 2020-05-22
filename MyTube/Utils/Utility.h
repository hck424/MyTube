//
//  Utility.h
//  DonYoungSang
//
//  Created by 김학철 on 2020/05/13.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject
+ (UIImage *)createThumbnailOfVideoFromRemoteUrl:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
