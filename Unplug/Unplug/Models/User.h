//
//  User.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface User : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *balance;
@property (nonatomic,strong) NSString *uid;

-(instancetype) init:(FIRDataSnapshot *)snapshot;
-(NSDictionary *) toDict;
@end
