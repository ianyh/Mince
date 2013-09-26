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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSDictionary *receiptJSON = [NSUserDefaults.standardUserDefaults objectForKey:SIReceiptDefaultsKey];
//    if (receiptJSON) {
//        SIReceipt *receipt = [[SIReceipt alloc] initWithDictionary:receiptJSON error:nil];
//        [SIReceipt setSharedReceipt:receipt];
//    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[SIReceiptViewController alloc] init]];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    NSDictionary *receiptJSON = [MTLJSONAdapter JSONDictionaryFromModel:[SIReceipt sharedReceipt]];
    [NSUserDefaults.standardUserDefaults setObject:receiptJSON forKey:SIReceiptDefaultsKey];
}

@end
