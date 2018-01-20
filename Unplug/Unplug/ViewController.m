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
    if (error == nil && !result.isCancelled) {
        
        FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if (error != NULL) {
                return;
            }
            [FirebaseHelper.sharedWrapper getUserWithUID:user.uid completion:^(User *user) {
                if (user == NULL) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"name"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                        } else {
                            NSLog(@"fetched user:%@", result);
                            User *newUser = [[User alloc] init];
                            newUser.uid = [[FIRAuth auth] currentUser].uid;
                            newUser.name = [result objectForKey:@"name"];
                            newUser.balance = @0;
                            [FirebaseHelper.sharedWrapper createUser:newUser];
                            [FirebaseHelper.sharedWrapper setCurrentUser:newUser];
                        }
                    }];
                } else {
                    [FirebaseHelper.sharedWrapper setCurrentUser:user];
                }
                //                TODO: Transition Here
                [self performSegueWithIdentifier:@"toSetup" sender:self];
            }];
        }];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

@end



