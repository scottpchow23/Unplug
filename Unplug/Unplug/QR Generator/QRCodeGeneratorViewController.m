//
//  QRCodeGeneratorViewController.m
//  Unplug-QR test
//
//  Created by CoolStar on 1/20/18.
//  Copyright © 2018 CoolStar. All rights reserved.
//

#import "QRCodeGeneratorViewController.h"
#import "FirebaseHelper.h"
#import "RoomStatsViewController.h"
#import <CoreImage/CoreImage.h>

@interface QRCodeGeneratorViewController ()

@end

@implementation QRCodeGeneratorViewController

- (IBAction)dismiss:(id)sender {
    //    TODO: delete user from room when they leave
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uidAndNameDict = [[NSMutableDictionary alloc] init];
    [self.tableView setDataSource:self];
//    [self.tableView setDelegate:self];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:[[FirebaseHelper.sharedWrapper getCurrentRID] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    _qrCode.image = [self createNonInterpolatedUIImageFromCIImage:filter.outputImage withScale:10];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUpListener];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self tearDownListener];
}

- (void) setUpListener {
    FIRDatabaseReference *roomUsersRef = [[[FIRDatabase database].reference child:@"rooms"] child:[FirebaseHelper.sharedWrapper getCurrentRID]];
    typedef void (^ObserveEventBlock)(FIRDataSnapshot * _Nonnull snapshot);
    ObserveEventBlock observeEventBlock = ^(FIRDataSnapshot * _Nonnull snapshot){
        for (FIRDataSnapshot *snap2 in snapshot.children){
            if ([snap2.key isEqualToString:@"users"]){
                for (FIRDataSnapshot *snap in snap2.children) {
                    [self.uidAndNameDict setValue:snap.value[@"name"] forKey:snap.key];
                    NSLog(@"%@", self.uidAndNameDict);
                    [self.tableView reloadData];
                }
            } else if ([snap2.key isEqualToString:@"timeStart"] && ![snap2.value isEqual:@0]){
                NSLog(@"Started!");
                [self performSegueWithIdentifier:@"roomStats" sender:self];
            }
        }
    };
    
    [roomUsersRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:observeEventBlock];
    
    [roomUsersRef observeEventType:FIRDataEventTypeValue withBlock:observeEventBlock];
}

- (void) tearDownListener {
    FIRDatabaseReference *roomUsersRef = [[[[FIRDatabase database].reference child:@"rooms"] child:[FirebaseHelper.sharedWrapper getCurrentRID]] child:@"users"];
    [roomUsersRef removeAllObservers];
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
    return self.uidAndNameDict.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FriendIdentifier = @"FriendsCheckedInCellIdentifier";
    NSString *key = [self.uidAndNameDict.allKeys objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendIdentifier];
    }
    cell.textLabel.text = [self.uidAndNameDict objectForKey:key];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startRoomTUI:(id)sender {
    [FirebaseHelper.sharedWrapper startRoom];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"roomStats"]) {
        RoomStatsViewController *destination = segue.destinationViewController;
        destination.betAmount = self.betAmount;
    }
}

@end
