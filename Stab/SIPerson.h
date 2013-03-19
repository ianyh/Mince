//
//  SIPerson.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_SIPerson.h"

@class SIReceipt;
@class SIReceiptItem;
@interface SIPerson : _SIPerson
- (NSNumber *)totalOwedWithReceipt:(SIReceipt *)receipt;

- (void)toggleSelectionForReceiptEntry:(SIReceiptItem *)item;
@end
