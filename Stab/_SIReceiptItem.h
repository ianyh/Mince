// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIReceiptItem.h instead.

#import <CoreData/CoreData.h>


extern const struct SIReceiptItemAttributes {
	__unsafe_unretained NSString *cost;
	__unsafe_unretained NSString *name;
} SIReceiptItemAttributes;

extern const struct SIReceiptItemRelationships {
	__unsafe_unretained NSString *people;
	__unsafe_unretained NSString *receipt;
} SIReceiptItemRelationships;

extern const struct SIReceiptItemFetchedProperties {
} SIReceiptItemFetchedProperties;

@class SIPerson;
@class SIReceipt;




@interface SIReceiptItemID : NSManagedObjectID {}
@end

@interface _SIReceiptItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SIReceiptItemID*)objectID;





@property (nonatomic, strong) NSNumber* cost;



@property double costValue;
- (double)costValue;
- (void)setCostValue:(double)value_;

//- (BOOL)validateCost:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *people;

- (NSMutableSet*)peopleSet;




@property (nonatomic, strong) SIReceipt *receipt;

//- (BOOL)validateReceipt:(id*)value_ error:(NSError**)error_;





@end

@interface _SIReceiptItem (CoreDataGeneratedAccessors)

- (void)addPeople:(NSSet*)value_;
- (void)removePeople:(NSSet*)value_;
- (void)addPeopleObject:(SIPerson*)value_;
- (void)removePeopleObject:(SIPerson*)value_;

@end

@interface _SIReceiptItem (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCost;
- (void)setPrimitiveCost:(NSNumber*)value;

- (double)primitiveCostValue;
- (void)setPrimitiveCostValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitivePeople;
- (void)setPrimitivePeople:(NSMutableSet*)value;



- (SIReceipt*)primitiveReceipt;
- (void)setPrimitiveReceipt:(SIReceipt*)value;


@end
