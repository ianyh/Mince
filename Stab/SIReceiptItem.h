//
//  SIReceiptItem.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Mantle/Mantle.h>

@class SIPerson;
@class SIReceipt;

@interface SIReceiptItem : MTLModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *cost;

@property (nonatomic, weak) SIReceipt *receipt;
@property (nonatomic, strong) NSSet *people;

- (void)addPerson:(SIPerson *)person;
- (void)removePerson:(SIPerson *)person;

@end
