//
//  SIReceiptItemsViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceiptItemsViewController.h"

#import "SIReceiptPersonCollectionViewCell.h"

#import "NSString+SIAdditions.h"
#import "SIPerson.h"
#import "SIReceipt.h"
#import "SIReceiptItem.h"

typedef enum {
    SIReceiptViewControllerSectionAdd,
    SIReceiptViewControllerSectionReceipt,
} SIReceiptViewControllerSection;

static NSInteger SIReceiptViewControllerSectionCount = SIReceiptViewControllerSectionReceipt + 1;

@interface SIReceiptItemsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

@property (strong, nonatomic) IBOutlet UICollectionView *peopleCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *addReceiptEntryCell;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *costTextField;

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SIReceiptItemsViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationItem.rightBarButtonItem = [self editButtonItem];

    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.itemsTableView reloadData];
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.itemsTableView setEditing:editing animated:animated];
    [self.itemsTableView reloadSections:[NSIndexSet indexSetWithIndex:SIReceiptViewControllerSectionAdd]
                       withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.receipt.people count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SIReceiptPersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SIReceiptCollectionViewCell" forIndexPath:indexPath];
    SIPerson *person = [self personForIndexPath:indexPath];

    cell.nameLabel.text = person.name;

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateTableCellCheckmarks];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateTableCellCheckmarks];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SIReceiptViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ((SIReceiptViewControllerSection)section) {
        case SIReceiptViewControllerSectionAdd:
            return (self.itemsTableView.editing ? 1 : 0);
        case SIReceiptViewControllerSectionReceipt:
            return [self.receipt.items count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SIReceiptViewControllerSectionAdd)
        return self.addReceiptEntryCell;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptTableViewCell"];

    [self configureCell:cell forIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    SIReceiptItem *receiptItem = [self receiptItemForIndexPath:indexPath];
    BOOL receiptItemIsSelected = [receiptItem.people containsObject:[self highlightedPerson]];

    cell.textLabel.text = receiptItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [receiptItem.cost doubleValue]];
    cell.accessoryType = (receiptItemIsSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SIReceiptViewControllerSectionAdd)
        return UITableViewCellEditingStyleNone;

    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SIReceiptItem *receiptItem = [self receiptItemForIndexPath:indexPath];
    [receiptItem deleteEntity];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:NULL];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SIReceiptItem *item = [self receiptItemForIndexPath:indexPath];
    SIPerson *person = [self highlightedPerson];

    // Toggle the association with the highlighted person.
    if ([item.people containsObject:person]) {
        [item removePeopleObject:person];
    } else {
        [item addPeopleObject:person];
    }

    // Reconfigure the cell to display the selection
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.costTextField) {
        NSString *updatedCostString = [self.costTextField.text stringByReplacingCharactersInRange:range withString:string];
        NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"1234567890"];
        [characterSet invert];
        updatedCostString = [updatedCostString stringByRemovingCharactersFromSet:characterSet];
        double updatedCost = [updatedCostString doubleValue] / 100.0;

        [self.currencyFormatter setLocale:[NSLocale currentLocale]];

        self.costTextField.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:updatedCost]];

        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.nameTextField resignFirstResponder];
        [self.costTextField becomeFirstResponder];
    } else {
        // Create and insert a receipt entry with the appropriate name
        [self.receipt addEntryWithName:self.nameTextField.text
                                  cost:[self.currencyFormatter numberFromString:self.costTextField.text]];

        // Insert a row in the table for the new receipt entry
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                    inSection:SIReceiptViewControllerSectionReceipt];
        [self.itemsTableView insertRowsAtIndexPaths:@[ indexPath ]
                                   withRowAnimation:UITableViewRowAnimationTop];
        
        // Clear the text in both text fields
        self.nameTextField.text = @"";
        self.costTextField.text = @"";

        [self.costTextField resignFirstResponder];
        [self.nameTextField becomeFirstResponder];
    }
    return NO;
}

#pragma mark - Private Methods

- (SIPerson *)personForIndexPath:(NSIndexPath *)indexPath {
    NSArray *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [self.receipt.people sortedArrayUsingDescriptors:@[ nameSortDescriptor ]][indexPath.row];
}

- (SIPerson *)highlightedPerson {
    CGPoint centerContentPoint = CGPointMake(self.peopleCollectionView.contentOffset.x + self.peopleCollectionView.center.x,
                                             self.peopleCollectionView.contentOffset.y + self.peopleCollectionView.center.y);
    NSIndexPath *indexPath = [self.peopleCollectionView indexPathForItemAtPoint:centerContentPoint];
    return [self personForIndexPath:indexPath];
}

- (SIReceiptItem *)receiptItemForIndexPath:(NSIndexPath *)indexPath {
    NSArray *createdDateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    return [self.receipt.items sortedArrayUsingDescriptors:@[ createdDateSortDescriptor ]][indexPath.row];
}

- (void)updateTableCellCheckmarks {
    for (NSIndexPath *indexPath in [self.itemsTableView indexPathsForVisibleRows]) {
        [self configureCell:[self.itemsTableView cellForRowAtIndexPath:indexPath]
               forIndexPath:indexPath];
    }
}

@end
