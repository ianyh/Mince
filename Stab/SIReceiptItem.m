//
//  SIReceiptItem.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceiptItem.h"

@interface SIReceiptItem ()
@property (nonatomic, strong) NSArray *people;
@end

@implementation SIReceiptItem

#pragma mark Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        self.people = @[];
    }
    return self;
}

#pragma mark People

- (void)addPerson:(SIPerson *)person {
    if ([self.people containsObject:person]) return;

    self.people = [self.people arrayByAddingObject:person];
}

- (void)removePerson:(SIPerson *)person {
    if (![self.people containsObject:person]) return;

    self.people = [self.people filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isEqual:person];
    }]];
}

@end
