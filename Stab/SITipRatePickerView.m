//
//  SITipRatePickerView.m
//  Mince
//
//  Created by Ian Ynda-Hummel on 9/26/13.
//  Copyright (c) 2013 Ian Ynda-Hummel. All rights reserved.
//

#import "SITipRatePickerView.h"

#import "SIAppDelegate.h"

@interface SITipRatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

- (IBAction)done:(id)sender;
@end

@implementation SITipRatePickerView

- (id)init {
    return [[UINib nibWithNibName:@"SITipRatePickerView" bundle:nil] instantiateWithOwner:nil options:nil][0];
}

#pragma mark IBAction

- (IBAction)done:(id)sender {
    [self.delegate tipRatePicker:self didFinishWithTipRate:@([self.pickerView selectedRowInComponent:0] / 100.0)];
    [self removeFromSuperview];
}

#pragma mark Public Methods

- (void)display {
    [SIAppDelegate.applicationDelegate.window addSubview:self];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 31;
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d%%", row];
}

@end
