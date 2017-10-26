//
//  RKObjectManager+RRKRequests.m
//  Resplendent
//
//  Created by Benjamin Maer on 11/7/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKObjectManager+RRKRequests.h"

#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/RUClassOrNilUtil.h>





@implementation RKObjectManager (RRKRequests)

-(nullable RKObjectRequestOperation*)rrk_getRequestCreatedAfterPerformingBlock:(void (^ _Nonnull)(void))createAndEnqueueRequestBlock
{
	kRUConditionalReturn_ReturnValueNil(createAndEnqueueRequestBlock == nil, YES);

	NSArray* const previousOperationsArray = [self.operationQueue.operations copy];

	createAndEnqueueRequestBlock();
	
	NSMutableArray* const newOperationsArray = [NSMutableArray arrayWithArray:self.operationQueue.operations];
	[newOperationsArray removeObjectsInArray:previousOperationsArray];
	NSAssert(newOperationsArray.count == 1, @"shouldn't only be 1 new operation");
	
	RKObjectRequestOperation* const newOperation = kRUClassOrNil(newOperationsArray.lastObject, RKObjectRequestOperation);
	NSAssert(newOperation != nil, @"bad operation");
	
	return newOperation;
}

@end
