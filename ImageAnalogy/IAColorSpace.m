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

@end
