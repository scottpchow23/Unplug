//
//  Room.h
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface Room : NSObject
@property NSNumber *timeLimit;
@property NSNumber *betAmount;
@property NSNumber *timeStart;
//@property NSArray *userAndTimeList;

-(instancetype) init:(FIRDataSnapshot *)snapshot;
-(NSMutableDictionary *) toDict;
@end
