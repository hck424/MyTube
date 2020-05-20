//
//  TabView.h
//  BackgroundVideoPlayer
//
//  Created by 김학철 on 2020/05/11.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabView;

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE

@protocol TabViewDelegate;
@protocol TabViewDataSource;

@interface TabView : UIView
@property (nonatomic, weak) IBOutlet id <TabViewDelegate>delegate;
@property (nonatomic, weak) IBOutlet id <TabViewDataSource>dataSource;
@property (nonatomic, assign) NSInteger activateIndex;
- (void)reloadData;

@end

@protocol TabViewDelegate <NSObject>
- (void)tabViewDidClickedAtIndex:(NSInteger)index;
@end
@protocol TabViewDataSource <NSObject>
- (NSInteger)tabViewNumberOfCount;
- (UIButton *)tabViewIndexOfButton:(NSInteger)index;

@end
NS_ASSUME_NONNULL_END
