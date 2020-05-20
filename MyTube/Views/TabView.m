//
//  TabView.m
//  BackgroundVideoPlayer
//
//  Created by 김학철 on 2020/05/11.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "TabView.h"
@interface TabView ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIStackView *svContent;
@property (nonatomic, assign) NSInteger tabCount;
@end

@implementation TabView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadXib];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self loadXib];
    }
    return self;
}

- (void)loadXib {
    UIView *xib = [[UINib nibWithNibName:@"TabView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    [self addSubview:xib];
    xib.translatesAutoresizingMaskIntoConstraints = NO;
    [xib.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:0].active = YES;
    [xib.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
    [xib.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
    [xib.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:0].active = YES;
}

- (void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(tabViewNumberOfCount)]) {
        self.tabCount = [_dataSource tabViewNumberOfCount];
    }
    
    for (UIButton *btn in [_svContent subviews]) {
        [btn removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < _tabCount; i++) {
        if ([self.dataSource respondsToSelector:@selector(tabViewIndexOfButton:)]) {
            UIButton *btn = [_dataSource tabViewIndexOfButton:i];
            [_svContent addArrangedSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(onClickedButtonActions:) forControlEvents:UIControlEventTouchUpInside];
            if (_activateIndex == i) {
                [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
}
- (void)onClickedButtonActions:(UIButton *)sender {
    for (UIButton *btn in _svContent.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(tabViewDidClickedAtIndex:)]) {
        [_delegate tabViewDidClickedAtIndex:sender.tag];
    }
}

@end
