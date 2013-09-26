//
//  SIPerson.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIPerson.h"

#import "SIReceiptItem.h"

@interface SIPerson () <MTLJSONSerializing>
@property (nonatomic, strong) NSArray *items;
@end

@implementation SIPerson

- (id)init {
    self = [super init];
    if (self) {
        self.items = @[];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"items": @"items",
             };
}

- (void)addItem:(SIReceiptItem *)item {
    if ([self.items containsObject:item]) return;

    self.items = [self.items arrayByAddingObject:item];
}

- (void)removeItem:(SIReceiptItem *)item {
    if (![self.items containsObject:item]) return;

    self.items = [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isEqual:item];
    }]];
}

- (void)toggleSelectionForReceiptItem:(SIReceiptItem *)item {
    if ([self.items containsObject:item]) {
        [item removePerson:self];
    } else {
        [item addPerson:self];
    }
}

@end
