//
//  SIReceiptPeopleViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 3/18/13.
//
//

#import "SIReceiptPeopleViewController.h"

#import "SIPerson.h"
#import "SIReceipt.h"

typedef NS_ENUM(NSInteger, SIReceiptPeopleSection) {
    SIReceiptPeopleSectionAdd,
    SIReceiptPeopleSectionPeople,
};

static NSInteger SIReceiptPeopleSectionCount = SIReceiptPeopleSectionPeople + 1;

@interface SIReceiptPeopleViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSNumberFormatter *currencyFormatter;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UITableViewCell *addPersonCell;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@end

@implementation SIReceiptPeopleViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SIReceiptPeopleSectionAdd]
                       withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SIReceiptPeopleSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ((SIReceiptPeopleSection)section) {
        case SIReceiptPeopleSectionAdd:
            return (self.tableView.editing ? 1 : 0);
        case SIReceiptPeopleSectionPeople:
            return [SIReceipt.sharedReceipt.people count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptPeopleSection)indexPath.section) {
        case SIReceiptPeopleSectionAdd:
            return self.addPersonCell;

        case SIReceiptPeopleSectionPeople: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptPeopleTableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SIReceiptPeopleTableViewCell"];
            }

            [self configureCell:cell forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    SIPerson *person = [self personForIndexPath:indexPath];
    
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[SIReceipt.sharedReceipt totalForPerson:person] doubleValue]];
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptPeopleSection)indexPath.section) {
        case SIReceiptPeopleSectionAdd:
            return UITableViewCellEditingStyleNone;
        case SIReceiptPeopleSectionPeople:
            return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptPeopleSection)indexPath.section) {
        case SIReceiptPeopleSectionAdd:
            break;
        case SIReceiptPeopleSectionPeople: {
            SIPerson *person = [self personForIndexPath:indexPath];
            [SIReceipt.sharedReceipt removePerson:person];
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptPeopleSection)indexPath.section) {
        case SIReceiptPeopleSectionAdd:
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        case SIReceiptPeopleSectionPeople:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SIPerson *person = [self personForIndexPath:indexPath];
    [self.delegate receiptPeopleViewController:self didSelectPerson:person];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    SIPerson *person = [[SIPerson alloc] init];
    person.name = textField.text;

    [SIReceipt.sharedReceipt addPerson:person];

    // Start a batch of updates
    [self.tableView beginUpdates];

    // Insert a row in the table for the new receipt entry
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:SIReceiptPeopleSectionPeople];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationTop];

    [self.tableView endUpdates];

    // Clear the text in both text fields
    self.nameTextField.text = @"";

    return NO;
}

#pragma mark Private Methods

- (SIPerson *)personForIndexPath:(NSIndexPath *)indexPath {
    NSArray *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [SIReceipt.sharedReceipt.people sortedArrayUsingDescriptors:@[ nameSortDescriptor ]][indexPath.row];
}

@end
