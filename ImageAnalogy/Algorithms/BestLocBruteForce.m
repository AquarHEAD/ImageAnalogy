//
//  BestLocBruteForce.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "BestLocBruteForce.h"

@implementation BestLocBruteForce

+ (result_bf *)findBestLocationThisLevelB:(IAGausPymLevel *)thisLevelB thisLevelA:(IAGausPymLevel *)thisLevelA nextLevelB:(IAGausPymLevel *)nextLevelB nextLevelA:(IAGausPymLevel *)nextLevelA colb:(long)colb rowb:(long)rowb isLastLevel:(BOOL)lastLevel withLevelWeight:(double)lw inColorSpace:(cs_t)cs {
    result_bf *r = malloc(sizeof(result_bf));
    r->bestdist = 0;
    
    for (long cola=0; cola < thisLevelA.width; cola++) {
        for (long rowa=0; rowa < thisLevelA.height; rowa++) {
            // calc each pixel in A, the dist to the pixel in B
            double dist = 0;
            if (lastLevel) {
                double dist1 = [BestLocBruteForce neighbourDist5ForB:thisLevelB BCol:colb BRow:rowb Bbpr:thisLevelB.bpr Bbpx:thisLevelB.bpx AndA:thisLevelA ACol:cola ARow:rowa Abpr:thisLevelA.bpr Abpx:thisLevelA.bpx inColorSpace:cs];
                double dist2 = [BestLocBruteForce neighbourDist3ForB:nextLevelB BCol:colb/2 BRow:rowb/2 Bbpr:nextLevelB.bpr Bbpx:nextLevelB.bpx AndA:nextLevelA ACol:cola/2 ARow:rowa/2 Abpr:nextLevelA.bpr Abpx:nextLevelA.bpx inColorSpace:cs];
                dist = dist1 + lw*lw*dist2;
            }
            else {
                dist = [BestLocBruteForce neighbourDist5ForB:thisLevelB BCol:colb BRow:rowb Bbpr:thisLevelB.bpr Bbpx:thisLevelB.bpx AndA:thisLevelA ACol:cola ARow:rowa Abpr:thisLevelA.bpr Abpx:thisLevelA.bpx inColorSpace:cs];
            }
            if ((dist < r->bestdist) || ((cola==0) && (rowa==0))) {
                r->bestdist = dist;
                r->bestcol = cola;
                r->bestrow = rowa;
            }
            // end calc bestdist
        }
    }
    
    return r;
}

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
