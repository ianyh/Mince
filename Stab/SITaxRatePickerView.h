//
//  SITaxRatePickerView.h
//  Mince
//
//  Created by Ian Ynda-Hummel on 9/26/13.
//  Copyright (c) 2013 Ian Ynda-Hummel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SITaxRatePickerViewDelegate;

@interface SITaxRatePickerView : UIView
@property (nonatomic, weak) id<SITaxRatePickerViewDelegate> delegate;

@property (nonatomic, strong) NSNumber *initialTaxRate;

- (id)init;

- (void)display;
@end

@protocol SITaxRatePickerViewDelegate <NSObject>
- (void)taxRatePicker:(SITaxRatePickerView *)picker didFinishWithTaxRate:(NSNumber *)number;
@end
