//
//  PlayerManager.m
//  MyTube
//
//  Created by 김학철 on 2020/05/22.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "PlayerManager.h"
#import "AppDelegate.h"

@interface PlayerManager ()
@property (nonatomic, assign) NSInteger currentPosition;
@property (nonatomic, strong) NSMutableArray *playQueue;

@end
@implementation PlayerManager
+ (PlayerManager *)instance {
    static PlayerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PlayerManager alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (self = [super init]) {
        self.playQueue = [NSMutableArray array];
        self.isPlaying = NO;
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self setupRemoteCommands];
    }
    return self;
}

- (void)addPlayItem:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    if ([_playQueue containsObject:url] == NO) {
        [self.playQueue addObject:url];
    }
}

- (void)setUpPlayerForUrl:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    [self cleanPlayer];
    if (self.player == nil) {
        self.player = [[AVPlayer alloc] initWithURL:url];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{MPMediaItemPropertyTitle:@"MyTube"};
        [self.player play];
        self.isPlaying = YES;
    }
}

- (void)setupRemoteCommands {
    [[MPRemoteCommandCenter sharedCommandCenter].playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player play];
        self.isPlaying = YES;
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [[MPRemoteCommandCenter sharedCommandCenter].pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self.player pause];
        self.isPlaying = NO;
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [[MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        self.currentPosition +=1;
        [self cleanPlayer];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [[MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        self.currentPosition -=1;
        [self cleanPlayer];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)cleanPlayer {
    [self.player pause];
    self.isPlaying = NO;
    self.player = nil;
}
@end
