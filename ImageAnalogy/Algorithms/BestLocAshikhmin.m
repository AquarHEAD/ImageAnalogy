//
//  BestLocAshikhmin.m
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import "BestLocAshikhmin.h"
#import "Location.h"

@implementation BestLocAshikhmin

+ (algo_result *)findBestLocationThisLevelB:(IAGausPymLevel *)thisLevelB thisLevelA:(IAGausPymLevel *)thisLevelA nextLevelB:(IAGausPymLevel *)nextLevelB nextLevelA:(IAGausPymLevel *)nextLevelA colb:(long)colb rowb:(long)rowb isLastLevel:(BOOL)lastLevel useTwoLevel:(BOOL)twoLevel withThisS:(NSMutableArray *)this_s andLastS:(NSArray *)old_s withLevelWeight:(double)lw inColorSpace:(cs_t)cs {
    algo_result *r = malloc(sizeof(algo_result));
    r->bestdist = -1;
    if (twoLevel) {
        
    }
    else {
        NSArray *predicts = [BestLocAshikhmin predictThisLevelB:thisLevelB thisLevelA:thisLevelA colb:colb rowb:rowb withLastS:this_s];
        for (Location *p in predicts) {
            double dist = 0;
            long rowa = p.row;
            long cola = p.col;
            if (lastLevel) {
                double dist1 = [BestLocBruteForce neighbourDist5ForB:thisLevelB BCol:colb BRow:rowb Bbpr:thisLevelB.bpr Bbpx:thisLevelB.bpx AndA:thisLevelA ACol:cola ARow:rowa Abpr:thisLevelA.bpr Abpx:thisLevelA.bpx inColorSpace:cs];
                double dist2 = [BestLocBruteForce neighbourDist3ForB:nextLevelB BCol:colb/2 BRow:rowb/2 Bbpr:nextLevelB.bpr Bbpx:nextLevelB.bpx AndA:nextLevelA ACol:cola/2 ARow:rowa/2 Abpr:nextLevelA.bpr Abpx:nextLevelA.bpx inColorSpace:cs];
                dist = dist1 + lw*lw*dist2;
            }
            else {
                dist = [BestLocBruteForce neighbourDist5ForB:thisLevelB BCol:colb BRow:rowb Bbpr:thisLevelB.bpr Bbpx:thisLevelB.bpx AndA:thisLevelA ACol:cola ARow:rowa Abpr:thisLevelA.bpr Abpx:thisLevelA.bpx inColorSpace:cs];
            }
            if ((dist < r->bestdist) || (r->bestdist == -1)) {
                r->bestdist = dist;
                r->bestcol = cola;
                r->bestrow = rowa;
                Location *l = [this_s objectAtIndex:rowb*thisLevelB.width+colb];
                l.row = rowa;
                l.col = cola;
            }
        }
    }
    return r;
}

+ (NSArray *)predictThisLevelB:(IAGausPymLevel *)thisLevelB thisLevelA:(IAGausPymLevel *)thisLevelA colb:(long)colb rowb:(long)rowb withLastS:(NSMutableArray *)s {
    NSArray *r = [NSArray new];
    for (long i=-2; i<1; i++) {
        for (long j=-2; j<0 || ((i<0) && (j<3)); j++) {
            long nr = rowb+i;
            long nc = colb+j;
            if ((nr >= 0) && (nr < thisLevelB.height) && (nc >= 0) && (nc < thisLevelB.width)) {
                Location *l = [s objectAtIndex:nr*thisLevelB.width+nc];
                long tr = l.row - i;
                long tc = l.col - j;
                if ((tr >= 0) && (tr < thisLevelB.height) && (tc >= 0) && (tc < thisLevelB.width)) {
                    r = [BestLocAshikhmin noRepAddPredictIn:r Row:tr Col:tc];
                }
                else {
                    // give a random predict
                    tr = (long)arc4random_uniform((u_int32_t)thisLevelA.height);
                    tc = (long)arc4random_uniform((u_int32_t)thisLevelA.width);
                    r = [BestLocAshikhmin noRepAddPredictIn:r Row:tr Col:tc];
                }
            }
            else {
                long tr = (long)arc4random_uniform((u_int32_t)thisLevelA.height);
                long tc = (long)arc4random_uniform((u_int32_t)thisLevelA.width);
                r = [BestLocAshikhmin noRepAddPredictIn:r Row:tr Col:tc];
            }
        }
    }
    return r;
}

+ (NSArray *)noRepAddPredictIn:(NSArray *)arr Row:(long)tr Col:(long)tc {
    NSMutableArray *r = [arr mutableCopy];
    BOOL rep = NO;
    for (Location *p in r) {
        if ((p.row == tr) || (p.col == tc)) {
            rep = YES;
            break;
        }
    }
    if (!rep) {
        Location *np = [Location new];
        np.row = tr;
        np.col = tc;
        [r addObject:np];
    }
    return [r copy];
}

@end
