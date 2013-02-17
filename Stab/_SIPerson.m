// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIPerson.m instead.

#import "_SIPerson.h"

const struct SIPersonAttributes SIPersonAttributes = {
	.name = @"name",
};

const struct SIPersonRelationships SIPersonRelationships = {
	.items = @"items",
	.receipts = @"receipts",
};

const struct SIPersonFetchedProperties SIPersonFetchedProperties = {
};

@implementation SIPersonID
@end

@implementation _SIPerson

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SIPerson" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SIPerson";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SIPerson" inManagedObjectContext:moc_];
}

- (SIPersonID*)objectID {
	return (SIPersonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	

@dynamic receipts;

	
- (NSMutableSet*)receiptsSet {
	[self willAccessValueForKey:@"receipts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"receipts"];
  
	[self didAccessValueForKey:@"receipts"];
	return result;
}
	






@end
