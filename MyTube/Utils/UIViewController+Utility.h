//
//  UIViewController+Utility.h
//  MyTube
//
//  Created by 김학철 on 2020/05/28.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Utility)
- (void)myAddChildViewController:(UIViewController *)childController;
- (void)myRemoveChildViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
