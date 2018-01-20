//
//  ViewController.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit.h>
#import <FBSDKCoreKit.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import "FirebaseHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    loginButton.readPermissions = @[@"public_profile"];
    [self.view addSubview:loginButton];
    [loginButton setDelegate:self];
    // Do any additional setup after loading the view, typically from a nib.
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



