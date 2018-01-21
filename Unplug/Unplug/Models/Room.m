//
//  Room.m
//  Unplug
//
//  Created by Scott P. Chow on 1/20/18.
//  Copyright © 2018 sbhacks. All rights reserved.
//

#import "Room.h"

@implementation Room

-(instancetype) init:(FIRDataSnapshot *)snapshot {
    if(!self) {
        self = [Room new];
    }
    if(snapshot.value == [NSNull null]) {
        return NULL;
    }
    self.timeLimit = snapshot.value[@"timeLimit"];
    self.betAmount = snapshot.value[@"betAmount"];
    self.timeStart = snapshot.value[@"timeStart"];
    
    return self;
}
-(NSMutableDictionary *) toDict {
    NSDictionary *dict = @{
                           @"timeLimit" : self.timeLimit,
                           @"timeStart" : self.timeStart,
                           @"betAmount" : self.betAmount
                           };
    return [dict mutableCopy];
}

@end
