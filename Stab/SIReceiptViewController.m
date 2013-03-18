//
//  SIReceiptViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 3/17/13.
//
//

#import "SIReceiptViewController.h"

#import "SIReceiptItemsViewController.h"

#import "SIReceipt.h"

@interface SIReceiptViewController ()
@property (nonatomic, retain) SIReceiptItemsViewController *itemsViewController;
@end

@implementation SIReceiptViewController

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    self.navigationItem.rightBarButtonItem = [self editButtonItem];

    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:[SIReceiptItemsViewController class]]) {
            self.itemsViewController = (SIReceiptItemsViewController *)controller;
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
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self setEditing:NO animated:NO];
    [super tabBar:tabBar didSelectItem:item];
}

@end
