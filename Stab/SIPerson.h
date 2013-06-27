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

#pragma mark Items

@property (nonatomic, strong, readonly) NSArray *items;

- (void)addItem:(SIReceiptItem *)item;
- (void)removeItem:(SIReceiptItem *)item;

- (void)toggleSelectionForReceiptItem:(SIReceiptItem *)item;

@end
