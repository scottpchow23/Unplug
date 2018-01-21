//
//  ResultsViewController.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "ResultsViewController.h"
#import "AppDelegate.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.loserName){
        NSString *oweYou = [NSString stringWithFormat:@" lost! They owe you $%@.", self.betAmount];
        self.resultLabel.text = [self.loserName stringByAppendingString:oweYou];
    } else {
        self.resultLabel.text = @"Congrats, no one used their phone!";
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
