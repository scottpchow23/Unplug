//
//  AppDelegate.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppDelegateLaunchDelegate
- (void)appTerminated;
- (void)appBackgrounded;
- (void)deviceLocked;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSObject<AppDelegateLaunchDelegate> *delegate;

@property (strong, nonatomic) UIWindow *window;


@end

