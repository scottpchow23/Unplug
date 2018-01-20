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

@end
