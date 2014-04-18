//
//  SIReceipt.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Mantle/Mantle.h>

@class SIPerson;
@class SIReceiptItem;

@interface SIReceipt : MTLModel <MTLJSONSerializing>

+ (SIReceipt *)sharedReceipt;
+ (void)setSharedReceipt:(SIReceipt *)receipt;

#pragma mark People

@property (nonatomic, strong, readonly) NSArray *people;

- (void)addPerson:(SIPerson *)person;
- (void)removePerson:(SIPerson *)person;

#pragma mark Items

@property (nonatomic, strong, readonly) NSArray *items;

- (void)addItem:(SIReceiptItem *)item;
- (void)removeItem:(SIReceiptItem *)item;

- (void)addEntriesFromReceiptPhoto:(UIImage *)photo withCompletion:(dispatch_block_t)completion;
- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost;
- (void)removeAllEntries;

#pragma mark Values

@property (nonatomic, strong) NSNumber *taxRate;
@property (nonatomic, strong) NSNumber *tipRate;

- (NSNumber *)subtotal;
- (NSNumber *)tax;
- (NSNumber *)tip;
- (NSNumber *)total;
- (NSNumber *)totalForPerson:(SIPerson *)person;

@end
