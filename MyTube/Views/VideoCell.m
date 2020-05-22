//
//  VideoCell.m
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "VideoCell.h"
#import "PINImageView+PINRemoteImage.h"
#import "AvPlayerView.h"
#import "XCDYouTubeClient.h"
#import "UIView+Toast.h"
#import "PlayerManager.h"

@interface VideoCell ()
@property (weak, nonatomic) IBOutlet AvPlayerView *avPlayerView;
@property (nonatomic, strong) NSDictionary *itemDic;
@end
@implementation VideoCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configurationData:(NSDictionary *)dataDic {
    self.itemDic = dataDic;
    self.ivThumbnail.hidden = NO;
    
    NSDictionary *snippet = [dataDic objectForKey:@"snippet"];
    NSDictionary *thumbnails = [snippet objectForKey:@"thumbnails"];
    NSString *thumbnailUrl = [[thumbnails objectForKey:@"high"] objectForKey:@"url"];
    if (thumbnailUrl.length > 0) {
        [_ivThumbnail setPin_updateWithProgress:YES];
        [_ivThumbnail pin_setImageFromURL:[NSURL URLWithString:thumbnailUrl]];
    }
    
    NSString *title = [snippet objectForKey:@"title"];
    _lbTitle.text = title;
}

- (IBAction)onClickedButtonActions:(id)sender {
    if (sender == _btnPlay) {
        
        NSString *videoId = [[_itemDic objectForKey:@"id"] objectForKey:@"videoId"];
        
        [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoId completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
            
            if (error == nil && video.streamURL != nil) {
                NSURL *url = video.streamURL;
                NSLog(@"%@", url);
                self.ivThumbnail.hidden = YES;
                [[PlayerManager instance] addPlayItem:url];
                [[PlayerManager instance] setUpPlayerForUrl:url];
                [self.avPlayerView setupPlayerLayer];
            }
            else {
                [self.contentView makeToast:@"Url parsing error"];
            }
        }];
    }
    else if (sender == _btnFull && self.onClickedTouchUpInside) {
        self.onClickedTouchUpInside(_itemDic, 0);
    }
}

@end
