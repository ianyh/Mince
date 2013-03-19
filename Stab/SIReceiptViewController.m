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

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    self.navigationItem.rightBarButtonItem = [self editButtonItem];

    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:[SIReceiptItemsViewController class]]) {
            self.itemsViewController = (SIReceiptItemsViewController *)controller;
        } else if ([controller isKindOfClass:[SIReceiptPeopleViewController class]]) {
            self.peopleViewController = (SIReceiptPeopleViewController *)controller;
            self.peopleViewController.delegate = self;
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.selectedViewController setEditing:editing animated:animated];
}

#pragma mark - Public Methods

- (void)setReceipt:(SIReceipt *)receipt {
    if ([_receipt isEqual:receipt])
        return;

    _receipt = receipt;

    self.itemsViewController.receipt = _receipt;
    self.peopleViewController.receipt = _receipt;
}

#pragma mark - SIReceiptPeopleViewControllerDelegate

- (void)receiptPeopleViewController:(SIReceiptPeopleViewController *)controller didSelectPerson:(SIPerson *)person {
    self.selectedViewController = self.peopleViewController;
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self setEditing:NO animated:NO];
}

@end
