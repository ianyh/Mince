// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIReceipt.m instead.

#import "_SIReceipt.h"

const struct SIReceiptAttributes SIReceiptAttributes = {
	.createdDate = @"createdDate",
	.name = @"name",
};

const struct SIReceiptRelationships SIReceiptRelationships = {
	.items = @"items",
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
	

	return keyPaths;
}




@dynamic createdDate;






@dynamic name;






@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	






@end
