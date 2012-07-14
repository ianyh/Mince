//
//  SIReceiptViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceiptViewController.h"

#import "SIPerson.h"
#import "SIReceipt.h"

typedef enum {
    SIReceiptViewControllerSectionAdd,
    SIReceiptViewControllerSectionReceipt,
    SIReceiptViewControllerSectionCount,
} SIReceiptViewControllerSection;

@interface SIReceiptViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableSet *selectedReceiptEntries;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end

@implementation SIReceiptViewController
@synthesize selectedPerson = _selectedPerson;
@synthesize selectedReceiptEntries = _selectedReceiptEntries;
@synthesize tableView = _tableView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectedReceiptEntries addObjectsFromArray:[[self.selectedPerson selectedReceiptEntries] allObjects]];
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
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
    return nil;
}

#pragma mark - UITableViewDelegate

@end
