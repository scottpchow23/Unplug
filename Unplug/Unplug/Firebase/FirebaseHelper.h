//
//  FirebaseHelper.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "User.h"

@interface FirebaseHelper : NSObject {
    User *currentUser;
    @private FIRDatabaseReference* ref;
}


+(instancetype) sharedWrapper;

-(void)getUserWithUID: (NSString *) uid completion: (void (^)(User *)) completion;
-(void)createUser:(User *)newUser;

-(void)setCurrentUser:(User *) user;
-(User *)getCurrentUser;
@end
