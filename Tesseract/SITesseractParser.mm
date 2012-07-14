//
//  SITesseractParser.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SITesseractParser.h"

#import "baseapi.h"
using namespace tesseract;

@interface SITesseractParser ()
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) TessBaseAPI *tesseract;
- (void)setUpTesseract;
@end

@implementation SITesseractParser
@synthesize image = _image;
@synthesize tesseract = _tesseract;

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
        [self setUpTesseract];
    }
    return self;
}

- (void)dealloc {
    _tesseract->End();
}

#pragma mark - Tesseract

- (void)setUpTesseract {
    // Set up the tessdata path. This is included in the application bundle
    // but is copied to the Documents directory on the first run.
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;

    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath]) {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
        if (tessdataPath)
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
    }

    setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);

    // init the tesseract engine.
    self.tesseract = new tesseract::TessBaseAPI();
    self.tesseract->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng");
}

@end
