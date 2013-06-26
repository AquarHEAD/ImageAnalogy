//
//  BestLocBruteForce.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAColorSpace.h"
#import "IAGausPymLevel.h"

@interface BestLocBruteForce : NSObject

+ (double)neighbourDist5ForB:(IAGausPymLevel *)level_b BCol:(long)cb BRow:(long)rb Bbpr:(size_t)bprb Bbpx:(size_t)bpxb
                        AndA:(IAGausPymLevel *)level_a ACol:(long)ca ARow:(long)ra Abpr:(size_t)bpra Abpx:(size_t)bpxa inColorSpace:(cs_t)cs;

+ (double)neighbourDist3ForB:(IAGausPymLevel *)level_b BCol:(long)cb BRow:(long)rb Bbpr:(size_t)bprb Bbpx:(size_t)bpxb
                        AndA:(IAGausPymLevel *)level_a ACol:(long)ca ARow:(long)ra Abpr:(size_t)bpra Abpx:(size_t)bpxa inColorSpace:(cs_t)cs;

@end
