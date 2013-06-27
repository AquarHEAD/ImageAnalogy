//
//  BestLocAshikhmin.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestLocBruteForce.h"

@interface BestLocAshikhmin : NSObject

+ (algo_result *)findBestLocationThisLevelB:(IAGausPymLevel *)thisLevelB thisLevelA:(IAGausPymLevel *)thisLevelA nextLevelB:(IAGausPymLevel *)nextLevelB nextLevelA:(IAGausPymLevel *)nextLevelA colb:(long)colb rowb:(long)rowb isLastLevel:(BOOL)lastLevel useTwoLevel:(BOOL)twoLevel withThisS:(NSMutableArray *)this_s andLastS:(NSArray *)old_s withLevelWeight:(double)lw inColorSpace:(cs_t)cs;

@end
