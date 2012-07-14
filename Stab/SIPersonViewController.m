//
//  SIViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIPersonViewController.h"

#import "SIPerson.h"

typedef enum {
    SIPersonViewControllerSectionAdd,
    SIPersonViewControllerSectionPeople,
    SIPersonViewControllerSectionCount
} SIPersonViewControllerSection;

@interface SIPersonViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *addPersonCell;

@property (nonatomic, retain) NSMutableArray *people;
@end

@implementation SIPersonViewController
@synthesize tableView = _tableView;
@synthesize addPersonCell = _addPersonCell;
@synthesize people = _people;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    self.people = [NSMutableArray array];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView = nil;
    self.addPersonCell = nil;
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SIPersonViewControllerSectionAdd]
                  withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - UITableViewDataSource
                                    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SIPersonViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SIPersonViewControllerSectionAdd:
            return (self.tableView.editing ? 1 : 0);
        case SIPersonViewControllerSectionPeople:
            return [self.people count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SIPersonViewControllerSectionAdd)
        return self.addPersonCell;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIPersonTableViewCell"];
    SIPerson *person = [self.people objectAtIndex:indexPath.row];

    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = nil;

    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SIPersonViewControllerSectionAdd)
        return UITableViewCellEditingStyleNone;

    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.people removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Create and insert a person with the appropriate name
    SIPerson *person = [[SIPerson alloc] init];
    person.name = textField.text;
    [self.people insertObject:person atIndex:0];

    // Insert a row in the table for the new person
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:SIPersonViewControllerSectionPeople];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];

    // Clear the text in the text field
    textField.text = @"";

    return NO;
}

@end
