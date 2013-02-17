//
//  SIReceiptCreateViewController.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 2/16/13.
//
//

#import <UIKit/UIKit.h>

@class SIReceiptCreateViewController;
@protocol SIReceiptCreateViewControllerDelegate <NSObject>
- (void)receiptCreateViewControllerDidFinish:(SIReceiptCreateViewController *)controller;
@end

@interface SIReceiptCreateViewController : UIViewController
@property (nonatomic, assign) id <SIReceiptCreateViewControllerDelegate> delegate;
@end
