//
//  IAImageViewer.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/25/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "IAImageViewer.h"

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
    for (int i=0; i<[self.pyramids count]; i++) {
        [self.level addItemWithTitle:[NSString stringWithFormat:@"%d", i+1]];
    }
    [self showImgAtLevel:0];
}

- (IBAction)changeLevel:(id)sender {
    [self showImgAtLevel:[self.level indexOfSelectedItem]];
}

- (void)showImgAtLevel:(NSInteger)index {
    NSData *imgdata = [self.pyramids objectAtIndex:index];
    
    size_t width  = CGImageGetWidth(self.img);
    size_t height = CGImageGetHeight(self.img);
    
    size_t bpr = CGImageGetBytesPerRow(self.img);
    for (int i = 0; i<index; i++) {
        bpr /= 2;
        width /= 2;
        height /= 2;
    }
    size_t bpp = CGImageGetBitsPerPixel(self.img);
    size_t bpc = CGImageGetBitsPerComponent(self.img);
    
    CGBitmapInfo info = CGImageGetBitmapInfo(self.img);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imgdata);
    
    CGImageRef imgl = CGImageCreate(width, height, bpc, bpp, bpr, CGImageGetColorSpace(self.img), info, provider, NULL, YES, kCGRenderingIntentDefault);
    NSImage *nsimg = [[NSImage alloc] initWithCGImage:imgl size:NSZeroSize];
    self.imgWell.image = nsimg;
}

@end
