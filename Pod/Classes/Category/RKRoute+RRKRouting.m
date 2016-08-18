//
//  RKRoute+RRKRouting.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/22/14.
//  Copyright (c) 2014 Resplendent All rights reserved.
//

#import "RKRoute+RRKRouting.h"

#import <objc/runtime.h>
#import "RUConditionalReturn.h"





@implementation RKRoute (RRKRouting)

+(nullable instancetype)rrk_RouteWithName:(nonnull NSString*)name pathPattern:(nonnull NSString*)pathPattern requestMethod:(RKRequestMethod)requestMethod objectClass:(nullable Class)objectClass
{
	kRUConditionalReturn_ReturnValueNil(name.length == 0, YES);
	kRUConditionalReturn_ReturnValueNil(pathPattern == nil, YES);
	
	if (objectClass)
	{
		kRUConditionalReturn_ReturnValueNil(class_isMetaClass(object_getClass(objectClass)) == false, YES);
		return [RKRoute routeWithRelationshipName:name objectClass:objectClass pathPattern:pathPattern method:requestMethod];
	}
	else
	{
		return [RKRoute routeWithName:name pathPattern:pathPattern method:requestMethod];
	}
}

@end
