//
//  TabButton.h
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabButton : UIButton
@property (nonatomic, assign) CGFloat underLineWidth;
@property (nonatomic, strong) UIColor *colorNormal;
@property (nonatomic, strong) UIColor *colorSelect;

@end
