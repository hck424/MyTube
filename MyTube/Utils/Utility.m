//
//  Utility.m
//  DonYoungSang
//
//  Created by 김학철 on 2020/05/13.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+ (UIImage *)createThumbnailOfVideoFromRemoteUrl:(NSURL *)url {
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CMTime time = CMTimeMakeWithSeconds(1.0, 600);
    
    @try {
        CGImageRef img = [generator copyCGImageAtTime:time actualTime:nil error:nil];
        UIImage *thumbnail = [UIImage imageWithCGImage:img];
        return thumbnail;
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.callStackSymbols);
        return nil;
    }
}
@end
