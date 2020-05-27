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

@interface VideoCell () <AvPlayerViewDelegate>

@property (nonatomic, strong) NSDictionary *itemDic;
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

- (void)configurationData:(NSDictionary *)dataDic {
    self.itemDic = dataDic;
    
    NSDictionary *snippet = [dataDic objectForKey:@"snippet"];
    NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];
    NSString *thumbnailUrl = [[thumbnails objectForKey:@"high"] objectForKey:@"url"];
    _avPlayerView.ivThumbnail.image = nil;
    if (thumbnailUrl.length > 0) {
        [_avPlayerView.ivThumbnail setPin_updateWithProgress:YES];
        [_avPlayerView.ivThumbnail pin_setImageFromURL:[NSURL URLWithString:thumbnailUrl]];
    }
    
    NSString *title = [snippet objectForKey:@"title"];
    _lbTitle.text = title;
    
    NSURL *video_url = [_itemDic objectForKey:@"video_url"];
    NSTimeInterval length = [[_itemDic objectForKey:@"video_length"] floatValue];
    _avPlayerView.videoLenght = length;
    _avPlayerView.playingUrl = video_url;
    
    if ([[PlayerManager instance].currentPlayingUrl isEqual:video_url]
        && [PlayerManager instance].isPlaying) {
        [_avPlayerView setupPlayerLayer];
    }
    
    [self layoutIfNeeded];
}

- (void)didTapChangedPlayer {
    if (self.onClickedTouchUpInside) {
        self.onClickedTouchUpInside(_itemDic, 1);
    }
}
@end
