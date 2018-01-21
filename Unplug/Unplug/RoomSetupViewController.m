//
//  RoomSetupViewController.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "RoomSetupViewController.h"
#import "FirebaseHelper.h"
#import "Room.h"

@interface RoomSetupViewController ()

@end

@implementation RoomSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeys)];
    [self.view addGestureRecognizer:tapGesture];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
