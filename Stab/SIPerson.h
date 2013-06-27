//
//  SIPerson.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Mantle/Mantle.h>

@class SIReceipt;
@class SIReceiptItem;
@interface SIPerson : MTLModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSSet *items;

- (NSNumber *)totalOwedWithReceipt:(SIReceipt *)receipt;

- (void)toggleSelectionForReceiptEntry:(SIReceiptItem *)item;
@end
