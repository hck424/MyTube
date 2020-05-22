//
//  PlayerManager.h
//  MyTube
//
//  Created by 김학철 on 2020/05/22.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface PlayerManager : NSObject
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL isPlaying;

+ (PlayerManager *)instance;
- (void)setUpPlayerForUrl:(NSURL *)url;
- (void)addPlayItem:(NSURL *)url;

@end

