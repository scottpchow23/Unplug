//
//  ViewController.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import "FirebaseHelper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    loginButton.readPermissions = @[@"public_profile"];
//    [self.view addSubview:loginButton];
//    [loginButton setDelegate:self];
    [self.fbLoginButton.layer setCornerRadius:14];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)loginTUI:(id)sender {
    [self.fbLoginButton setEnabled:NO];
    [FirebaseHelper.sharedWrapper login:self completion:^(BOOL success) {
        if(success) {
            [self performSegueWithIdentifier:@"toSetup" sender:self];
            
        }
        [self.fbLoginButton setEnabled:YES];
    }];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    [FirebaseHelper.sharedWrapper handleLogin:result error:error completion:^(BOOL completed) {
        if(completed) {
            [self performSegueWithIdentifier:@"toSetup" sender:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

@end



