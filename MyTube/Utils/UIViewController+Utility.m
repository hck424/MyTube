//
//  UIViewController+Utility.m
//  MyTube
//
//  Created by 김학철 on 2020/05/28.
//  Copyright © 2020 김학철. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)
- (void)myAddChildViewController:(UIViewController *)childController {
    
    [self addChildViewController:childController];
    
    //add this
    [childController beginAppearanceTransition:YES animated:YES];
    [self.view addSubview:childController.view];
    childController.view.frame = self.view.bounds;
    [childController endAppearanceTransition];
    [childController didMoveToParentViewController:self];
    
//    [self addChildViewController:childController]; //add the child on childViewControllers array
//    [childController willMoveToParentViewController:self]; //viewWillAppear on childViewController
//    childController.view.frame = self.view.bounds;
//    [self.view addSubview:childController.view]; //add childView whenever you want
//    childController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [childController didMoveToParentViewController:self];
}

- (void)myRemoveChildViewController:(UIViewController *)viewController {
    [viewController beginAppearanceTransition:NO animated:YES];
    [viewController.view removeFromSuperview];
    [viewController endAppearanceTransition];
    
//    [viewController willMoveToParentViewController:nil];
//    [viewController.view removeFromSuperview];
//    [viewController removeFromParentViewController];
}

@end
