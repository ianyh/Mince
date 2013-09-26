//
//  SIReceiptItem.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Mantle/Mantle.h>

@class SIPerson;

@interface SIReceiptItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *cost;

#pragma mark People

@property (nonatomic, strong, readonly) NSArray *people;

- (void)addPerson:(SIPerson *)person;
- (void)removePerson:(SIPerson *)person;

@end
