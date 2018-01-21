//
//  RoomSetupViewController.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "RoomSetupViewController.h"
#import "RoomStatsViewController.h"
#import "QRCodeGeneratorViewController.h"
#import "FirebaseHelper.h"
#import "Room.h"

@interface RoomSetupViewController ()

@end

@implementation RoomSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeys)];
    [self.view addGestureRecognizer:tapGesture];
    
    [_timeLimitSpinner setCountDownDuration:60];
    // Do any additional setup after loading the view.
}

-(void) dismissKeys {
    [self.view endEditing:YES];
}

- (IBAction)startRoomTUI:(id)sender {
    Room *newRoom = [[Room alloc] init];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    newRoom.betAmount = [formatter numberFromString:_betAmountField.text];
    if (newRoom.betAmount == nil)
        return;
    newRoom.timeLimit = [NSNumber numberWithDouble:[_timeLimitSpinner countDownDuration]];
    newRoom.timeStart = @0;
    [FirebaseHelper.sharedWrapper createAndJoinRoom:newRoom completion:^(BOOL created) {
        if(created) {
            [self performSegueWithIdentifier:@"createLobby" sender:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"createLobby"]) {
        QRCodeGeneratorViewController *destination = segue.destinationViewController;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        destination.betAmount = [formatter numberFromString:_betAmountField.text];
    }
}

@end
