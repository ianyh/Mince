//
//  SIReceipt.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_SIReceipt.h"

@interface SIReceipt : _SIReceipt
// Always inserts at index 0
- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost;
// Inserts entries at the beginning of the list
- (void)addEntriesFromImageParsedString:(NSString *)imageParsedString;

- (void)removeAllEntries;

- (NSNumber *)subtotal;
- (NSNumber *)tax;
- (NSNumber *)total;
@end
