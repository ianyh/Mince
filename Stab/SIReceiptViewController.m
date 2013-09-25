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
@end

@implementation SIReceiptViewController

- (id)init {
    self = [super initWithNibName:@"SIReceiptViewController" bundle:nil];
    if (self) {
        SIReceiptItemsViewController *itemsViewController = [[SIReceiptItemsViewController alloc] init];
        SIReceiptPeopleViewController *peopleViewController = [[SIReceiptPeopleViewController alloc] init];

        peopleViewController.delegate = self;

        self.viewControllers = @[ itemsViewController, peopleViewController ];

        self.navigationItem.title = @"Mince";
        self.navigationItem.rightBarButtonItem = [self editButtonItem];
    }
    return self;
}

#pragma mark UIViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.selectedViewController setEditing:editing animated:animated];
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
