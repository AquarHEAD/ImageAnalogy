//
//  IADocument.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/12/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "IADocument.h"
#import "IAImageViewer.h"
#import "IAGausPymLevel.h"
#import "IAAlgorithms.h"
#import "Location.h"

@interface IADocument()

# pragma mark - UI Settings
@property (weak) IBOutlet NSPopUpButton *typeChooser;
@property (weak) IBOutlet NSTextField *levelWeightInput;
@property (weak) IBOutlet NSButton *use2LevelButton;
@property (weak) IBOutlet NSTextField *annEpsInput;
@property (weak) IBOutlet NSTextField *cohenEpsInput;
@property (weak) IBOutlet NSPopUpButton *colorSpaceChooser;
@property (weak) IBOutlet NSButton *useLuminRemap;
@property (weak) IBOutlet NSTextField *levelInput;

# pragma mark - Analogy Button
@property (weak) IBOutlet NSButton *analogyButton;
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (weak) IBOutlet NSTextField *timeField;

# pragma mark - Images
@property (strong, nonatomic) NSURL *imgaurl;
@property (strong, nonatomic) IAImageViewer *viewerA;
@property (strong, nonatomic) NSArray *pymA;
@property BOOL a_loaded;

@property (strong, nonatomic) NSURL *imga2url;
@property (strong, nonatomic) IAImageViewer *viewerA2;
@property (strong, nonatomic) NSArray *pymA2;
@property BOOL a2_loaded;

@property (strong, nonatomic) NSURL *imgburl;
@property (strong, nonatomic) IAImageViewer *viewerB;
@property (strong, nonatomic) NSArray *pymB;
@property BOOL b_loaded;

@property (strong, nonatomic) IAImageViewer *viewerB2;

@end

@implementation IADocument

# pragma mark - Default Functions

- (void)awakeFromNib {
    [self.typeChooser addItemsWithTitles:@[@"Brute Force", @"Ashikhmin", @"ANN", @"Ash + ANN"]];
    [self.colorSpaceChooser addItemsWithTitles:@[@"RGB", @"YIQ"]];
}

- (NSString *)windowNibName {
    return @"IADocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

# pragma mark - Load Pictures

- (IBAction)loadA:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setAllowsMultipleSelection:NO];
    [op setAllowedFileTypes:@[@"jpg", @"png"]];
    [op setCanChooseFiles:YES];
    if ([op runModal] == NSOKButton) {
        NSArray *files = [op URLs];
        self.imgaurl = files[0];
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:self.imgaurl];
        self.viewerA = [IAImageViewer new];
        self.pymA = [[self class] gaussianPyramid:[img CGImageForProposedRect:nil context:[NSGraphicsContext graphicsContextWithAttributes:nil] hints:nil] level:[[self.levelInput stringValue] intValue]];
        self.viewerA.pyramid = self.pymA;
        self.viewerA.image_tag = @"A";
        self.viewerA.img = img;
        [self.viewerA showWindow:nil];
        self.a_loaded = YES;
    }
    [self enableAnalogy];
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
        self.viewerA2 = [IAImageViewer new];
        self.pymA2 = [[self class] gaussianPyramid:[img CGImageForProposedRect:nil context:[NSGraphicsContext graphicsContextWithAttributes:nil] hints:nil] level:[[self.levelInput stringValue] intValue]];
        self.viewerA2.pyramid = self.pymA2;
        self.viewerA2.image_tag = @"A'";
        self.viewerA2.img = img;
        [self.viewerA2 showWindow:nil];
        self.a2_loaded = YES;
    }
    [self enableAnalogy];
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
        self.viewerB = [IAImageViewer new];
        self.pymB = [[self class] gaussianPyramid:[img CGImageForProposedRect:nil context:[NSGraphicsContext graphicsContextWithAttributes:nil] hints:nil] level:[[self.levelInput stringValue] intValue]];
        self.viewerB.pyramid = self.pymB;
        self.viewerB.image_tag = @"B";
        self.viewerB.img = img;
        [self.viewerB showWindow:nil];
        self.b_loaded = YES;
    }
    [self enableAnalogy];
}

# pragma mark - Analogy action

- (IBAction)doAnalogy:(id)sender {
    NSDate *start = [NSDate date];
    NSMutableArray *b2pym = [NSMutableArray new];
    double lw = [[self.levelWeightInput stringValue] doubleValue];
    cs_t cs = (cs_t)self.colorSpaceChooser.indexOfSelectedItem;
    BOOL ash2Level = self.use2LevelButton.state == NSOnState;
    NSArray *old_s = nil;
    
    for (int l=[[self.levelInput stringValue] intValue]-1; l>=0; l--) {
        // start iter level
        IAGausPymLevel *thisLevelB = [self.pymB objectAtIndex:l];
        IAGausPymLevel *thisLevelA = [self.pymA objectAtIndex:l];
        
        if (self.colorSpaceChooser.indexOfSelectedItem == IAColorSpaceYIQ) {
            thisLevelB = [IAColorSpace fromRGBtoYIQ:thisLevelB];
            thisLevelA = [IAColorSpace fromRGBtoYIQ:thisLevelA];
        }
        
        IAGausPymLevel *nextLevelB = nil;
        IAGausPymLevel *nextLevelA = nil;
        
        BOOL lastLevel = NO;
        
        if (l < [[self.levelInput stringValue] intValue]-1) {
            nextLevelB = [self.pymB objectAtIndex:l+1];
            nextLevelA = [self.pymA objectAtIndex:l+1];
            lastLevel = YES;
            if (self.colorSpaceChooser.indexOfSelectedItem == IAColorSpaceYIQ) {
                nextLevelB = [IAColorSpace fromRGBtoYIQ:nextLevelB];
                nextLevelA = [IAColorSpace fromRGBtoYIQ:nextLevelA];
            }
        }
        
        IAGausPymLevel *thisLevelA2 = [self.pymA2 objectAtIndex:l];
        if (self.colorSpaceChooser.indexOfSelectedItem == IAColorSpaceYIQ) {
            thisLevelA2 = [IAColorSpace fromRGBtoYIQ:thisLevelA2];
        }
        const uint8_t* a2_bytes = [thisLevelA2.levelData bytes];
        uint8_t* b2_bytes = malloc(thisLevelB.height*thisLevelB.width*thisLevelB.bpx);
        
        NSMutableArray *this_s = [NSMutableArray new];
        for (long t=0; t<thisLevelB.width*thisLevelB.height*sizeof(long); t++) {
            Location *l = [Location new];
            l.row = -1;
            l.col = -1;
            [this_s addObject:l];
        }
        
        // iter each pixel in B
        for (long colb=0; colb < thisLevelB.width; colb++) {
            for (long rowb=0; rowb < thisLevelB.height; rowb++) {
                // use algorithms
                algo_result *r = nil;
                if (self.typeChooser.indexOfSelectedItem == AlgoBruteForce) {
                    r = [BestLocBruteForce findBestLocationThisLevelB:thisLevelB thisLevelA:thisLevelA nextLevelB:nextLevelB nextLevelA:nextLevelA colb:colb rowb:rowb isLastLevel:lastLevel withLevelWeight:lw inColorSpace:cs];
                }
                else if (self.typeChooser.indexOfSelectedItem == AlgoAshikhmin) {
                    r = [BestLocAshikhmin findBestLocationThisLevelB:thisLevelB thisLevelA:thisLevelA nextLevelB:nextLevelB nextLevelA:nextLevelA colb:colb rowb:rowb isLastLevel:lastLevel useTwoLevel:ash2Level withThisS:this_s andLastS:old_s withLevelWeight:lw inColorSpace:cs];
                }
                else if (self.typeChooser.indexOfSelectedItem == AlgoANN) {
                    if ((colb < 2) || (colb > thisLevelB.width-3) || (rowb < 2) || (rowb > thisLevelB.height-3)) {
                        r = [BestLocBruteForce findBestLocationThisLevelB:thisLevelB thisLevelA:thisLevelA nextLevelB:nextLevelB nextLevelA:nextLevelA colb:colb rowb:rowb isLastLevel:lastLevel withLevelWeight:lw inColorSpace:cs];
                    }
                    else {
                        
                    }
                }
                
                // copy from A' to B'
                const uint8_t* a2_pixel = &a2_bytes[r->bestrow*thisLevelB.bpr+r->bestcol*thisLevelB.bpx];
                uint8_t* b2_pixel = &b2_bytes[rowb*thisLevelB.bpr+colb*thisLevelB.bpx];
                for (int pp=0; pp<thisLevelB.bpx; pp++) {
                    b2_pixel[pp] = a2_pixel[pp];
                }
            }
        }
        
        // copy this level's result into result pyramid
        NSData *b2data = [NSData dataWithBytes:b2_bytes length:thisLevelB.height*thisLevelB.width*thisLevelB.bpx];
        IAGausPymLevel *thisLevelB2 = [IAGausPymLevel new];
        thisLevelB2.levelData = b2data;
        thisLevelB2.width = thisLevelB.width;
        thisLevelB2.height = thisLevelB.height;
        thisLevelB2.bpr = thisLevelB.bpr;
        thisLevelB2.bpx = thisLevelB.bpx;
        if (self.colorSpaceChooser.indexOfSelectedItem == IAColorSpaceYIQ) {
            thisLevelB2 = [IAColorSpace fromYIQtoRGB:thisLevelB2];
        }
        [b2pym insertObject:thisLevelB2 atIndex:0];
        
        // increase progress bar
        [self.progressBar incrementBy:100.0/([[self.levelInput stringValue] intValue])];
        
        // exchange old_s <-> this_s
        if (self.typeChooser.indexOfSelectedItem == AlgoAshikhmin) {
            old_s = this_s;
        }
    } // end iter level
    
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    self.timeField.stringValue = [NSString stringWithFormat:@"%f s", -timeInterval];
    self.viewerB2 = [IAImageViewer new];
    self.viewerB2.pyramid = [b2pym copy];
    self.viewerB2.image_tag = @"B'";
    self.viewerB2.img = [[NSImage alloc] initWithContentsOfURL:self.imgburl];
    [self.viewerB2 showWindow:nil];
}

- (void)enableAnalogy {
    if (self.a_loaded && self.a2_loaded && self.b_loaded) {
        [self.analogyButton setEnabled:YES];
    }
}

# pragma mark - Create Gaussian Pyramids

+ (NSArray *)gaussianPyramid:(CGImageRef)img level:(int)levels {
    NSMutableArray *pym = [NSMutableArray new];
    
    const int change_row[] = { -1, -1, -1, 0, 0, 0, 1, 1, 1};
    const int change_col[] = { -1, 0, 1, -1, 0, 1, -1, 0, 1};
    
    const double weight[] = { 0.0625, 0.125, 0.0625, 0.125, 0.25, 0.125, 0.0625, 0.125, 0.0625 };
    
    size_t width  = CGImageGetWidth(img);
    size_t height = CGImageGetHeight(img);
    size_t bpr = CGImageGetBytesPerRow(img);
    size_t bpp = CGImageGetBitsPerPixel(img);
    size_t bpc = CGImageGetBitsPerComponent(img);
    size_t bytes_per_pixel = bpp / bpc;
    CGDataProviderRef provider = CGImageGetDataProvider(img);
    
    // save level 1
    NSData* origin_data = (__bridge id)CGDataProviderCopyData(provider);
    IAGausPymLevel *origin_level = [IAGausPymLevel new];
    origin_level.levelData = origin_data;
    origin_level.width = width;
    origin_level.height = height;
    origin_level.bpr = bpr;
    origin_level.bpx = bytes_per_pixel;
    [pym addObject:origin_level];
    
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
        NSData *newLevelData = [NSData dataWithBytes:new_bytes length:new_width*new_height*bytes_per_pixel];
        IAGausPymLevel *newLevel = [IAGausPymLevel new];
        newLevel.levelData = newLevelData;
        newLevel.width = new_width;
        newLevel.height = new_height;
        newLevel.bpr = new_bpr;
        newLevel.bpx = bytes_per_pixel;
        [pym addObject:newLevel];
        
        // exchange old <-> new
        old_bytes = new_bytes;
        old_width = new_width;
        old_height = new_height;
        old_bpr = new_bpr;
    }
    
    return [pym copy];
}

@end
