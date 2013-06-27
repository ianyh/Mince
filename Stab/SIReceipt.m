//
//  SIReceipt.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceipt.h"

#import "SIPerson.h"
#import "SIReceiptItem.h"

@interface SIReceipt ()
@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SIReceipt

+ (instancetype)sharedReceipt {
    static SIReceipt *sharedReceipt;
    @synchronized (SIReceipt.class) {
        if (!sharedReceipt) sharedReceipt = [[SIReceipt alloc] init];
        return sharedReceipt;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.people = @[];
        self.items = @[];
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

    for (SIReceiptItem *item in self.items) {
        [item removePerson:person];
    }

    self.people = [self.people filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isEqual:person];
    }]];
}

#pragma mark Items

- (void)addItem:(SIReceiptItem *)item {
    if ([self.items containsObject:item]) return;

    self.items = [self.items arrayByAddingObject:item];
}

- (void)removeItem:(SIReceiptItem *)item {
    if (![self.items containsObject:item]) return;

    for (SIPerson *person in self.people) {
        [person removeItem:item];
    }

    self.items = [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isEqual:item];
    }]];
}

- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost {
    SIReceiptItem *item = [[SIReceiptItem alloc] init];

    item.name = name;
    item.cost = cost;

    [self addItem:item];
}

- (void)removeAllEntries {
    for (SIReceiptItem *item in [self.items copy]) {
        [self removeItem:item];
    }
}

#pragma mark Values

- (NSNumber *)subtotal {
    return [self.items valueForKeyPath:@"@sum.cost"];
}

- (NSNumber *)tax {
    return @( self.subtotal.doubleValue * self.taxRate.doubleValue );
}

- (NSNumber *)tip {
    return @( self.subtotal.doubleValue * self.tipRate.doubleValue );
}

- (NSNumber *)total {
    return @( self.subtotal.doubleValue + self.tax.doubleValue + self.tip.doubleValue );
}

- (NSNumber *)totalForPerson:(SIPerson *)person {
    double totalOwed = 0.0;

    for (SIReceiptItem *item in person.items) {
        totalOwed += item.cost.doubleValue / item.people.count;
    }

    totalOwed += self.tax.doubleValue / self.people.count;
    totalOwed += self.tip.doubleValue / self.people.count;

    return @( totalOwed );
}

@end
