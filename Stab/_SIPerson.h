// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SIPerson.h instead.

#import <CoreData/CoreData.h>


extern const struct SIPersonAttributes {
	__unsafe_unretained NSString *name;
} SIPersonAttributes;

extern const struct SIPersonRelationships {
	__unsafe_unretained NSString *items;
	__unsafe_unretained NSString *receipts;
} SIPersonRelationships;

extern const struct SIPersonFetchedProperties {
} SIPersonFetchedProperties;

@class SIReceiptItem;
@class SIReceipt;



@interface SIPersonID : NSManagedObjectID {}
@end

@interface _SIPerson : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SIPersonID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;




@property (nonatomic, strong) NSSet *receipts;

- (NSMutableSet*)receiptsSet;





@end

@interface _SIPerson (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(SIReceiptItem*)value_;
- (void)removeItemsObject:(SIReceiptItem*)value_;

- (void)addReceipts:(NSSet*)value_;
- (void)removeReceipts:(NSSet*)value_;
- (void)addReceiptsObject:(SIReceipt*)value_;
- (void)removeReceiptsObject:(SIReceipt*)value_;

@end

@interface _SIPerson (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;



- (NSMutableSet*)primitiveReceipts;
- (void)setPrimitiveReceipts:(NSMutableSet*)value;


@end
