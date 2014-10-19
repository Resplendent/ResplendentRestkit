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
	
	if (route.isNamedRoute)
	{
		return ([self routeForName:route.name] != nil);
	}

	if (route.isRelationshipRoute)
	{
		NSArray *routes = [self routesForRelationship:route.name ofClass:route.objectClass];
		for (RKRoute *existingRoute in routes)
		{
			if (existingRoute.method == route.method)
			{
				return YES;
			}
		}

		return NO;
	}

	if (route.isClassRoute)
	{
		return ([self routeForClass:route.objectClass method:route.method] != nil);
	}

	NSAssert(false, @"unhandled");
	return NO;
}

-(void)rrk_addRouteIfNotAlreadyAdded:(RKRoute *)route
{
	kRUConditionalReturn([self rrk_containsRoute:route], NO);
	
	[self addRoute:route];
}

@end
