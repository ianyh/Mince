//
//  SIReceipt.m
//  Stab
//
//  Created by Ian Ynda-Hummel on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SIReceipt.h"

#import "SIPerson.h"
#import "SIReceiptItem.h"
#import <TesseractOCR/TesseractOCR.h>
#import "UIImage+Processing.h"

static SIReceipt *sharedReceipt;

@interface SIReceipt () <MTLJSONSerializing>
@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SIReceipt

+ (instancetype)sharedReceipt {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedReceipt) {
            sharedReceipt = [[SIReceipt alloc] init];
        }
    });
    return sharedReceipt;
}

+ (void)setSharedReceipt:(SIReceipt *)receipt {
    sharedReceipt = receipt;
}

- (id)init {
    self = [super init];
    if (self) {
        self.people = @[];
        self.items = @[];

        self.taxRate = @0;
        self.tipRate = @0;
    }
    return self;
}

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"taxRate": @"taxRate",
             @"tipRate": @"tipRate",
             @"people": @"people",
             @"items": @"items",
             };
}

#pragma mark People

- (void)addPerson:(SIPerson *)person {
    if ([self.people containsObject:person]) return;

    self.people = [@[ person ] arrayByAddingObjectsFromArray:self.people];
}

- (void)removePerson:(SIPerson *)person {
    if (![self.people containsObject:person]) return;

    for (SIReceiptItem *item in self.items) {
        [item removePerson:person];
    }

    self.people = [self.people filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isEqual:person];
    }]];
}

#pragma mark Items

- (void)addItem:(SIReceiptItem *)item {
    if ([self.items containsObject:item]) return;

    self.items = [@[ item ] arrayByAddingObjectsFromArray:self.items];
}

- (void)removeItem:(SIReceiptItem *)item {
    if (![self.items containsObject:item]) return;

    for (SIPerson *person in self.people) {
        [person removeItem:item];
    }

    self.items = [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isEqual:item];
    }]];
}

- (void)addEntriesFromReceiptPhoto:(UIImage *)photo withCompletion:(dispatch_block_t)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *scaledPhoto = [photo processedForTesseract];
//        CGSize newSize = (CGSize){ 
//            .width = photo.size.width * 2.5,
//            .height = photo.size.height * 2.5,
//        };
//        UIGraphicsBeginImageContext(newSize);
//        [photo drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//        scaledPhoto = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();

        Tesseract *tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];

        [tesseract setVariableValue:@"$.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" forKey:@"tessedit_char_whitelist"];
        [tesseract setImage:scaledPhoto];
        [tesseract recognize];

        NSString *recognizedText = tesseract.recognizedText;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^(.+)(\\d+\\.\\d+).*$" options:0 error:nil];
            for (NSString *line in [recognizedText componentsSeparatedByString:@"\n"]) {
                NSLog(@"%@", line);
                NSTextCheckingResult *result = [regularExpression firstMatchInString:line options:0 range:NSMakeRange(0, line.length)];
                if (result) {
                    [self addEntryWithName:[line substringWithRange:[result rangeAtIndex:1]]
                                      cost:@([[line substringWithRange:[result rangeAtIndex:2]] floatValue])];
                }
            }

            dispatch_async(dispatch_get_main_queue(), completion);
        });
    });
}

//UIImage *gs_convert_image (UIImage *src_img) {
//    CGColorSpaceRef d_colorSpace = CGColorSpaceCreateDeviceRGB();
//    /*
//     * Note we specify 4 bytes per pixel here even though we ignore the
//     * alpha value; you can't specify 3 bytes per-pixel.
//     */
//    size_t d_bytesPerRow = src_img.size.width * 4;
//    unsigned char * imgData = (unsigned char*)malloc(src_img.size.height*d_bytesPerRow);
//    CGContextRef context =  CGBitmapContextCreate(imgData,
//                                                  src_img.size.width,
//                                                  src_img.size.height,
//                                                  8,
//                                                  d_bytesPerRow,
//                                                  d_colorSpace,
//                                                  kCGImageAlphaNoneSkipFirst);
//
//    UIGraphicsPushContext(context);
//    // These next two lines 'flip' the drawing so it doesn't appear upside-down.
//    CGContextTranslateCTM(context, 0.0, src_img.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    // Use UIImage's drawInRect: instead of the CGContextDrawImage function, otherwise you'll have issues when the source image is in portrait orientation.
//    [src_img drawInRect:CGRectMake(0.0, 0.0, src_img.size.width, src_img.size.height)];
//    UIGraphicsPopContext();
//
//    /*
//     * At this point, we have the raw ARGB pixel data in the imgData buffer, so
//     * we can perform whatever image processing here.
//     */
//
//
//    // After we've processed the raw data, turn it back into a UIImage instance.
//    CGImageRef new_img = CGBitmapContextCreateImage(context);
//    UIImage *convertedImage = [[UIImage alloc] initWithCGImage:new_img];
//
//    CGImageRelease(new_img);
//    CGContextRelease(context);
//    CGColorSpaceRelease(d_colorSpace);
//    free(imgData);
//
//    return convertedImage;
//}

- (void)addEntryWithName:(NSString *)name cost:(NSNumber *)cost {
    SIReceiptItem *item = [[SIReceiptItem alloc] init];

    item.name = name;
    item.cost = cost;

    [self addItem:item];
}

- (void)removeAllEntries {
    for (SIReceiptItem *item in [self.items copy]) {
        [self removeItem:item];
    }
}

#pragma mark Values

- (NSNumber *)subtotal {
    return [self.items valueForKeyPath:@"@sum.cost"];
}

- (NSNumber *)tax {
    return @( self.subtotal.doubleValue * self.taxRate.doubleValue );
}

- (NSNumber *)tip {
    return @( self.subtotal.doubleValue * self.tipRate.doubleValue );
}

- (NSNumber *)total {
    return @( self.subtotal.doubleValue + self.tax.doubleValue + self.tip.doubleValue );
}

- (NSNumber *)totalForPerson:(SIPerson *)person {
    double totalOwed = 0.0;

    for (SIReceiptItem *item in person.items) {
        totalOwed += item.cost.doubleValue / item.people.count;
    }

    totalOwed += self.tax.doubleValue / self.people.count;
    totalOwed += self.tip.doubleValue / self.people.count;

    return @( totalOwed );
}

@end
