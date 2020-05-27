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

- (void)setupPlayerWithUrl:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    [self cleanPlayer];
    if (self.player == nil) {
        self.player = [[AVPlayer alloc] initWithURL:url];
        self.currentPlayingUrl = url;
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{MPMediaItemPropertyTitle:@"MyTube"};
        [self.player play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayingUrl];
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
        if (self.currentPosition == self.playQueue.count - 1) {
            self.currentPosition = 0;
        }
        
        NSURL *url = [self.playQueue objectAtIndex:self.currentPosition];
        [self setupPlayerWithUrl:url];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameChangePlayItem object:nil];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [[MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        self.currentPosition -=1;
        if (self.currentPosition == 0) {
            self.currentPosition = self.playQueue.count - 1;
        }
        
        NSURL *url = [self.playQueue objectAtIndex:self.currentPosition];
        [self setupPlayerWithUrl:url];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameChangePlayItem object:nil];

        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)cleanPlayer {
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    self.isPlaying = NO;
    self.player = nil;
}

- (BOOL)isCurrentPlayingUrl:(NSURL *)url {
    if ([_currentPlayingUrl isEqual:url]) {
        return YES;
    }
    return NO;
}
- (void)notificationHandler:(NSNotificationCenter *)notification {
    
}
@end
