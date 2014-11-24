//
//  RKRoute+RRKRouting.m
//  Shimmur
//
//  Created by Benjamin Maer on 10/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RKRoute+RRKRouting.h"

#import <objc/runtime.h>
#import "RUConditionalReturn.h"





@implementation RKRoute (RRKRouting)

+(instancetype)rrk_RouteWithName:(NSString*)name pathPattern:(NSString*)pathPattern requestMethod:(RKRequestMethod)requestMethod objectClass:(Class)objectClass
{
	kRUConditionalReturn_ReturnValueNil(name.length == 0, YES);
	kRUConditionalReturn_ReturnValueNil(pathPattern.length == 0, YES);
	
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
