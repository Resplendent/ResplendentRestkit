//
//  RKObjectManager+RRKRequests.h
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/7/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "RKObjectManager.h"





@interface RKObjectManager (RRKRequests)

- (RKObjectRequestOperation*)rrk_getRequestCreatedAfterPerformingBlock:(void (^)())createAndEnqueueRequestBlock;

@end
