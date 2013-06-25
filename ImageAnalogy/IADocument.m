//
//  IADocument.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/12/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "IADocument.h"
#import "IAImageViewer.h"

@interface IADocument()

@property (weak) IBOutlet NSTextField *levelInput;

@property (weak) IBOutlet NSImageView *imgwella;
@property (weak) IBOutlet NSImageView *imgwella2;

@property (weak) IBOutlet NSImageView *imgwellb;
@property (weak) IBOutlet NSImageView *imgwellb2;

@property CGImageRef imga;
@property (strong, nonatomic) NSURL *imgaurl;
@property (strong, nonatomic) IAImageViewer *viewerA;

@property CGImageRef imga2;
@property (strong, nonatomic) NSURL *imga2url;

@property CGImageRef imgb;
@property (strong, nonatomic) NSURL *imgburl;

@property CGImageRef imgb2;
@property (strong, nonatomic) NSURL *imgb2url;

@end

@implementation IADocument

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {

}

- (NSString *)windowNibName
{
    return @"IADocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

- (IBAction)loadA:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setAllowsMultipleSelection:NO];
    [op setAllowedFileTypes:@[@"jpg", @"png"]];
    [op setCanChooseFiles:YES];
    if ([op runModal] == NSOKButton) {
        NSArray *files = [op URLs];
        self.imgaurl = files[0];
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:self.imgaurl];
        self.imgwella.image = img;
        self.imga = [img CGImageForProposedRect:nil context:[NSGraphicsContext graphicsContextWithAttributes:nil] hints:nil];
    }
}

- (IBAction)viewA:(id)sender {
    self.viewerA = [IAImageViewer new];
    self.viewerA.pyramids = [[self class] gaussianPyramid:self.imga level:[[self.levelInput stringValue] intValue]];
    self.viewerA.image_tag = @"A";
    self.viewerA.img = self.imga;
    [self.viewerA showWindow:nil];
}

- (IBAction)loadA2:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setAllowsMultipleSelection:NO];
    [op setAllowedFileTypes:@[@"jpg", @"png"]];
    [op setCanChooseFiles:YES];
    if ([op runModal] == NSOKButton) {
        NSArray *files = [op URLs];
        self.imga2url = files[0];
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:self.imga2url];
        self.imgwella2.image = img;
        self.imga2 = [img CGImageForProposedRect:nil context:[NSGraphicsContext graphicsContextWithAttributes:nil] hints:nil];
    }
}

- (IBAction)loadB:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setAllowsMultipleSelection:NO];
    [op setAllowedFileTypes:@[@"jpg", @"png"]];
    [op setCanChooseFiles:YES];
    if ([op runModal] == NSOKButton) {
        NSArray *files = [op URLs];
        self.imgburl = files[0];
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:self.imgburl];
        self.imgwellb.image = img;
        self.imgb = [img CGImageForProposedRect:nil context:[NSGraphicsContext graphicsContextWithAttributes:nil] hints:nil];
    }
}

- (IBAction)doAnalogy:(id)sender {
    size_t width  = CGImageGetWidth(self.imgb);
    size_t height = CGImageGetHeight(self.imgb);
    
    size_t bpr = CGImageGetBytesPerRow(self.imgb);
    size_t bpp = CGImageGetBitsPerPixel(self.imgb);
    size_t bpc = CGImageGetBitsPerComponent(self.imgb);
//    size_t bytes_per_pixel = bpp / bpc;
    
    CGBitmapInfo info = CGImageGetBitmapInfo(self.imgb);
    CGDataProviderRef provider = CGImageGetDataProvider(self.imgb);

    self.imgb2 = CGImageCreate(width, height, bpc, bpp, bpr, CGImageGetColorSpace(self.imgb), info, provider, NULL, YES, kCGRenderingIntentDefault);
    NSImage *imgb2 = [[NSImage alloc] initWithCGImage:self.imgb2 size:NSZeroSize];
    self.imgwellb2.image = imgb2;
}

+ (NSArray *)gaussianPyramid:(CGImageRef)img level:(int)levels {
    NSMutableArray *pyms = [NSMutableArray new];
    
    const int change_row[] = { -1, -1, -1, 0, 0, 0, 1, 1, 1};
    const int change_col[] = { -1, 0, 1, -1, 0, 1, -1, 0, 1};
    
    const double weight[] = { 0.0625, 0.125, 0.0625, 0.125, 0.25, 0.125, 0.0625, 0.125, 0.0625 };
    
    size_t width  = CGImageGetWidth(img);
    size_t height = CGImageGetHeight(img);
    size_t bpr = CGImageGetBytesPerRow(img);
    size_t bpp = CGImageGetBitsPerPixel(img);
    size_t bpc = CGImageGetBitsPerComponent(img);
    size_t bytes_per_pixel = bpp / bpc;
//    CGBitmapInfo info = CGImageGetBitmapInfo(img);
    CGDataProviderRef provider = CGImageGetDataProvider(img);
    
    NSData* origin_data = (__bridge id)CGDataProviderCopyData(provider);
    [pyms addObject:origin_data];
    
    const uint8_t* old_bytes = [origin_data bytes];
    size_t old_width = width;
    size_t old_height = height;
    size_t old_bpr = bpr;
    
    for (int l=1; l<levels; l++) {
        // alloc space for new level bytes
        size_t new_width = old_width / 2;
        size_t new_height = old_height / 2;
        size_t new_bpr = old_bpr / 2;
        uint8_t* new_bytes = malloc(new_width*new_height*bytes_per_pixel);
        
        // calc each pixel
        for(long row = 0; row < new_height; row++) {
            for (long col = 0; col < new_width; col++) {
                uint8_t* new_pixel = &new_bytes[row*new_bpr + col*bytes_per_pixel];
                for (size_t x = 0; x < bytes_per_pixel; x++) {
                    double tmp = 0;
                    double wt = 0;
                    for (int i = 0; i < 9; i++) {
                        long old_row = 2*row + change_row[i];
                        long old_col = 2*col + change_col[i];
                        if ((old_row >= 0) && (old_row < old_height) && (old_col >= 0) && (old_col < old_width)) {
                            tmp += old_bytes[old_row*old_bpr + old_col*bytes_per_pixel + x]*weight[i];
                            wt += weight[i];
                        }
                    }
                    uint8 result = (uint8_t)(tmp/wt);
                    new_pixel[x] = result;
                    
                }
            }
        }
        
        // save bytes to NSData
        NSData *newLevel = [NSData dataWithBytes:new_bytes length:new_width*new_height*bytes_per_pixel];
        [pyms addObject:newLevel];
        
        // exchange old <-> new
        old_bytes = new_bytes;
        old_width = new_width;
        old_height = new_height;
        old_bpr = new_bpr;
    }
    
    return [pyms copy];
}

@end
