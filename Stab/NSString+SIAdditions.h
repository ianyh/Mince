//
//  NSString+SIAdditions.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SIAdditions)
- (NSString *)stringByRemovingCharactersFromSet:(NSCharacterSet *)characterSet;
@end