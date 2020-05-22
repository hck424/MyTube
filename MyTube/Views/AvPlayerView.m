//
//  AvPlayerView.m
//  MyTube
//
//  Created by 김학철 on 2020/05/22.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "AvPlayerView.h"
#import <AVKit/AVKit.h>
#import "PlayerManager.h"

@interface AvPlayerView ()
@property (nonatomic, strong) UIView *xib;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end
@implementation AvPlayerView
@synthesize xib = xib;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadXib];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self loadXib];
    }
    return self;
}

- (void)loadXib {
    self.xib = [[UINib nibWithNibName:@"AvPlayerView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    [self addSubview:xib];
    xib.translatesAutoresizingMaskIntoConstraints = NO;
    [xib.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0].active = YES;
    [xib.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0].active = YES;
    [xib.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
    [xib.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;

}

- (void)setupPlayerLayer {
    self.playerLayer = [[AVPlayerLayer alloc] init];
    _playerLayer.frame = xib.bounds;
    _playerLayer.player = [PlayerManager instance].player;
    [xib.layer insertSublayer:_playerLayer atIndex:0];
}

- (void)destroyLayer {
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = [[AVPlayerLayer alloc] init];
}

@end
