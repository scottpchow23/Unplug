//
//  FirebaseHelper.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "FirebaseHelper.h"

static FirebaseHelper *sharedAPIWrapper;

@implementation FirebaseHelper

+(instancetype) sharedWrapper {
    if(!sharedAPIWrapper)
        sharedAPIWrapper = [[self alloc] init];
    
    return sharedAPIWrapper;
}

- (id) init {
    if (self = [super init]) {
        ref = [[FIRDatabase database] reference];   
    }
    
    return self;
}

-(void)getAndSetCurrentUser:(NSString *) uid {
    [self getUserWithUID:uid completion:^(User *user) {
        [self setCurrentUser:user];
    }];
}

-(void)getUserWithUID: (NSString *) uid completion: (void (^)(User *)) completion {
    FIRDatabaseReference *userRef = [[ref child:@"users"] child:uid];
    
    [userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        User *user = [[User alloc] init:snapshot];
        completion(user);
    }];
}

-(void)createUser:(User *)newUser {
    FIRDatabaseReference *userRef = [[ref child:@"users"] child:newUser.uid];
    [userRef setValue: [newUser toDict]];
}

-(void)setCurrentUser:(User *) user {
    currentUser = user;
}
-(User *)getCurrentUser {
    return currentUser;
}

-(void)handleLogin:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error completion:(void (^)(BOOL)) completion {
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
                completion(YES);
            }];
        }];
    } else {
        NSLog(@"%@", error.localizedDescription);
        completion(NO);
    }
}

-(void)setCurrentRID:(NSString *) rid {
    currentRID = rid;
}
-(NSString *)getCurrentRID {
    return currentRID;
}

-(void)createAndJoinRoom:(Room *) room completion:(void(^)(BOOL)) completion {
    FIRDatabaseReference *roomRef = [[ref child:@"rooms"] childByAutoId];
    NSMutableDictionary *values = [room toDict];
    NSDictionary *valueDict = @{currentUser.uid : @{@"name" : currentUser.name,
                                                    @"time" : @0}};
    [values setValue:valueDict forKey:@"users"];
    [roomRef setValue:values withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if(error == NULL) {
            [self setCurrentRID:ref.key];
            completion(YES);
        } else {
            NSLog(@"CREATE AND JOIN ERROR: %@", error.localizedDescription);
            completion(NO);
        }
    }];
    
}

-(void)joinRoomWithRID:(NSString *)rid completion:(void(^)(BOOL)) completion {
    FIRDatabaseReference *roomRef = [[[ref child:@"rooms"] child:rid] child:@"users"];
    NSDictionary *valueDict = @{currentUser.uid : @{@"name" : currentUser.name,
                                                    @"time" : @0}};
    __block NSString *blockRID = rid;
    [roomRef updateChildValues:valueDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if(error == NULL) {
            [self setCurrentRID:blockRID];
            completion(YES);
        } else {
            NSLog(@"CREATE AND JOIN ERROR: %@", error.localizedDescription);
            completion(NO);
        }
    }];
}

-(void)startRoom {
    NSNumber *timestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    FIRDatabaseReference *roomRef = [[ref child:@"rooms"] child:self.getCurrentRID];
    [roomRef updateChildValues:@{
                                 @"timeStart":timestamp
                                 }];
}

-(void)getBetAmountForRID:(NSString *)rid completion:(void(^)(NSNumber *betAmount)) completion {
    FIRDatabaseReference *roomRef = [[ref child:@"rooms"] child:rid];
    [roomRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(![snapshot.value isEqual:[NSNull null]]) {
            NSNumber *betAmount = snapshot.value[@"betAmount"];
            completion(betAmount);
        }
    }];
}

@end
