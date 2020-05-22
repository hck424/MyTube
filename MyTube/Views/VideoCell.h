//
//  VideoCell.h
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivThumbnail;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFull;
@property (nonatomic, copy) void (^onClickedTouchUpInside) (NSDictionary *itemDic, NSInteger buttonAction);
- (void)configurationData:(NSDictionary *)dataDic;
- (void)setOnClickedTouchUpInside:(void (^ _Nonnull )(NSDictionary * _Nonnull itemDic, NSInteger buttonAction))onClickedTouchUpInside;
@end

NS_ASSUME_NONNULL_END
