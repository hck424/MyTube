//
//  AvPlayerView.m
//  MyTube
//
//  Created by 김학철 on 2020/05/22.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "AvPlayerView.h"
#import "PlayerManager.h"
#import "PlayerManager.h"

@interface AvPlayerView ()

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnFullScreenMode;
@property (weak, nonatomic) IBOutlet UILabel *lbCurTime;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong) UIView *xib;
@property (nonatomic, assign) BOOL showControls;

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

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesute:)];
    [_ivThumbnail addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesute:)];
    [_playerView addGestureRecognizer:tap1];
    [_slider setThumbImage:[UIImage imageNamed:@"icon_line"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"icon_filled_circle"] forState:UIControlStateSelected];
    [_slider setThumbImage:[UIImage imageNamed:@"icon_filled_circle"] forState:UIControlStateHighlighted];
    _btnPlay.hidden = YES;
    _btnFullScreenMode.hidden = YES;
    _lbCurTime.hidden = YES;
    _slider.hidden = YES;
    _ivThumbnail.hidden = NO;
}

- (void)setPlayingUrl:(NSURL *)playingUrl {
    _playingUrl = playingUrl;
    
    _slider.hidden = YES;
    _ivThumbnail.hidden = NO;
    _lbCurTime.hidden = YES;
    _btnPlay.selected = NO;
    _slider.value = 0.0;
    
    if ([PlayerManager instance].isPlaying
        && [_playingUrl isEqual:[PlayerManager instance].currentPlayingUrl]) {
        _slider.hidden = NO;
        _ivThumbnail.hidden = YES;
        _btnPlay.selected = YES;
        _lbCurTime.hidden = NO;
        
        _slider.maximumValue = _videoLenght;
    }
}
- (void)setShowControls:(BOOL)showControls {
    _showControls = showControls;
    if (_showControls == YES) {
        _btnPlay.hidden = NO;
        _btnFullScreenMode.hidden = NO;
        _slider.selected = YES;
    }
    else {
        _slider.selected = NO;
        _btnPlay.hidden = YES;
        _btnFullScreenMode.hidden = YES;
    }
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
}

- (void)setupPlayerLayer {
    
    [self layoutIfNeeded];
    if (_playerLayer != nil) {
        [_playerLayer removeFromSuperlayer];
    }
    
    self.playerLayer = [[AVPlayerLayer alloc] init];
    _playerLayer.frame = xib.bounds;
    _playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _playerLayer.player = [PlayerManager instance].player;
    [_playerView.layer insertSublayer:_playerLayer atIndex:0];
    _playerView.layer.masksToBounds = YES;
}

- (void)destroyLayer {
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = [[AVPlayerLayer alloc] init];
}

- (void)singleTapGesute:(UITapGestureRecognizer *)gesture {
    
    if ([gesture.view isEqual:_ivThumbnail]) {
        if ([self.delegate respondsToSelector:@selector(didTapChangedPlayer)]) {
            [_delegate didTapChangedPlayer];
        }
        
        _btnPlay.selected = YES;
        _ivThumbnail.hidden = YES;
        
        if (_playingUrl != nil) {
            [self setupPlayerLayer];
            [[PlayerManager instance] setupPlayerWithUrl:_playingUrl];
            _playerLayer.player = [PlayerManager instance].player;
            _btnPlay.selected = YES;
            
            __weak typeof(self)weakSelf = self;
            [[PlayerManager instance].player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC)
                                                        queue:NULL
                                                   usingBlock:^(CMTime time){
                
                [weakSelf updateProgress:CMTimeGetSeconds([PlayerManager instance].player.currentTime)];
            }];
        }
    }
    else if ([gesture.view isEqual:_playerView]) {
        self.showControls = YES;
        [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            self.showControls = NO;
        }];
    }
}
- (void)updateProgress:(float)time {
    if (isnan(time) == false) {
        self.slider.value = time;
        
        self.lbCurTime.text = [self getFormattedTime:time];
    }
}

- (NSString *)getFormattedTime:(float)time {
    if (time == -1) {
        return @"--:--";
    }
    
    NSDateComponentsFormatter *dcFormatter = [[NSDateComponentsFormatter alloc] init];
    dcFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorNone;
    dcFormatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    if (time >= 60*60) {
        dcFormatter.allowedUnits |= NSCalendarUnitHour;
    }
    dcFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    return [dcFormatter stringFromTimeInterval:time];
}

- (CMTime)getAvailableDuration {
    NSValue *range = [PlayerManager instance].player.currentItem.loadedTimeRanges.firstObject;
    if (range != nil){
        return CMTimeRangeGetEnd(range.CMTimeRangeValue);
    }
    return kCMTimeZero;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if ([PlayerManager instance].isPlaying && [[PlayerManager instance] isCurrentPlayingUrl:_playingUrl]) {
        
        NSInteger value = _slider.value;
        CMTime seekTime = CMTimeMake(value*1000, 1000);
        [[PlayerManager instance].player seekToTime:seekTime completionHandler:^(BOOL finished) {
            
        }];
    }
    
}

- (IBAction)onClickedButtonActions:(UIButton *)sender {
   
    if (sender == _btnPlay) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [[PlayerManager instance].player play];
        }
        else {
            [[PlayerManager instance].player pause];
        }
    }
}

@end
