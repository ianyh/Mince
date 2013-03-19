//
//  SIReceiptPeopleViewController.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 3/18/13.
//
//

#import <UIKit/UIKit.h>

@class SIReceiptPeopleViewController;
@class SIPerson;
@protocol SIReceiptPeopleViewControllerDelegate <NSObject>
- (void)receiptPeopleViewController:(SIReceiptPeopleViewController *)controller didSelectPerson:(SIPerson *)person;
@end

@class SIReceipt;
@interface SIReceiptPeopleViewController : UIViewController
@property (weak, nonatomic) id <SIReceiptPeopleViewControllerDelegate> delegate;
@property (strong, nonatomic) SIReceipt *receipt;
@end
