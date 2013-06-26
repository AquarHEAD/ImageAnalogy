//
//  IAGausPymLevel.h
//  ImageAnalogy
//
//  Created by AquarHEAD L. on 6/26/13.
//  Copyright (c) 2013 Team.TeaWhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAGausPymLevel : NSObject

@property (strong, nonatomic) NSData *levelData;
@property size_t width;
@property size_t height;
@property size_t bpr;
@property size_t bpx;

@end
