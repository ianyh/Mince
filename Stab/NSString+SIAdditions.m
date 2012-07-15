//
//  NSString+SIAdditions.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+SIAdditions.h"

@implementation NSString (SIAdditions)

- (NSString *)stringByRemovingCharactersFromSet:(NSCharacterSet *)characterSet {
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
}

@end
