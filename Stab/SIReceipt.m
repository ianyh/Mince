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

- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost {
    SIReceiptItem *receiptEntry = [SIReceiptItem createEntity];
    receiptEntry.name = name;
    receiptEntry.cost = cost;
    [self addItemsObject:receiptEntry];
}

- (void)addEntriesFromImageParsedString:(NSString *)imageParsedString {
    NSLog(@"string: %@", imageParsedString);
    NSArray *parsedStringLines = [imageParsedString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in parsedStringLines) {
        NSString *trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmedLine length] == 0)
            continue;

        NSArray *splitLine = [trimmedLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Split line: %@", splitLine);
        NSString *costComponent = [splitLine lastObject];
        NSInteger size = [splitLine count];
        size -= 2;
        NSString *nameComponent = [[splitLine subarrayWithRange:NSMakeRange(0, MAX(0, size))] componentsJoinedByString:@" "];

        [self addEntryWithName:nameComponent cost:[NSNumber numberWithDouble:[costComponent doubleValue]]];
    }
}

- (void)removeAllEntries {
    self.items = [NSSet set];
}

@end
