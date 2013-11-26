//
//  SIReceiptViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 3/17/13.
//
//

#import "SIReceiptViewController.h"

#import "SIReceiptItemsViewController.h"
#import "SIReceiptPeopleViewController.h"

#import "SIReceipt.h"

@interface SIReceiptViewController () <SIReceiptPeopleViewControllerDelegate>
@property (strong, nonatomic) SIReceiptItemsViewController *itemsViewController;
@property (strong, nonatomic) SIReceiptPeopleViewController *peopleViewController;

- (IBAction)clearAllItems:(id)sender;
@end

@implementation SIReceiptViewController

- (id)init {
    self = [super initWithNibName:@"SIReceiptViewController" bundle:nil];
    if (self) {
        self.itemsViewController = [[SIReceiptItemsViewController alloc] init];
        self.peopleViewController = [[SIReceiptPeopleViewController alloc] init];

        self.peopleViewController.delegate = self;

        self.viewControllers = @[ self.itemsViewController, self.peopleViewController ];

        self.navigationItem.title = @"Mince";
        self.navigationItem.rightBarButtonItem = [self editButtonItem];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear Items"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@checkselector(self, clearAllItems:)];
    }
    return self;
}

#pragma mark UIViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if ([SIReceipt sharedReceipt].people.count == 0) {
        self.selectedViewController = self.peopleViewController;
    }
    [self.selectedViewController setEditing:editing animated:animated];
}

#pragma mark IBAction

- (IBAction)clearAllItems:(id)sender {
    [self.itemsViewController clearAllItems:sender];
}

#pragma mark SIReceiptPeopleViewControllerDelegate

- (void)receiptPeopleViewController:(SIReceiptPeopleViewController *)controller didSelectPerson:(SIPerson *)person {
    self.selectedViewController = self.peopleViewController;
}

#pragma mark UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self setEditing:NO animated:NO];
}

@end
