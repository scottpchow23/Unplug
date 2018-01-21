//
//  RoomStatsViewController.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CountdownLabel/CountdownLabel-Swift.h>
#import "AppDelegate.h"

@interface RoomStatsViewController : UIViewController <AppDelegateLaunchDelegate> {
    BOOL _markBackgrounded;
}
@property (weak, nonatomic) IBOutlet CountdownLabel *countdownLabel;

@end
