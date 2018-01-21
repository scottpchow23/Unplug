//
//  FirebaseHelper.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"
#import "Room.h"

@interface FirebaseHelper : NSObject {
    User *currentUser;
    NSString *currentRID;
    @private FIRDatabaseReference* ref;
}


+(instancetype) sharedWrapper;

-(void)getUserWithUID: (NSString *) uid completion: (void (^)(User *)) completion;
-(void)createUser:(User *)newUser;

-(void)setCurrentUser:(User *) user;
-(User *)getCurrentUser;

-(void)getAndSetCurrentUser:(NSString *) uid;

-(void)setCurrentRID:(NSString *) rid;
-(NSString *)getCurrentRID;

-(void)handleLogin:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error completion:(void (^)(BOOL)) completion;

-(void)createAndJoinRoom:(Room *) room completion:(void(^)(BOOL)) completion;
-(void)joinRoomWithRID:(NSString *)rid completion:(void(^)(BOOL)) completion;
-(void)startRoom;

-(void)getInfoForRID:(NSString *)rid completion:(void(^)(NSNumber *betAmount, NSNumber *startTime, NSNumber *timeLimit)) completion;
@end
