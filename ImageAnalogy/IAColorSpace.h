//
//  IAColorSpace.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IAColorSpaceRGB = 0,
    IAColorSpaceYIQ
} cs_t;

@interface IAColorSpace : NSObject

+ (double)pixelDistOfB:(const uint8_t *)pixelb AndA:(const uint8_t *)pixelb InColorSpace:(cs_t)cs;

@end