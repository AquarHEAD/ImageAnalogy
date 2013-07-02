//
//  BestLocANN.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/27/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "BestLocANN.h"

@implementation BestLocANN

+ (algo_result *)findBestLocationThisLevelB:(IAGausPymLevel *)thisLevelB thisLevelA:(IAGausPymLevel *)thisLevelA nextLevelB:(IAGausPymLevel *)nextLevelB nextLevelA:(IAGausPymLevel *)nextLevelA colb:(long)colb rowb:(long)rowb isLastLevel:(BOOL)lastLevel withLevelWeight:(double)lw inColorSpace:(cs_t)cs {
    return nil;
}

+ (float *)makeANNSetForThisLevelA:(IAGausPymLevel *)thisLevelA nextLevelA:(IAGausPymLevel *)nextLevelA isLastLevel:(BOOL)lastLevel withLevelWeight:(double)lw inColorSpace:(cs_t)cs {
    
    double kernel5[] = {0.0625, 0.25, 0.425, 0.25, 0.0625};
    double kernel3[] = {0.25, 0.5, 0.25};
    
    int dim = 3;
    if (cs == IAColorSpaceYIQ) {
        dim = 1;
    }
    
    int nsize = 25;
    if (lastLevel) {
        nsize += 9;
    }
    
    float *result = malloc((thisLevelA.width-4)*(thisLevelA.height-4)*nsize*dim);
}
@end
