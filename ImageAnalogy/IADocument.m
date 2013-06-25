//
//  IADocument.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/12/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "IADocument.h"

@interface IADocument()

@property (weak) IBOutlet NSImageView *imgwella;
@property (weak) IBOutlet NSImageView *imgwella2;

@property (weak) IBOutlet NSImageView *imgwellb;
@property (weak) IBOutlet NSImageView *imgwellb2;

@property CGImageRef imga;
@property (strong, nonatomic) NSURL *imgaurl;

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
    
//    NSLog(
//          @"\n"
//          "===== %@ =====\n"
//          "CGImageGetHeight: %d\n"
//          "CGImageGetWidth:  %d\n"
//          "CGImageGetColorSpace: %@\n"
//          "CGImageGetBitsPerPixel:     %d\n"
//          "CGImageGetBitsPerComponent: %d\n"
//          "CGImageGetBytesPerRow:      %d\n"
//          "CGImageGetBitmapInfo: 0x%.8X\n"
//          "  kCGBitmapAlphaInfoMask     = %s\n"
//          "  kCGBitmapFloatComponents   = %s\n"
//          "  kCGBitmapByteOrderMask     = %s\n"
//          "  kCGBitmapByteOrderDefault  = %s\n"
//          "  kCGBitmapByteOrder16Little = %s\n"
//          "  kCGBitmapByteOrder32Little = %s\n"
//          "  kCGBitmapByteOrder16Big    = %s\n"
//          "  kCGBitmapByteOrder32Big    = %s\n",
//          self.imgaurl,
//          (int)width,
//          (int)height,
//          CGImageGetColorSpace(self.imga),
//          (int)bpp,
//          (int)bpc,
//          (int)bpr,
//          (unsigned)info,
//          (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
//          (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
//          (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
//          (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
//          (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
//          (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
//          (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
//          (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"
//          );
    
    CGDataProviderRef provider = CGImageGetDataProvider(self.imgb);
//    NSData* data = (__bridge id)CGDataProviderCopyData(provider);
//    const uint8_t* bytes = [data bytes];
//    printf("Pixel Data:\n");
//    for(size_t row = 0; row < height; row++)
//    {
//        for(size_t col = 0; col < width; col++)
//        {
//            const uint8_t* pixel =
//            &bytes[row * bpr + col * bytes_per_pixel];
//            
//            printf("(");
//            for(size_t x = 0; x < bytes_per_pixel; x++)
//            {
//                printf("%.2X", pixel[x]);
//                if( x < bytes_per_pixel - 1 )
//                    printf(",");
//            }
//            
//            printf(")");
//            if( col < width - 1 )
//                printf(", ");
//        }
//        
//        printf("\n");
//    }
    self.imgb2 = CGImageCreate(width, height, bpc, bpp, bpr, CGImageGetColorSpace(self.imgb), info, provider, NULL, YES, kCGRenderingIntentDefault);
    NSImage *imgb2 = [[NSImage alloc] initWithCGImage:self.imgb2 size:NSZeroSize];
    self.imgwellb2.image = imgb2;
}

@end
