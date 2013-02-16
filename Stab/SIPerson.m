//
//  SIPerson.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIPerson.h"

#import "SIReceiptItem.h"

@interface SIPerson ()
@end

@implementation SIPerson

- (NSNumber *)totalOwed {
    double totalOwed = 0.0;
    for (SIReceiptItem *item in self.items)
        totalOwed += [item.cost doubleValue] / [item.people count];
    return @(totalOwed);
}

- (void)toggleSelectionForReceiptEntry:(SIReceiptItem *)item {
    if ([self.items containsObject:item]) {
        [item removePeopleObject:self];
    } else {
        [item addPeopleObject:self];
    }
}

@end
