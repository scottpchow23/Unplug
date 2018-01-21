//
//  QRCodeGeneratorViewController.h
//  Unplug-QR test
//
//  Created by CoolStar on 1/20/18.
//  Copyright © 2018 CoolStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeGeneratorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIImageView *_qrCode;
}

@end
