//
//  MenuViewController.m
//  Unplug
//
//  Created by CoolStar on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "MenuViewController.h"
#import "QRCodeReaderViewController.h"
#import "FirebaseHelper.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (IBAction)scanQRCode:(id)sender {
    QRCodeReaderViewController *reader = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"Cancel"];
    [self presentViewController:reader animated:YES completion:nil];
    [reader setCompletionWithBlock:^(NSString * _Nullable resultAsString) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"Result: %@", resultAsString);
        [FirebaseHelper.sharedWrapper joinRoomWithRID:resultAsString completion:^(BOOL joined) {
            if(joined) {
                [self performSegueWithIdentifier:@"joinLobby" sender:self];
            }
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
