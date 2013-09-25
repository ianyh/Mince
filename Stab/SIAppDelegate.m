//
//  SIAppDelegate.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIAppDelegate.h"

#import "SIReceiptViewController.h"

@interface SIAppDelegate ()
@end

@implementation SIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[SIReceiptViewController alloc] init]];

    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // TODO: write current receipt to user defaults.
}

@end
