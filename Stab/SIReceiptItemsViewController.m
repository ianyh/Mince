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
    SIReceiptItemsSectionAdd,
    SIReceiptItemsSectionReceipt,
    SIReceiptItemsSectionSubtotal,
    SIReceiptItemsSectionTax,
    SIReceiptItemsSectionTip,
    SIReceiptItemsSectionTotal,
} SIReceiptItemsSection;

static NSInteger SIReceiptItemsSectionCount = SIReceiptItemsSectionTotal + 1;

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

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.itemsTableView reloadData];
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.itemsTableView setEditing:editing animated:animated];
    [self.itemsTableView reloadSections:[NSIndexSet indexSetWithIndex:SIReceiptItemsSectionAdd]
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
    return SIReceiptItemsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ((SIReceiptItemsSection)section) {
        case SIReceiptItemsSectionAdd:
            return (self.itemsTableView.editing ? 1 : 0);
        case SIReceiptItemsSectionReceipt:
            return [self.receipt.items count];
        case SIReceiptItemsSectionSubtotal:
        case SIReceiptItemsSectionTax:
        case SIReceiptItemsSectionTip:
        case SIReceiptItemsSectionTotal:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
            return self.addReceiptEntryCell;

        case SIReceiptItemsSectionReceipt: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptTableViewCell"];
            [self configureCell:cell forIndexPath:indexPath];
            return cell;
        }

        case SIReceiptItemsSectionSubtotal: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptOverviewTableViewCell"];
            cell.textLabel.text = @"Subtotal";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[self.receipt subtotal] doubleValue]];
            return cell;
        }

        case SIReceiptItemsSectionTax: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptOverviewTableViewCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"Tax (%.0f%%)", [self.receipt.taxRate doubleValue] * 100];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[self.receipt tax] doubleValue]];
            return cell;
        }

        case SIReceiptItemsSectionTip: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptOverviewTableViewCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"Tip (%.0f%%)", [self.receipt.tipRate doubleValue] * 100];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[self.receipt tip] doubleValue]];
            return cell;
        }

        case SIReceiptItemsSectionTotal: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptOverviewTableViewCell"];
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[self.receipt total] doubleValue]];
            return cell;
        }
    }
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
    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
        case SIReceiptItemsSectionSubtotal:
        case SIReceiptItemsSectionTax:
        case SIReceiptItemsSectionTip:
        case SIReceiptItemsSectionTotal:
            return UITableViewCellEditingStyleNone;
        case SIReceiptItemsSectionReceipt:
            return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
        case SIReceiptItemsSectionSubtotal:
        case SIReceiptItemsSectionTax:
        case SIReceiptItemsSectionTip:
        case SIReceiptItemsSectionTotal:
            break;
        case SIReceiptItemsSectionReceipt: {
            SIReceiptItem *receiptItem = [self receiptItemForIndexPath:indexPath];
            [receiptItem deleteEntity];
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:NULL];
            break;
        }
    }}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
        case SIReceiptItemsSectionSubtotal:
        case SIReceiptItemsSectionTax:
        case SIReceiptItemsSectionTip:
        case SIReceiptItemsSectionTotal:
            [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
            return;
        case SIReceiptItemsSectionReceipt:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SIReceiptItem *item = [self receiptItemForIndexPath:indexPath];
    SIPerson *person = [self highlightedPerson];

    [person toggleSelectionForReceiptEntry:item];

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

        // Start a batch of updates
        [self.itemsTableView beginUpdates];

        // Insert a row in the table for the new receipt entry
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                    inSection:SIReceiptItemsSectionReceipt];
        [self.itemsTableView insertRowsAtIndexPaths:@[ indexPath ]
                                   withRowAnimation:UITableViewRowAnimationTop];

        // Reload all of the overview sections
        [self.itemsTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(SIReceiptItemsSectionSubtotal,
                                                                                               SIReceiptItemsSectionTotal - SIReceiptItemsSectionSubtotal)]
                           withRowAnimation:UITableViewRowAnimationAutomatic];

        [self.itemsTableView endUpdates];
        
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
        if (indexPath.section == SIReceiptItemsSectionReceipt) {
            [self configureCell:[self.itemsTableView cellForRowAtIndexPath:indexPath]
                   forIndexPath:indexPath];
        }
    }
}

@end
