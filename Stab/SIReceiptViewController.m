//
//  SIReceiptViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceiptViewController.h"

#import "NSString+SIAdditions.h"
#import "SIPerson.h"
#import "SIReceipt.h"
#import "SIReceiptEntry.h"

typedef enum {
    SIReceiptViewControllerSectionAdd,
    SIReceiptViewControllerSectionReceipt,
    SIReceiptViewControllerSectionCount,
} SIReceiptViewControllerSection;

@interface SIReceiptViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, retain) NSNumberFormatter *currencyFormatter;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *addReceiptEntryCell;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *costTextField;

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SIReceiptViewController
@synthesize selectedPerson = _selectedPerson;
@synthesize currencyFormatter = _currencyFormatter;
@synthesize tableView = _tableView;
@synthesize addReceiptEntryCell = _addReceiptEntryCell;
@synthesize nameTextField = _nameTextField;
@synthesize costTextField = _costTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationItem.rightBarButtonItem = [self editButtonItem];

    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
    self.addReceiptEntryCell = nil;
    self.nameTextField.delegate = nil;
    self.nameTextField = nil;
    self.costTextField.delegate = nil;
    self.costTextField = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SIReceiptViewControllerSectionAdd]
                  withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SIReceiptViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SIReceiptViewControllerSectionAdd:
            return (self.tableView.editing ? 1 : 0);
        case SIReceiptViewControllerSectionReceipt:
            return [[[SIReceipt sharedReceipt] receiptEntries] count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SIReceiptViewControllerSectionAdd)
        return self.addReceiptEntryCell;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptTableViewCell"];

    [self configureCell:cell forIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    SIReceiptEntry *receiptEntry = [[[SIReceipt sharedReceipt] receiptEntries] objectAtIndex:indexPath.row];
    cell.textLabel.text = receiptEntry.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [receiptEntry.cost doubleValue]];

    if ([self.selectedPerson.selectedReceiptEntries containsObject:receiptEntry]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
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
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Toggle the selection of the receipt entry
    SIReceiptEntry *receiptEntry = [[[SIReceipt sharedReceipt] receiptEntries] objectAtIndex:indexPath.row];
    [self.selectedPerson toggleSelectionForReceiptEntry:receiptEntry];

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
        [[SIReceipt sharedReceipt] addEntryWithName:self.nameTextField.text
                                               cost:[self.currencyFormatter numberFromString:self.costTextField.text]];
        
        // Insert a row in the table for the new receipt entry
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                    inSection:SIReceiptViewControllerSectionReceipt];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationTop];
        
        // Clear the text in both text fields
        self.nameTextField.text = @"";
        self.costTextField.text = @"";

        [self.costTextField resignFirstResponder];
        [self.nameTextField becomeFirstResponder];
    }
    return NO;
}

@end
