//
//  SIReceiptsViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 2/16/13.
//
//

#import "SIReceiptListViewController.h"

#import "SIReceiptViewController.h"

#import "SIReceipt.h"

static NSString *SIMonthDayYearDateFormat = @"MM/dd/YYYY";
static NSString *SIHourMinuteMerdianDateFormat = @"hh:mm a";

@interface SIReceiptListViewController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *receiptsFetchedResultsController;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (IBAction)cancelCreate:(UIStoryboardSegue *)segue;
- (IBAction)commitCreate:(UIStoryboardSegue *)segue;
@end

@implementation SIReceiptListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MM/dd/YYYY"];
    }
}

- (void)dealloc {
    self.receiptsFetchedResultsController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (!self.receiptsFetchedResultsController)
//        self.receiptsFetchedResultsController = [SIReceipt fetchAllSortedBy:@"createdDate" ascending:NO withPredicate:[NSPredicate predicateWithValue:YES] groupBy:nil delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[SIReceiptViewController class]]) {
        SIReceiptViewController *receiptViewController = [segue destinationViewController];
        receiptViewController.receipt = self.receiptsFetchedResultsController.fetchedObjects[[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.receiptsFetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WSReceiptsViewControllerCell"];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SIReceipt *receipt = self.receiptsFetchedResultsController.fetchedObjects[indexPath.row];
}

@end
