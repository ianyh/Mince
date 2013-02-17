//
//  SIReceiptPersonCollectionViewCell.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 2/17/13.
//
//

#import "SIReceiptPersonCollectionViewCell.h"

@interface SIReceiptPersonCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation SIReceiptPersonCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

@end
