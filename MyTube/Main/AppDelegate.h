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
+ (AppDelegate *)instace;
- (void)saveContext;
- (void)startIndicatior;
- (void)stopIndicatior;
@end

