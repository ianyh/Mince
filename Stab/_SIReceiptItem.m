// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIReceiptItem.m instead.

#import "_SIReceiptItem.h"

const struct SIReceiptItemAttributes SIReceiptItemAttributes = {
	.cost = @"cost",
	.createdDate = @"createdDate",
	.name = @"name",
};

const struct SIReceiptItemRelationships SIReceiptItemRelationships = {
	.people = @"people",
	.receipt = @"receipt",
};

const struct SIReceiptItemFetchedProperties SIReceiptItemFetchedProperties = {
};

@implementation SIReceiptItemID
@end

@implementation _SIReceiptItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SIReceiptItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SIReceiptItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SIReceiptItem" inManagedObjectContext:moc_];
}

- (SIReceiptItemID*)objectID {
	return (SIReceiptItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"costValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cost"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic cost;



- (double)costValue {
	NSNumber *result = [self cost];
	return [result doubleValue];
}

- (void)setCostValue:(double)value_ {
	[self setCost:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveCostValue {
	NSNumber *result = [self primitiveCost];
	return [result doubleValue];
}

- (void)setPrimitiveCostValue:(double)value_ {
	[self setPrimitiveCost:[NSNumber numberWithDouble:value_]];
}





@dynamic createdDate;






@dynamic name;






@dynamic people;

	
- (NSMutableSet*)peopleSet {
	[self willAccessValueForKey:@"people"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"people"];
  
	[self didAccessValueForKey:@"people"];
	return result;
}
	

@dynamic receipt;

	






@end
