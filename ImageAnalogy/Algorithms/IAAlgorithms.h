//
//  IAAlgorithms.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BestLocBruteForce.h"
#import "BestLocAshikhmin.h"

typedef enum {
    AlgoBruteForce = 0,
    AlgoAshikhmin,
    AlgoANN,
    AlgoAshANN
} algos;

@interface IAAlgorithms : NSObject

@end
