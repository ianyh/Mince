// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIReceipt.m instead.

#import "_SIReceipt.h"

const struct SIReceiptAttributes SIReceiptAttributes = {
	.createdDate = @"createdDate",
	.name = @"name",
	.taxRate = @"taxRate",
	.tipRate = @"tipRate",
};

const struct SIReceiptRelationships SIReceiptRelationships = {
	.items = @"items",
	.people = @"people",
};

const struct SIReceiptFetchedProperties SIReceiptFetchedProperties = {
};

@implementation SIReceiptID
@end

@implementation _SIReceipt

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SIReceipt" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SIReceipt";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SIReceipt" inManagedObjectContext:moc_];
}

- (SIReceiptID*)objectID {
	return (SIReceiptID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"taxRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"taxRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"tipRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tipRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdDate;






@dynamic name;






@dynamic taxRate;



- (double)taxRateValue {
	NSNumber *result = [self taxRate];
	return [result doubleValue];
}

- (void)setTaxRateValue:(double)value_ {
	[self setTaxRate:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveTaxRateValue {
	NSNumber *result = [self primitiveTaxRate];
	return [result doubleValue];
}

- (void)setPrimitiveTaxRateValue:(double)value_ {
	[self setPrimitiveTaxRate:[NSNumber numberWithDouble:value_]];
}





@dynamic tipRate;



- (double)tipRateValue {
	NSNumber *result = [self tipRate];
	return [result doubleValue];
}

- (void)setTipRateValue:(double)value_ {
	[self setTipRate:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveTipRateValue {
	NSNumber *result = [self primitiveTipRate];
	return [result doubleValue];
}

- (void)setPrimitiveTipRateValue:(double)value_ {
	[self setPrimitiveTipRate:[NSNumber numberWithDouble:value_]];
}





@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	

@dynamic people;

	
- (NSMutableSet*)peopleSet {
	[self willAccessValueForKey:@"people"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"people"];
  
	[self didAccessValueForKey:@"people"];
	return result;
}
	






@end
