//
//  SIAppDelegate.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIAppDelegate.h"

#import "SIReceiptViewController.h"

#import "SIReceipt.h"

static NSString *SIReceiptDefaultsKey = @"SIReceiptDefaultsKey";

@interface SIAppDelegate ()
@end

@implementation SIAppDelegate

+ (SIAppDelegate *)applicationDelegate {
    return (SIAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSData *receiptData = [NSUserDefaults.standardUserDefaults objectForKey:SIReceiptDefaultsKey];
    if (receiptData) {
        SIReceipt *receipt = [NSKeyedUnarchiver unarchiveObjectWithData:receiptData];
        [SIReceipt sharedReceipt];
        [SIReceipt setSharedReceipt:receipt];
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[SIReceiptViewController alloc] init]];

    self.window.rootViewController = navigationController;
    self.window.tintColor = [UIColor orangeColor];

    [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[SIReceipt sharedReceipt]];
    [NSUserDefaults.standardUserDefaults setObject:data forKey:SIReceiptDefaultsKey];
}

@end
