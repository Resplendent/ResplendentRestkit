//
//  RRKAddRouteIfNotAlreadyAdded.m
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKRouteSet+RRKAddRouteIfNotAlreadyAdded.h"

#import "RUConditionalReturn.h"





@implementation RKRouteSet (RRKAddRouteIfNotAlreadyAdded)

-(BOOL)rrk_containsRoute:(RKRoute *)route
{
	kRUConditionalReturn_ReturnValueFalse(route == nil, YES);
	
	if ([self containsRoute:route])
	{
		return YES;
	}
	
	if (route.isNamedRoute && [self routeForName:route.name])
	{
		return YES;
	}
	
	return NO;
}

-(void)rrk_addRouteIfNotAlreadyAdded:(RKRoute *)route
{
	kRUConditionalReturn([self rrk_containsRoute:route], NO);
	
	[self addRoute:route];
}

@end
