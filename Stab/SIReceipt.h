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

@interface SIReceipt : MTLModel
@property (nonatomic, strong) NSSet *items;
@property (nonatomic, strong) NSSet *people;
@property (nonatomic, strong) NSNumber *taxRate;
@property (nonatomic, strong) NSNumber *tipRate;

- (void)addPerson:(SIPerson *)person;
- (void)removePerson:(SIPerson *)person;

- (void)removeItem:(SIReceiptItem *)receiptItem;

// Always inserts at index 0
- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost;
// Inserts entries at the beginning of the list
- (void)addEntriesFromImageParsedString:(NSString *)imageParsedString;

- (void)removeAllEntries;

- (NSNumber *)subtotal;
- (NSNumber *)tax;
- (NSNumber *)tip;
- (NSNumber *)total;
@end
