//
//  MenuViewController.m
//  Unplug
//
//  Created by CoolStar on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "QRCodeReaderViewController.h"
#import "FirebaseHelper.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (IBAction)scanQRCode:(id)sender {
    QRCodeReaderViewController *reader = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"Cancel"];
    [self presentViewController:reader animated:YES completion:nil];
    __block MenuViewController *menuViewController = self;
    [reader setCompletionWithBlock:^(NSString * _Nullable resultAsString) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"Result: %@", resultAsString);
            [FirebaseHelper.sharedWrapper joinRoomWithRID:resultAsString completion:^(BOOL joined) {
                if(joined) {
                    [menuViewController performSegueWithIdentifier:@"joinLobby" sender:self];
                }
            }];
        }];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)logoutTUI:(UIButton *)sender {
    [FirebaseHelper.sharedWrapper logout];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LoginViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
