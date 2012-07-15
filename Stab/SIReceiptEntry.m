//
//  SIReceiptEntry.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceiptEntry.h"

@implementation SIReceiptEntry
@synthesize name = _name;
@synthesize cost = _cost;
@synthesize claimCount = _claimCount;

- (id)init {
    self = [super init];
    if (self) {
        self.claimCount = 0;
    }
    return self;
}

@end
