//
//  RoomStatsViewController.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RoomStatsViewController : UIViewController <AppDelegateLaunchDelegate> {
    BOOL _markBackgrounded;
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UILabel *statLabel;
@property NSString *loserName;
@property NSNumber *betAmount;
@property NSNumber *startTime;
@property NSNumber *timeLimit;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
//@property (weak, nonatomic) IBOutlet CountdownLabel *countdownLabel;

@end
