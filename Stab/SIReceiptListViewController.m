//
//  SIReceiptsViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 2/16/13.
//
//

#import "SIReceiptListViewController.h"

#import "SIReceiptViewController.h"
#import "SIReceiptCreateViewController.h"

#import "SIReceipt.h"

@interface SIReceiptListViewController () <NSFetchedResultsControllerDelegate, SIReceiptCreateViewControllerDelegate>
@property (nonatomic, retain) NSFetchedResultsController *receiptsFetchedResultsController;

- (IBAction)cancelCreate:(UIStoryboardSegue *)segue;
- (IBAction)commitCreate:(UIStoryboardSegue *)segue;
@end

@implementation SIReceiptListViewController

- (void)dealloc {
    self.receiptsFetchedResultsController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.receiptsFetchedResultsController)
        self.receiptsFetchedResultsController = [SIReceipt fetchAllSortedBy:@"createdDate" ascending:NO withPredicate:[NSPredicate predicateWithValue:YES] groupBy:nil delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[SIReceiptViewController class]]) {
        SIReceiptViewController *receiptViewController = [segue destinationViewController];
        receiptViewController.receipt = [self.receiptsFetchedResultsController.fetchedObjects objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    } else if ([[segue destinationViewController] isKindOfClass:[SIReceiptCreateViewController class]]) {
        SIReceiptCreateViewController *createViewController = [segue destinationViewController];
        createViewController.delegate = self;
    }
}

#pragma mark - IBAction

- (IBAction)cancelCreate:(UIStoryboardSegue *)segue {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)commitCreate:(UIStoryboardSegue *)segue {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - SIReceiptCreateViewControllerDelegate

- (void)receiptCreateViewControllerDidFinish:(SIReceiptCreateViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.receiptsFetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIReceiptsTableViewCell" forIndexPath:indexPath];
    SIReceipt *receipt = self.receiptsFetchedResultsController.fetchedObjects[indexPath.row];

    cell.textLabel.text = receipt.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SIReceipt *receipt = self.receiptsFetchedResultsController.fetchedObjects[indexPath.row];
    [receipt deleteEntity];
}

@end
