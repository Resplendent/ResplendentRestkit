//
//  NSDictionary+RRKPropertyMappings.m
//  Resplendent
//
//  Created by Benjamin Maer on 11/23/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "NSDictionary+RRKPropertyMappings.h"

#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/RUClassOrNilUtil.h>

@import RestKit;





@implementation NSDictionary (RRKPropertyMappings)

-(RKPropertyMapping*)rrk_RKPropertyMappingForDestinationKeyPath:(NSString*)destinationKeyPath
{
	id propertyMapping = [self objectForKey:destinationKeyPath];
	kRUConditionalReturn_ReturnValueNil(kRUClassOrNil(propertyMapping, RKPropertyMapping) == nil, YES);
	
	return propertyMapping;
}

-(NSString*)rrk_RKPropertyMappingSourceKeyPathForDestinationKeyPath:(NSString*)destinationKeyPath
{
	return [self rrk_RKPropertyMappingForDestinationKeyPath:destinationKeyPath].sourceKeyPath;
}

@end
