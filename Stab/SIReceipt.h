//
//  SIReceipt.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIReceipt : NSObject
+ (SIReceipt *)sharedReceipt;

- (NSArray *)receiptEntries;
- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost;
- (void)addEntriesFromImageParsedString:(NSString *)imageParsedString;
- (void)removeAllEntries;
@end
