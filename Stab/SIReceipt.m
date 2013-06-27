//
//  SIReceipt.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceipt.h"

#import "SIReceiptItem.h"

@interface SIReceipt ()
@end

@implementation SIReceipt

+ (instancetype)sharedReceipt {
    static SIReceipt *sharedReceipt;
    @synchronized (SIReceipt.class) {
        if (!sharedReceipt) sharedReceipt = [[SIReceipt alloc] init];
        return sharedReceipt;
    }
}

#pragma mark People

#pragma mark Items

- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost {
    SIReceiptItem *receiptEntry = [[SIReceiptItem alloc] init];
    receiptEntry.name = name;
    receiptEntry.cost = cost;
    receiptEntry.receipt = self;
}

- (void)removeAllEntries {
    self.items = [NSSet set];
}

- (NSNumber *)subtotal {
    return [self.items valueForKeyPath:@"@sum.cost"];
}

- (NSNumber *)tax {
    return @([[self subtotal] doubleValue] * [self.taxRate doubleValue]);
}

- (NSNumber *)tip {
    return @([[self subtotal] doubleValue] * [self.tipRate doubleValue]);
}

- (NSNumber *)total {
    return @([[self subtotal] doubleValue] + [[self tax] doubleValue] + [[self tip] doubleValue]);
}

@end
