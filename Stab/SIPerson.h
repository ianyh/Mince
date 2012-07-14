//
//  SIPerson.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIReceipt;
@interface SIPerson : NSObject
@property (nonatomic, retain) NSString *name;

- (NSMutableSet *)selectedReceiptEntries;
- (void)selectReceiptEntry:(SIReceipt *)receiptEntry;
- (void)unselectReceiptEntry:(SIReceipt *)receiptEntry;
@end
