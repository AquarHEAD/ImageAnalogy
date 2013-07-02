//
//  IAColorSpace.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "IAColorSpace.h"

@implementation IAColorSpace

+ (double)pixelDistOfB:(const uint8_t *)pixelb AndA:(const uint8_t *)pixela InColorSpace:(cs_t)cs {
    double dist = 0;
    if (cs==IAColorSpaceRGB) {
        for (int i=0; i<3; i++) {
            double d = pixelb[i] - pixela[i];
            dist += d*d;
        }
    }
    else {
        dist = (pixelb[0] - pixela[0]) * (pixelb[0] - pixela[0]);
    }
    return dist;
}

// http://www.cs.rit.edu/~ncs/color/t_convert.html

+ (IAGausPymLevel *)fromRGBtoYIQ:(IAGausPymLevel *)level {
    IAGausPymLevel *nl = [IAGausPymLevel new];
    nl.width = level.width;
    nl.height = level.height;
    nl.bpr = level.bpr;
    nl.bpx = level.bpx;
    const uint8_t *bytes = [level.levelData bytes];
    uint8_t *new_bytes = malloc(level.width*level.height*level.bpx);
    for(long row = 0; row < level.height; row++) {
        for (long col = 0; col < level.width; col++) {
            const uint8_t *pixel = &bytes[row*level.bpr + col*level.bpx];
            uint8_t *new_pixel = &new_bytes[row*level.bpr + col*level.bpx];
            new_pixel[0] = 0.299*pixel[0] + 0.587*pixel[1] + 0.114*pixel[2];
            new_pixel[1] = 0.596*pixel[0] - 0.275*pixel[1] - 0.321*pixel[2];
            new_pixel[2] = 0.212*pixel[0] - 0.523*pixel[1] + 0.311*pixel[2];
            for (size_t x = 3; x < level.bpx; x++) {
                new_pixel[x] = pixel[x];
            }
        }
    }
    NSData *newLevelData = [NSData dataWithBytes:new_bytes length:level.width*level.height*level.bpx];
    nl.levelData = newLevelData;
    return nl;
}

+ (IAGausPymLevel *)fromYIQtoRGB:(IAGausPymLevel *)level {
    IAGausPymLevel *nl = [IAGausPymLevel new];
    nl.width = level.width;
    nl.height = level.height;
    nl.bpr = level.bpr;
    nl.bpx = level.bpx;
    const uint8_t *bytes = [level.levelData bytes];
    uint8_t *new_bytes = malloc(level.width*level.height*level.bpx);
    for(long row = 0; row < level.height; row++) {
        for (long col = 0; col < level.width; col++) {
            const uint8_t *pixel = &bytes[row*level.bpr + col*level.bpx];
            uint8_t *new_pixel = &new_bytes[row*level.bpr + col*level.bpx];
            new_pixel[0] = 1.0*pixel[0] + 0.956*pixel[1] + 0.621*pixel[2];
            new_pixel[1] = 1.0*pixel[0] - 0.272*pixel[1] - 0.647*pixel[2];
            new_pixel[2] = 1.0*pixel[0] - 1.105*pixel[1] + 1.702*pixel[2];
            for (size_t x = 3; x < level.bpx; x++) {
                new_pixel[x] = pixel[x];
            }
        }
    }
    NSData *newLevelData = [NSData dataWithBytes:new_bytes length:level.width*level.height*level.bpx];
    nl.levelData = newLevelData;
    return nl;
}

@end
