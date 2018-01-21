//
//  ResultsViewController.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property NSString *loserName;
@property NSNumber *betAmount;
@end
