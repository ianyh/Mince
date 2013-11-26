//
//  SIReceiptItemsViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceiptItemsViewController.h"

#import "SIReceiptPersonCollectionViewCell.h"
#import "SITaxRatePickerView.h"
#import "SITipRatePickerView.h"

#import "NSString+SIAdditions.h"
#import "SIPerson.h"
#import "SIReceipt.h"
#import "SIReceiptItem.h"

typedef NS_ENUM(NSInteger, SIReceiptItemsSection) {
    SIReceiptItemsSectionAdd,
    SIReceiptItemsSectionReceipt,
    SIReceiptItemsSectionSummary,
};

typedef NS_ENUM(NSInteger, SIReceiptItemSectionSummaryRow) {
    SIReceiptItemSectionSummaryRowSubtotal,
    SIReceiptItemSectionSummaryRowTax,
    SIReceiptItemSectionSummaryRowTip,
    SIReceiptItemSectionSummaryRowTotal,
};

static NSInteger SIReceiptItemsSectionCount = SIReceiptItemsSectionSummary + 1;
static NSInteger SIReceiptItemsSectionSummaryRowCount = SIReceiptItemSectionSummaryRowTotal + 1;

@interface SIReceiptItemsViewController () <SITaxRatePickerViewDelegate, SITipRatePickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

@property (strong, nonatomic) IBOutlet UICollectionView *peopleCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *addReceiptEntryCell;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *costTextField;

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SIReceiptItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currencyFormatter = [[NSNumberFormatter alloc] init];
        [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Items" image:nil tag:0];
    }
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.peopleCollectionView registerNib:[UINib nibWithNibName:@"SIReceiptPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SIReceiptCollectionViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.peopleCollectionView reloadData];
    [self.itemsTableView reloadData];
}

#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.itemsTableView setEditing:editing animated:animated];
    [self.itemsTableView reloadSections:[NSIndexSet indexSetWithIndex:SIReceiptItemsSectionAdd]
                       withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark SITaxRatePickerViewDelegate

- (void)taxRatePicker:(SITaxRatePickerView *)picker didFinishWithTaxRate:(NSNumber *)number {
    SIReceipt.sharedReceipt.taxRate = number;
    [self.itemsTableView reloadData];
}

#pragma mark SITipRatePickerViewDelegate

- (void)tipRatePicker:(SITipRatePickerView *)picker didFinishWithTipRate:(NSNumber *)number {
    SIReceipt.sharedReceipt.tipRate = number;
    [self.itemsTableView reloadData];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [SIReceipt.sharedReceipt.people count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SIReceiptPersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SIReceiptCollectionViewCell" forIndexPath:indexPath];
    SIPerson *person = [self personForIndexPath:indexPath];

    cell.nameLabel.text = person.name;

    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateTableCellCheckmarks];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateTableCellCheckmarks];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SIReceiptItemsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ((SIReceiptItemsSection)section) {
        case SIReceiptItemsSectionAdd:
            return (self.editing ? 1 : 0);
        case SIReceiptItemsSectionReceipt:
            return SIReceipt.sharedReceipt.items.count;
        case SIReceiptItemsSectionSummary:
            return SIReceiptItemsSectionSummaryRowCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
            return self.addReceiptEntryCell;

        case SIReceiptItemsSectionReceipt: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptTableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SIReceiptTableViewCell"];
                cell.detailTextLabel.textColor = cell.textLabel.textColor;
            }

            [self configureCell:cell forIndexPath:indexPath];
            return cell;
        }

        case SIReceiptItemsSectionSummary: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptOverviewTableViewCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SIReceiptOverviewTableViewCell"];
                cell.textLabel.textColor = cell.detailTextLabel.textColor;
            }

            switch ((SIReceiptItemSectionSummaryRow)indexPath.row) {
                case SIReceiptItemSectionSummaryRowSubtotal: {
                    cell.textLabel.text = @"Subtotal";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[SIReceipt.sharedReceipt subtotal] doubleValue]];
                    return cell;
                }

                case SIReceiptItemSectionSummaryRowTax: {
                    cell.textLabel.text = [NSString stringWithFormat:@"Tax (%.3f%%)", [SIReceipt.sharedReceipt.taxRate doubleValue] * 100];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[SIReceipt.sharedReceipt tax] doubleValue]];
                    return cell;
                }

                case SIReceiptItemSectionSummaryRowTip: {
                    cell.textLabel.text = [NSString stringWithFormat:@"Tip (%.0f%%)", [SIReceipt.sharedReceipt.tipRate doubleValue] * 100];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[SIReceipt.sharedReceipt tip] doubleValue]];
                    return cell;
                }

                case SIReceiptItemSectionSummaryRowTotal: {
                    cell.textLabel.text = @"Total";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [[SIReceipt.sharedReceipt total] doubleValue]];
                    return cell;
                }
            }
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

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
        case SIReceiptItemsSectionSummary:
            return UITableViewCellEditingStyleNone;
        case SIReceiptItemsSectionReceipt:
            return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
        case SIReceiptItemsSectionSummary:
            break;
        case SIReceiptItemsSectionReceipt: {
            SIReceiptItem *receiptItem = [self receiptItemForIndexPath:indexPath];
            [SIReceipt.sharedReceipt removeItem:receiptItem];
            [self.itemsTableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch ((SIReceiptItemsSection)indexPath.section) {
        case SIReceiptItemsSectionAdd:
            return;
        case SIReceiptItemsSectionSummary: {
            switch ((SIReceiptItemSectionSummaryRow)indexPath.row) {
                case SIReceiptItemSectionSummaryRowSubtotal:
                case SIReceiptItemSectionSummaryRowTotal:
                    break;
                case SIReceiptItemSectionSummaryRowTax: {
                    SITaxRatePickerView *pickerView = [[SITaxRatePickerView alloc] init];
                    pickerView.delegate = self;
                    [pickerView display];
                    break;
                }
                case SIReceiptItemSectionSummaryRowTip: {
                    SITipRatePickerView *pickerView = [[SITipRatePickerView alloc] init];
                    pickerView.delegate = self;
                    [pickerView display];
                    break;
                }
            }
            return;
        }
        case SIReceiptItemsSectionReceipt: {
            SIReceiptItem *item = [self receiptItemForIndexPath:indexPath];
            SIPerson *person = [self highlightedPerson];

            [person toggleSelectionForReceiptItem:item];

            // Reconfigure the cell to display the selection
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell forIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark UITextFieldDelegate

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
        [SIReceipt.sharedReceipt addEntryWithName:self.nameTextField.text
                                             cost:[self.currencyFormatter numberFromString:self.costTextField.text]];

        // Start a batch of updates
        [self.itemsTableView beginUpdates];

        // Insert a row in the table for the new receipt entry
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                    inSection:SIReceiptItemsSectionReceipt];
        [self.itemsTableView insertRowsAtIndexPaths:@[ indexPath ]
                                   withRowAnimation:UITableViewRowAnimationTop];

        // Reload all of the overview sections
        [self.itemsTableView reloadSections:[NSIndexSet indexSetWithIndex:SIReceiptItemsSectionSummary]
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

#pragma mark Private Methods

- (SIPerson *)personForIndexPath:(NSIndexPath *)indexPath {
    NSArray *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [SIReceipt.sharedReceipt.people sortedArrayUsingDescriptors:@[ nameSortDescriptor ]][indexPath.row];
}

- (SIPerson *)highlightedPerson {
    CGPoint centerContentPoint = CGPointMake(self.peopleCollectionView.contentOffset.x + self.peopleCollectionView.center.x,
                                             self.peopleCollectionView.contentOffset.y + self.peopleCollectionView.center.y);
    NSIndexPath *indexPath = [self.peopleCollectionView indexPathForItemAtPoint:centerContentPoint];
    return [self personForIndexPath:indexPath];
}

- (SIReceiptItem *)receiptItemForIndexPath:(NSIndexPath *)indexPath {
    return SIReceipt.sharedReceipt.items[indexPath.row];
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
