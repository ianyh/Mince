//
//  SIReceiptViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceiptViewController.h"

@interface SIReceiptViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end

@implementation SIReceiptViewController
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

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

@end
