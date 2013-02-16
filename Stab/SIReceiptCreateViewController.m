//
//  SIReceiptCreateViewController.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 2/16/13.
//
//

#import "SIReceiptCreateViewController.h"

@interface SIReceiptCreateViewController ()

@end

@implementation SIReceiptCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelSegue:(UIStoryboardSegue *)segue {
}

@end
