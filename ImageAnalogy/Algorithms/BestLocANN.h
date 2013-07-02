//
//  BestLocANN.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/27/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestLocBruteForce.h"

@interface BestLocANN : NSObject

+ (algo_result *)findBestLocationThisLevelB:(IAGausPymLevel *)thisLevelB thisLevelA:(IAGausPymLevel *)thisLevelA nextLevelB:(IAGausPymLevel *)nextLevelB nextLevelA:(IAGausPymLevel *)nextLevelA colb:(long)colb rowb:(long)rowb isLastLevel:(BOOL)lastLevel withLevelWeight:(double)lw inColorSpace:(cs_t)cs;

+ (float *)makeANNSetForThisLevelA:(IAGausPymLevel *)thisLevelA nextLevelA:(IAGausPymLevel *)nextLevelA isLastLevel:(BOOL)lastLevel withLevelWeight:(double)lw inColorSpace:(cs_t)cs;

@end
