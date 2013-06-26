//
//  IAImageViewer.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/25/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IAImageViewer : NSWindowController

@property (strong, nonatomic) NSString *image_tag;
@property (strong, nonatomic) NSImage *img;
@property (strong, nonatomic) NSArray *pyramid;

@end
