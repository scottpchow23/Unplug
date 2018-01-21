//
//  RoomStatsViewController.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "RoomStatsViewController.h"
#import "FirebaseHelper.h"
#import <UserNotifications/UserNotifications.h>

@interface RoomStatsViewController ()

@end

@implementation RoomStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setDelegate:self];
    
    // Do any additional setup after loading the view.
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
                content.title = @"Loser";
                content.body = @"You Lost";
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
