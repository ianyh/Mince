// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIReceipt.h instead.

#import <CoreData/CoreData.h>


extern const struct SIReceiptAttributes {
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *name;
} SIReceiptAttributes;

extern const struct SIReceiptRelationships {
	__unsafe_unretained NSString *items;
} SIReceiptRelationships;

extern const struct SIReceiptFetchedProperties {
} SIReceiptFetchedProperties;

@class SIReceiptItem;




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





@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;





@end

@interface _SIReceipt (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(SIReceiptItem*)value_;
- (void)removeItemsObject:(SIReceiptItem*)value_;

@end

@interface _SIReceipt (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
