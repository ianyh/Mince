//
//  SIPerson.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIPerson.h"

#import "SIReceipt.h"
#import "SIReceiptItem.h"

@interface SIPerson ()
@end

@implementation SIPerson

- (NSNumber *)totalOwedWithReceipt:(SIReceipt *)receipt {
    double totalOwed = 0.0;

    NSMutableSet *items = [NSMutableSet setWithSet:self.items];
    [items intersectSet:receipt.items];

    for (SIReceiptItem *item in items) {
        totalOwed += [item.cost doubleValue] / [item.people count];
    }

    totalOwed += [[receipt tax] doubleValue] / [receipt.people count];
    totalOwed += [[receipt tip] doubleValue] / [receipt.people count];

    return @(totalOwed);
}

- (void)toggleSelectionForReceiptEntry:(SIReceiptItem *)item {
    if ([self.items containsObject:item]) {
        [item removePeopleObject:self];
    } else {
        [item addPeopleObject:self];
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:NULL];
}

@end
