//
//  VideoCell.h
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvPlayerView.h"
#import "Tube.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AvPlayerView *avPlayerView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (nonatomic, copy) void (^onClickedTouchUpInside) (Tube *tube, NSInteger buttonAction);
- (void)configurationData:(NSDictionary *)dataDic;
- (void)setOnClickedTouchUpInside:(void (^ _Nonnull )(Tube * _Nonnull tube, NSInteger buttonAction))onClickedTouchUpInside;
@end

NS_ASSUME_NONNULL_END
