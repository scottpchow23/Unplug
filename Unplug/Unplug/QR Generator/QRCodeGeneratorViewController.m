//
//  QRCodeGeneratorViewController.m
//  Unplug-QR test
//
//  Created by CoolStar on 1/20/18.
//  Copyright © 2018 CoolStar. All rights reserved.
//

#import "QRCodeGeneratorViewController.h"
#import "FirebaseHelper.h"
#import <CoreImage/CoreImage.h>

@interface QRCodeGeneratorViewController ()

@end

@implementation QRCodeGeneratorViewController

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:[[FirebaseHelper.sharedWrapper getCurrentRID] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    _qrCode.image = [self createNonInterpolatedUIImageFromCIImage:filter.outputImage withScale:10];
    
    
    
    
}

- (void) reloadTableView {
    
}

- (void) setUpListener {
    FIRDatabaseReference *roomUsersRef = [[[[FIRDatabase database].reference child:@"rooms"] child:[FirebaseHelper.sharedWrapper getCurrentRID]] child:@"users"];
    [roomUsersRef observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
    }];
}

- (void) tearDownListener {
    
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                                scale:scaledImage.scale
                                          orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FriendIdentifier = @"FriendsCheckedInCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendIdentifier];
    }
    cell.textLabel.text = @"Test";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startRoomTUI:(id)sender {
    [FirebaseHelper.sharedWrapper startRoom];
}

@end
