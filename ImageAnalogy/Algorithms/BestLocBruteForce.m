//
//  BestLocBruteForce.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "BestLocBruteForce.h"

@implementation BestLocBruteForce

+ (double)neighbourDist5ForB:(IAGausPymLevel *)level_b BCol:(long)cb BRow:(long)rb Bbpr:(size_t)bprb Bbpx:(size_t)bpxb
                        AndA:(IAGausPymLevel *)level_a ACol:(long)ca ARow:(long)ra Abpr:(size_t)bpra Abpx:(size_t)bpxa inColorSpace:(cs_t)cs {
    double kernel[] = {0.0625, 0.25, 0.425, 0.25, 0.0625};
    double dist = 0;
    double wt = 0;
    const uint8_t* bytesb = [level_b.levelData bytes];
    const uint8_t* bytesa = [level_a.levelData bytes];
    for (int i=0; i<5; i++) {
        for (int j=0; j<5; j++) {
            long ncb = cb+i-2;
            long nrb = rb+j-2;
            long nca = ca+i-2;
            long nra = ra+j-2;
            double w = kernel[i]*kernel[j];
            if ((ncb >= 0) && (ncb <= level_b.width) &&
                (nrb >= 0) && (nrb <= level_b.height) &&
                (nca >= 0) && (nca <= level_a.width) &&
                (nra >= 0) && (nra <= level_a.height)) {
                dist += w*w*([IAColorSpace pixelDistOfB:&bytesb[nrb*level_b.bpr+ncb*level_b.bpx] AndA:&bytesa[nra*level_a.bpr+nca*level_a.bpx] InColorSpace:cs]);
                wt += w;
            }
        }
    }
    return dist/(wt*wt);
}

+ (double)neighbourDist3ForB:(IAGausPymLevel *)level_b BCol:(long)cb BRow:(long)rb Bbpr:(size_t)bprb Bbpx:(size_t)bpxb
                        AndA:(IAGausPymLevel *)level_a ACol:(long)ca ARow:(long)ra Abpr:(size_t)bpra Abpx:(size_t)bpxa inColorSpace:(cs_t)cs {
    double kernel[] = {0.25, 0.5, 0.25};
    double dist = 0;
    double wt = 0;
    const uint8_t* bytesb = [level_b.levelData bytes];
    const uint8_t* bytesa = [level_a.levelData bytes];
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            long ncb = cb+i-1;
            long nrb = rb+j-1;
            long nca = ca+i-1;
            long nra = ra+j-1;
            double w = kernel[i]*kernel[j];
            if ((ncb >= 0) && (ncb <= level_b.width) &&
                (nrb >= 0) && (nrb <= level_b.height) &&
                (nca >= 0) && (nca <= level_a.width) &&
                (nra >= 0) && (nra <= level_a.height)) {
                dist += w*w*([IAColorSpace pixelDistOfB:&bytesb[nrb*level_b.bpr+ncb*level_b.bpx] AndA:&bytesa[nra*level_a.bpr+nca*level_a.bpx] InColorSpace:cs]);
                wt += w;
            }
        }
    }
    return dist/(wt*wt);
}

@end
