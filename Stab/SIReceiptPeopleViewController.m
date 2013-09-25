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

@interface SIReceiptPeopleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *addPersonCell;
@end

@implementation SIReceiptPeopleViewController

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
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

#pragma mark - UITableViewDataSource

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

#pragma mark - UITableViewDelegate

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

#pragma mark - Private Methods

- (SIPerson *)personForIndexPath:(NSIndexPath *)indexPath {
    NSArray *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [SIReceipt.sharedReceipt.people sortedArrayUsingDescriptors:@[ nameSortDescriptor ]][indexPath.row];
}

@end
