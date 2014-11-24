//
//  RKObjectManager+RRKRequests.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/7/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "RKObjectManager+RRKRequests.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"





@implementation RKObjectManager (RRKRequests)

- (RKObjectRequestOperation*)rrk_getRequestCreatedAfterPerformingBlock:(void (^)())createAndEnqueueRequestBlock
{
	kRUConditionalReturn_ReturnValueNil(createAndEnqueueRequestBlock == nil, YES);

	NSArray* previousOperationsArray = [self.operationQueue.operations copy];

	createAndEnqueueRequestBlock();
	
	NSMutableArray* newOperationsArray = [NSMutableArray arrayWithArray:self.operationQueue.operations];
	[newOperationsArray removeObjectsInArray:previousOperationsArray];
	NSAssert(newOperationsArray.count == 1, @"shouldn't only be 1 new operation");
	
	RKObjectRequestOperation* newOperation = kRUClassOrNil(newOperationsArray.lastObject, RKObjectRequestOperation);
	NSAssert(newOperation != nil, @"bad operation");
	
	return newOperation;
}

@end
