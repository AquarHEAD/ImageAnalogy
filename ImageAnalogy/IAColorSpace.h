//
//  IAColorSpace.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAGausPymLevel.h"

typedef enum {
    IAColorSpaceRGB = 0,
    IAColorSpaceYIQ
} cs_t;

@interface IAColorSpace : NSObject

+ (double)pixelDistOfB:(const uint8_t *)pixelb AndA:(const uint8_t *)pixela InColorSpace:(cs_t)cs;

+ (IAGausPymLevel *)fromRGBtoYIQ:(IAGausPymLevel *)level;

+ (IAGausPymLevel *)fromYIQtoRGB:(IAGausPymLevel *)level;

@end
