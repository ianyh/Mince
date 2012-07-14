//
//  SIPerson.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIPerson.h"

#import "SIReceipt.h"

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

- (void)selectReceiptEntry:(SIReceipt *)receiptEntry {
    [self.selectedReceiptEntries addObject:receiptEntry];
}

- (void)unselectReceiptEntry:(SIReceipt *)receiptEntry {
    [self.selectedReceiptEntries removeObject:receiptEntry];
}

@end
