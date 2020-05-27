//
//  AppDelegate.h
//  MyTube
//
//  Created by 김학철 on 2020/05/18.
//  Copyright © 2020 김학철. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) UIView *loadingView;

+ (AppDelegate *)instace;
- (void)saveContext;
- (void)startIndicator;
- (void)stopIndicator;
- (void)callMainViewController;
@end

