//
//  SIReceipt.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceipt.h"

#import "SIReceiptEntry.h"

@interface SIReceipt ()
@property (nonatomic, retain) NSMutableArray *internalReceiptEntries;
@end

@implementation SIReceipt
@synthesize internalReceiptEntries = _internalReceiptEntries;

+ (SIReceipt *)sharedReceipt {
    static dispatch_once_t onceToken;
    __strong static SIReceipt *sharedReceipt = nil;
    dispatch_once(&onceToken, ^{
        sharedReceipt = [[self alloc] init];
    });
    return sharedReceipt;
}

- (id)init {
    self = [super init];
    if (self) {
        self.internalReceiptEntries = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)receiptEntries {
    return [NSArray arrayWithArray:self.internalReceiptEntries];
}

- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost {
    SIReceiptEntry *receiptEntry = [[SIReceiptEntry alloc] init];
    receiptEntry.name = name;
    receiptEntry.cost = cost;
    [self.internalReceiptEntries insertObject:receiptEntry atIndex:0];
}

- (void)addEntriesFromImageParsedString:(NSString *)imageParsedString {
    
}

- (void)removeAllEntries {
    [self.internalReceiptEntries removeAllObjects];
}

@end
