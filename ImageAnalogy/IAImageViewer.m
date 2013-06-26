//
//  IAImageViewer.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/25/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "IAImageViewer.h"
#import "IAGausPymLevel.h"

@interface IAImageViewer ()

@property (weak) IBOutlet NSPopUpButton *level;
@property (weak) IBOutlet NSImageView *imgWell;

@end

@implementation IAImageViewer

- (id)init {
    self = [super initWithWindowNibName:@"IAImageViewer"];
    
    return self;
}

- (void)awakeFromNib {
    self.window.title = self.image_tag;
    for (int i=0; i<[self.pyramid count]; i++) {
        [self.level addItemWithTitle:[NSString stringWithFormat:@"%d", i+1]];
    }
    [self showImgAtLevel:0];
}

- (IBAction)changeLevel:(id)sender {
    [self showImgAtLevel:[self.level indexOfSelectedItem]];
}

- (void)showImgAtLevel:(NSInteger)index {
    IAGausPymLevel *level = [self.pyramid objectAtIndex:index];
    NSData *imgdata = level.levelData;
    
    CGImageRef imgr = [self.img CGImageForProposedRect:nil context:[NSGraphicsContext graphicsContextWithAttributes:nil] hints:nil];
    size_t bpp = CGImageGetBitsPerPixel(imgr);
    size_t bpc = CGImageGetBitsPerComponent(imgr);
    CGBitmapInfo info = CGImageGetBitmapInfo(imgr);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imgdata);
    CGImageRef imgl = CGImageCreate(level.width, level.height, bpc, bpp, level.bpr, CGImageGetColorSpace(imgr), info, provider, NULL, YES, kCGRenderingIntentDefault);
    NSImage *nsimg = [[NSImage alloc] initWithCGImage:imgl size:NSZeroSize];
    self.imgWell.image = nsimg;
}

@end
