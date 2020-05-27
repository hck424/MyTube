//
//  AvPlayerView.h
//  MyTube
//
//  Created by 김학철 on 2020/05/22.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol AvPlayerViewDelegate <NSObject>
- (void)didTapChangedPlayer;
@end

@interface AvPlayerView : UIView
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) IBOutlet UIImageView *ivThumbnail;
@property (nonatomic, strong) NSURL *playingUrl;
@property (nonatomic, assign) NSTimeInterval videoLenght;
- (void)setupPlayerLayer;
- (void)destroyLayer;

@property (nonatomic, weak) id <AvPlayerViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
