//
//  SITesseractParser.h
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SITesseractCompletionHandler)(NSString *string);

@interface SITesseractParser : NSObject
- (void)parseImage:(UIImage *)image withCompletionHandler:(SITesseractCompletionHandler)completionHandler;
@end
