//
//  SITaxRatePickerView.m
//  Mince
//
//  Created by Ian Ynda-Hummel on 9/26/13.
//  Copyright (c) 2013 Ian Ynda-Hummel. All rights reserved.
//

#import "SITaxRatePickerView.h"

#import "SIAppDelegate.h"

typedef NS_ENUM(NSInteger, SITaxRatePickerComponent) {
    SITaxRatePickerComponentMajor,
    SITaxRatePickerComponentConnector,
    SITaxRatePickerComponentMinor,
    SITaxRatePickerComponentPercentSign,
};

@interface SITaxRatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

- (IBAction)done:(id)sender;
@end

@implementation SITaxRatePickerView

- (id)init {
    return [[UINib nibWithNibName:@"SITaxRatePickerView" bundle:nil] instantiateWithOwner:nil options:nil][0];
}

#pragma mark IBAction

- (IBAction)done:(id)sender {
    NSInteger majorRow = [self.pickerView selectedRowInComponent:SITaxRatePickerComponentMajor];
    NSInteger minorRow = [self.pickerView selectedRowInComponent:SITaxRatePickerComponentMinor];

    [self.delegate taxRatePicker:self didFinishWithTaxRate:@(majorRow / 100.0 + minorRow * 100 / 40 / 10000.0)];

    [self removeFromSuperview];
}

#pragma mark Public Methods

- (void)display {
    [SIAppDelegate.applicationDelegate.window addSubview:self];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch ((SITaxRatePickerComponent)component) {
        case SITaxRatePickerComponentMajor:
            return 16;
        case SITaxRatePickerComponentMinor:
            return 40;
        case SITaxRatePickerComponentConnector:
        case SITaxRatePickerComponentPercentSign:
            return 1;
    }
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch ((SITaxRatePickerComponent)component) {
        case SITaxRatePickerComponentMajor:
            return [NSString stringWithFormat:@"%ld", (long)row];
        case SITaxRatePickerComponentMinor:
            return [NSString stringWithFormat:@"%03.f", row * 100 / 40.0 * 10];
        case SITaxRatePickerComponentConnector:
            return @".";
        case SITaxRatePickerComponentPercentSign:
            return @"%";
    }
}

@end
