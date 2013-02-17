//
//  SIReceiptCreateViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 2/16/13.
//
//

#import "SIReceiptCreateViewController.h"

#import "SIPerson.h"
#import "SIReceipt.h"

typedef enum {
    SIReceiptCreateSectionAdd,
    SIReceiptCreateSectionPeople,
} SIReceiptCreateSection;

static NSInteger SIReceiptCreateSectionCount = SIReceiptCreateSectionPeople + 1;

@interface SIReceiptCreateViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, retain) NSManagedObjectContext *temporaryContext;

@property (nonatomic, retain) SIReceipt *receipt;
@property (nonatomic, retain) NSMutableArray *people;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *addPersonCell;
@end

@implementation SIReceiptCreateViewController

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    if (!self.temporaryContext) {
        self.temporaryContext = [NSManagedObjectContext contextWithParent:[NSManagedObjectContext defaultContext]];

        self.receipt = [SIReceipt createInContext:self.temporaryContext];
        self.receipt.name = @"receipt";

        self.people = [NSMutableArray array];
    }
}

#pragma mark - Public Methods

- (void)commitChanges {
    self.receipt.createdDate = [NSDate date];
    [self.temporaryContext saveToPersistentStoreWithCompletion:NULL];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SIReceiptCreateSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ((SIReceiptCreateSection)section) {
        case SIReceiptCreateSectionAdd:
            return 1;
        case SIReceiptCreateSectionPeople:
            return [self.people count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SIReceiptCreateSectionAdd)
        return self.addPersonCell;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptCreateTableViewCell"];
    SIPerson *person = self.people[indexPath.row];
    
    cell.textLabel.text = person.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SIReceiptCreateSectionAdd)
        return UITableViewCellEditingStyleNone;
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.people removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Create and insert a person with the appropriate name
    SIPerson *person = [SIPerson createInContext:self.temporaryContext];

    person.name = textField.text;
    [person addReceiptsObject:self.receipt];

    [self.people insertObject:person atIndex:0];

    // Insert a row in the table for the new person
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:SIReceiptCreateSectionPeople];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];

    // Clear the text in the text field
    textField.text = @"";
    
    return NO;
}

@end

