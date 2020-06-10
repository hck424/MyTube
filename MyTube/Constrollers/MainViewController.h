//
//  MainViewController.h
//  MyTube
//
//  Created by 김학철 on 2020/05/27.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"
IB_DESIGNABLE
NS_ASSUME_NONNULL_BEGIN
@interface MainViewController : LGSideMenuController
- (void)setupWithType:(NSUInteger)type;
@end

NS_ASSUME_NONNULL_END
