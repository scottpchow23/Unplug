//
//  RoomStatsViewController.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "RoomStatsViewController.h"
#import "FirebaseHelper.h"
#import "ResultsViewController.h"

#import <UserNotifications/UserNotifications.h>

@interface RoomStatsViewController ()

@end

@implementation RoomStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setDelegate:self];
    [self.timerLabel setText: @"Getting time left..."];
    [self setUpLabel];
}

- (void)setUpLabel {
    [FirebaseHelper.sharedWrapper getInfoForRID:[FirebaseHelper.sharedWrapper getCurrentRID] completion:^(NSNumber *betAmount, NSNumber *startTime, NSNumber *timeLimit) {
        self.betAmount = betAmount;
        self.startTime = startTime;
        self.timeLimit = timeLimit;
        self.statLabel.text = [NSString stringWithFormat:@"If you leave, you'll owe everyone $%@.", self.betAmount];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }];
}

- (void)updateTimer {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSLog(@"Now: %f", (float)now);
    NSLog(@"Start: %f", self.startTime.doubleValue);
    NSLog(@"Time Limit: %f", self.timeLimit.doubleValue);
    NSTimeInterval final = self.startTime.doubleValue + self.timeLimit.doubleValue;
    NSTimeInterval timeLeft = final - now;
    
    if (timeLeft < 1){
        [_timer invalidate];
        [self performSegueWithIdentifier:@"toResults" sender:self];
        return;
    }
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    NSString *timeLeftString = [formatter stringFromTimeInterval:timeLeft];
    
    [self.timerLabel setText:timeLeftString];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setUpListener];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self tearDownListener];
}

-(void) setUpListener {
    FIRDatabaseReference *roomUsersRef = [[[[FIRDatabase database].reference child:@"rooms"] child:[FirebaseHelper.sharedWrapper getCurrentRID]] child:@"users"];
    [roomUsersRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *loserName = @"";
        for (FIRDataSnapshot *snap in snapshot.children) {
            if(![snap.value[@"time"] isEqual:@0]) {
                loserName = snap.value[@"name"];
            }
        }
        NSLog(@"The loser is: %@",loserName);
        if(loserName.length > 0) {
            self.loserName = loserName;
            [self performSegueWithIdentifier:@"toResults" sender:self];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toResults"]) {
        ResultsViewController *destination = segue.destinationViewController;
        destination.loserName = self.loserName;
        destination.betAmount = self.betAmount;
    }
}

-(void) tearDownListener {
    FIRDatabaseReference *roomUsersRef = [[[[FIRDatabase database].reference child:@"rooms"] child:[FirebaseHelper.sharedWrapper getCurrentRID]] child:@"users"];
    [roomUsersRef removeAllObservers];
}

- (void)appBackgrounded {
    FIRDatabaseReference *roomUserTimeRef = [[[[[[FIRDatabase database].reference child:@"rooms"] child:[FirebaseHelper.sharedWrapper getCurrentRID]] child:@"users"] child:[FirebaseHelper.sharedWrapper getCurrentUser].uid] child:@"time"];
    _markBackgrounded = YES;
    NSLog(@"Backgrounded Received");
    __block UIBackgroundTaskIdentifier backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"waitLock" expirationHandler:^{
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_markBackgrounded){
            NSLog(@"Marking Backgrounded");
            
            [roomUserTimeRef runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
                NSNumber *currentTime = currentData.value;
                if ([currentTime isEqual:@0]){
                    currentData.value = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
                }
                return [FIRTransactionResult successWithValue:currentData];
            } andCompletionBlock:^(NSError * _Nullable error, BOOL committed, FIRDataSnapshot * _Nullable snapshot) {
                UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                content.title = @"You lost!";
                content.body = [NSString stringWithFormat:@"You owe everyone $%@.", self.betAmount];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"loserIdentifier" content:content trigger:nil];
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"Something went wrong: %@",error);
                    }
                }];
                [[UIApplication sharedApplication] endBackgroundTask:backgroundIdentifier];
            }];
        } else {
            NSLog(@"Not Backgrounded Received");
            [[UIApplication sharedApplication] endBackgroundTask:backgroundIdentifier];
        }
    });
}

- (void)deviceLocked {
    _markBackgrounded = NO;
    NSLog(@"Device Lock Received!");
}

- (void)appTerminated {
    [[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"terminationTimestamp"];
    NSLog(@"Termination Received");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
