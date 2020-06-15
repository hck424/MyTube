//
//  VideoCell.m
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "VideoCell.h"
#import "PINImageView+PINRemoteImage.h"

#import "PlayerManager.h"
#import "Tube.h"

@interface VideoCell () <AvPlayerViewDelegate>

@property (nonatomic, strong) Tube *tube;
@end
@implementation VideoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = view;
    _avPlayerView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configurationData:(Tube *)tube {
    self.tube = tube;
    
    NSString *thumbnailUrl = tube.thumbnailUrl;
    _avPlayerView.ivThumbnail.image = nil;
    if (thumbnailUrl.length > 0) {
        [_avPlayerView.ivThumbnail setPin_updateWithProgress:YES];
        [_avPlayerView.ivThumbnail pin_setImageFromURL:[NSURL URLWithString:thumbnailUrl]];
    }
    
    _lbTitle.text = tube.title;
    
    NSURL *videoUrl = [NSURL URLWithString:tube.videoUrl];
    _avPlayerView.videoLenght = tube.videoLenght;
    _avPlayerView.playingUrl = videoUrl;
    
    if ([[PlayerManager instance].currentPlayingUrl isEqual:videoUrl]
        && [PlayerManager instance].isPlaying) {
        [_avPlayerView setupPlayerLayer];
    }
    
    [self layoutIfNeeded];
}

- (void)didTapChangedPlayer {
    if (self.onClickedTouchUpInside) {
        self.onClickedTouchUpInside(_tube, 1);
    }
}
@end
