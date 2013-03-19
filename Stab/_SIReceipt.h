// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIReceipt.h instead.

#import <CoreData/CoreData.h>


extern const struct SIReceiptAttributes {
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *taxRate;
	__unsafe_unretained NSString *tipRate;
} SIReceiptAttributes;

extern const struct SIReceiptRelationships {
	__unsafe_unretained NSString *items;
	__unsafe_unretained NSString *people;
} SIReceiptRelationships;

extern const struct SIReceiptFetchedProperties {
} SIReceiptFetchedProperties;

@class SIReceiptItem;
@class SIPerson;






@interface SIReceiptID : NSManagedObjectID {}
@end

@interface _SIReceipt : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SIReceiptID*)objectID;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* taxRate;



@property double taxRateValue;
- (double)taxRateValue;
- (void)setTaxRateValue:(double)value_;

//- (BOOL)validateTaxRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* tipRate;



@property double tipRateValue;
- (double)tipRateValue;
- (void)setTipRateValue:(double)value_;

//- (BOOL)validateTipRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;




@property (nonatomic, strong) NSSet *people;

- (NSMutableSet*)peopleSet;





@end

@interface _SIReceipt (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(SIReceiptItem*)value_;
- (void)removeItemsObject:(SIReceiptItem*)value_;

- (void)addPeople:(NSSet*)value_;
- (void)removePeople:(NSSet*)value_;
- (void)addPeopleObject:(SIPerson*)value_;
- (void)removePeopleObject:(SIPerson*)value_;

@end

@interface _SIReceipt (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveTaxRate;
- (void)setPrimitiveTaxRate:(NSNumber*)value;

- (double)primitiveTaxRateValue;
- (void)setPrimitiveTaxRateValue:(double)value_;




- (NSNumber*)primitiveTipRate;
- (void)setPrimitiveTipRate:(NSNumber*)value;

- (double)primitiveTipRateValue;
- (void)setPrimitiveTipRateValue:(double)value_;





- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;



- (NSMutableSet*)primitivePeople;
- (void)setPrimitivePeople:(NSMutableSet*)value;


@end
