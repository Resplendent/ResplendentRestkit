//
//  RKObjectManager+RRKAddDescriptorsIfNotAlreadyAdded.m
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKObjectManager+RRKAddDescriptorsIfNotAlreadyAdded.h"

#import <RestKit.h>





@interface RKResponseDescriptor (RRK_DescriptorHelper)

-(RKResponseDescriptor*)rrk_responseDescriptorForComparing;

@end

@implementation RKResponseDescriptor (RRK_DescriptorHelper)

-(RKResponseDescriptor*)rrk_responseDescriptorForComparing
{
	if (self.keyPath == nil)
	{
		return [self.class responseDescriptorWithMapping:self.mapping method:self.method pathPattern:self.pathPattern keyPath:@"" statusCodes:self.statusCodes];
	}
	else
	{
		return self;
	}
}

@end





@interface RKRequestDescriptor (RRK_DescriptorHelper)

-(RKRequestDescriptor*)rrk_requestDescriptorForComparing;

@end

@implementation RKRequestDescriptor (RRK_DescriptorHelper)

-(RKRequestDescriptor*)rrk_requestDescriptorForComparing
{
	if (self.rootKeyPath == nil)
	{
		return [self.class requestDescriptorWithMapping:self.mapping objectClass:self.objectClass rootKeyPath:@"" method:self.method];
	}
	else
	{
		return self;
	}
}

@end





@implementation RKObjectManager (RRKAddDescriptorsIfNotAlreadyAdded)

-(void)rrk_addResponseDescriptorIfDoesNotAlreadyExist:(RKResponseDescriptor*)responseDescriptor
{
	if (responseDescriptor == nil)
	{
		NSAssert(FALSE, @"must pass a response descriptor");
		return;
	}
	
	RKResponseDescriptor* responseDescriptorForComparing = responseDescriptor.rrk_responseDescriptorForComparing;
	
	for (RKResponseDescriptor* existingResponseDescriptor in self.responseDescriptors)
	{
		RKResponseDescriptor* existingResponseDescriptorForComparing = existingResponseDescriptor.rrk_responseDescriptorForComparing;
		if ([responseDescriptorForComparing isEqualToResponseDescriptor:existingResponseDescriptorForComparing])
		{
			return;
		}
	}
	
	[self addResponseDescriptor:responseDescriptor];
}

-(void)rrk_addRequestDescriptorIfDoesNotAlreadyExist:(RKRequestDescriptor*)requestDescriptor
{
	if (requestDescriptor == nil)
	{
		NSAssert(FALSE, @"must pass a request descriptor");
		return;
	}
	
	RKRequestDescriptor* requestDescriptorForComparing = requestDescriptor.rrk_requestDescriptorForComparing;
	
	for (RKRequestDescriptor* existingRequestDescriptor in self.requestDescriptors)
	{
		RKRequestDescriptor* existingRequestDescriptorForComparing = existingRequestDescriptor.rrk_requestDescriptorForComparing;
		if ([requestDescriptorForComparing isEqualToRequestDescriptor:existingRequestDescriptorForComparing])
		{
			return;
		}
	}
	
	[self addRequestDescriptor:requestDescriptor];
}

@end
