//
//  SIPerson.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SIReceiptEntry;
@interface SIPerson : NSObject
@property (nonatomic, retain) NSString *name;

- (NSMutableSet *)selectedReceiptEntries;
- (void)toggleSelectionForReceiptEntry:(SIReceiptEntry *)receiptEntry;
@end
