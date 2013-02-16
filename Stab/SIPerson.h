//
//  SIPerson.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "_SIPerson.h"

@class SIReceiptItem;
@interface SIPerson : _SIPerson
- (NSNumber *)totalOwed;

- (void)toggleSelectionForReceiptEntry:(SIReceiptItem *)item;
@end
