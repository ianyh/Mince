//
//  SIPerson.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIPerson.h"

#import "SIReceiptEntry.h"

@interface SIPerson ()
@property (nonatomic, retain) NSMutableSet *selectedReceiptEntries;
@end

@implementation SIPerson
@synthesize name = _name;
@synthesize selectedReceiptEntries = _selectedReceiptEntries;

- (id)init {
    self = [super init];
    if (self) {
        self.selectedReceiptEntries = [NSMutableSet set];
    }
    return self;
}

- (void)dealloc {
    for (SIReceiptEntry *entry in self.selectedReceiptEntries)
        entry.claimCount--;
}

- (NSNumber *)totalOwed {
    double totalOwed = 0.0;
    for (SIReceiptEntry *receiptEntry in self.selectedReceiptEntries)
        totalOwed += [receiptEntry.cost doubleValue] / receiptEntry.claimCount;
    return [NSNumber numberWithDouble:totalOwed];
}

- (void)toggleSelectionForReceiptEntry:(SIReceiptEntry *)receiptEntry {
    if ([self.selectedReceiptEntries containsObject:receiptEntry]) {
        receiptEntry.claimCount--;
        [self.selectedReceiptEntries removeObject:receiptEntry];
    } else {
        receiptEntry.claimCount++;
        [self.selectedReceiptEntries addObject:receiptEntry];
    }
}

@end
