//
//  SITipRatePickerView.h
//  Mince
//
//  Created by Ian Ynda-Hummel on 9/26/13.
//  Copyright (c) 2013 Ian Ynda-Hummel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SITipRatePickerViewDelegate;

@interface SITipRatePickerView : UIView
@property (nonatomic, weak) id<SITipRatePickerViewDelegate> delegate;

@property (nonatomic, strong) NSNumber *initialTipRate;

- (id)init;

- (void)display;
@end

@protocol SITipRatePickerViewDelegate <NSObject>
- (void)tipRatePicker:(SITipRatePickerView *)picker didFinishWithTipRate:(NSNumber *)number;
@end
