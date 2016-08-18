//
//  RKObjectManager+RRKCreateRequestsFromRoutes.m
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKObjectManager+RRKCreateRequestsFromRoutes.h"
#import "RKRouteSet+RRKAddRouteIfNotAlreadyAdded.h"
#import "RKObjectManager+RRKRequests.h"

#import <ResplendentUtilities/RUConditionalReturn.h>

@import RestKit;





#define kRKObjectManager__enqueueRestkitAppropriateObjectRequestOperation_UseNativeMethodAndOperationsHackIfGetOperationsAndRelationshipRoute (1)	//Necessary for routing





@interface RKObjectManager (_RRKCreateRequestsFromRoutes)

-(nullable NSMutableURLRequest*)rrk_createRestkitAppropriateObjectRequestOperationForRoute:(nonnull RKRoute*)route
																					object:(nullable id)object
																				parameters:(nullable NSDictionary*)parameters
																				   success:(nullable rrk_rkOperationAndMappingResultBlock)success
																				   failure:(nullable rrk_rkOperationAndErrorBlock)failure;

/*
 if managedObjectContext param is nil, will return rrk_enqueueRestkitRequestOperationForRoute, otherwise rrk_enqueueRestkitManagedObjectRequestOperationForRoute
 */
-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:(nonnull RKRoute*)route
																						  object:(nullable id)object
																					  parameters:(nullable NSDictionary*)parameters
																			   cancelOldRequests:(BOOL)cancelOldRequests
																			managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																						 success:(nullable rrk_rkOperationAndMappingResultBlock)success
																						 failure:(nullable rrk_rkOperationAndErrorBlock)failure;

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:(nonnull NSURLRequest*)urlRequest
																				 managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																				  uploadProgressBlock:(nullable rrk_uploadProgressBlock)uploadProgressBlock
																							  success:(nullable rrk_rkOperationAndMappingResultBlock)success
																							  failure:(nullable rrk_rkOperationAndErrorBlock)failure;

@end





@implementation RKObjectManager (_RRKCreateRequestsFromRoutes)

-(nullable NSMutableURLRequest*)rrk_createRestkitAppropriateObjectRequestOperationForRoute:(nonnull RKRoute*)route
																					object:(nullable id)object
																				parameters:(nullable NSDictionary*)parameters
																				   success:(nullable rrk_rkOperationAndMappingResultBlock)success
																				   failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	kRUConditionalReturn_ReturnValueNil(route == nil, YES);
	kRUConditionalReturn_ReturnValueNil(route.isClassRoute, YES);	//Shouldn't get here

	if (route.isNamedRoute)
	{
		return [self requestWithPathForRouteNamed:route.name object:object parameters:parameters];
	}
	else if (route.isRelationshipRoute)
	{
		return [self requestWithPathForRelationship:route.name ofObject:object method:route.method parameters:parameters];
	}
	else
	{
		NSAssert(false, @"unhandled");
		return nil;
	}
}

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:(nonnull RKRoute*)route
																						  object:(nullable id)object
																					  parameters:(nullable NSDictionary*)parameters
																			   cancelOldRequests:(BOOL)cancelOldRequests
																			managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																						 success:(nullable rrk_rkOperationAndMappingResultBlock)success
																						 failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	kRUConditionalReturn_ReturnValueNil(route == nil, YES);

	[self rrk_addRouteIfNotAlreadyAdded:route cancelOldRequests:cancelOldRequests];

#if kRKObjectManager__enqueueRestkitAppropriateObjectRequestOperation_UseNativeMethodAndOperationsHackIfGetOperationsAndRelationshipRoute
	if (route.method == RKRequestMethodGET)
	{
		if (route.isRelationshipRoute)
		{
			return [self rrk_getRequestCreatedAfterPerformingBlock:^{

				[self getObjectsAtPathForRelationship:route.name ofObject:object parameters:parameters success:success failure:failure];

			}];
		}
		else if (route.isNamedRoute)
		{
			return [self rrk_getRequestCreatedAfterPerformingBlock:^{

				[self getObjectsAtPathForRouteNamed:route.name object:object parameters:parameters success:success failure:failure];

			}];
		}

	}
#endif

	if (route.isClassRoute)
	{
		RKObjectRequestOperation* const objectRequestOperation = [self appropriateObjectRequestOperationWithObject:object method:route.method path:nil parameters:parameters];
		kRUConditionalReturn_ReturnValueNil(objectRequestOperation == nil, YES);

		[objectRequestOperation setCompletionBlockWithSuccess:success failure:failure];

		[self enqueueObjectRequestOperation:objectRequestOperation];

		return objectRequestOperation;
	}
	else
	{
		NSMutableURLRequest* const urlRequest = [self rrk_createRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters success:success failure:failure];

		return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:urlRequest managedObjectContext:managedObjectContext uploadProgressBlock:nil success:success failure:failure];
	}
}

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:(nonnull NSURLRequest*)urlRequest
																				 managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																				  uploadProgressBlock:(nullable rrk_uploadProgressBlock)uploadProgressBlock
																							  success:(nullable rrk_rkOperationAndMappingResultBlock)success
																							  failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	kRUConditionalReturn_ReturnValueNil(urlRequest == nil, YES);

	RKObjectRequestOperation* const requestOperation = (managedObjectContext ?
												  [self managedObjectRequestOperationWithRequest:urlRequest managedObjectContext:managedObjectContext success:success failure:failure] :
												  [self objectRequestOperationWithRequest:urlRequest success:success failure:failure]);

	[requestOperation.HTTPRequestOperation setUploadProgressBlock:uploadProgressBlock];

	[self enqueueObjectRequestOperation:requestOperation];

	return requestOperation;
}

@end





@implementation RKObjectManager (RRKCreateRequestsFromRoutes)

#pragma mark - Restkit requests
-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitRequestOperationForRoute:(nonnull RKRoute*)route
																		 object:(nullable id)object
																	 parameters:(nullable NSDictionary*)parameters
															  cancelOldRequests:(BOOL)cancelOldRequests
																		success:(nullable rrk_rkOperationAndMappingResultBlock)success
																		failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters cancelOldRequests:cancelOldRequests managedObjectContext:nil success:success failure:failure];
}

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectRequestOperationForRoute:(nonnull RKRoute*)route
																					  object:(nullable NSManagedObject*)object
																				  parameters:(nullable NSDictionary*)parameters
																		   cancelOldRequests:(BOOL)cancelOldRequests
																		managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																					 success:(nullable rrk_rkOperationAndMappingResultBlock)success
																					 failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters cancelOldRequests:cancelOldRequests  managedObjectContext:managedObjectContext success:success failure:failure];
}

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																								  path:(nonnull NSString*)path
																							parameters:(nullable NSDictionary*)parameters
																								object:(nullable NSManagedObject*)object
																							 formBlock:(nullable rrk_AFRKMultipartFormData_block)formBlock
																					 cancelOldRequests:(BOOL)cancelOldRequests
																				  managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																				   uploadProgressBlock:(nullable rrk_uploadProgressBlock)uploadProgressBlock
																							   success:(nullable rrk_rkOperationAndMappingResultBlock)success
																							   failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	NSAssert(path.length > 0, @"Needs a path");	//Not sure if we should return here, for now I will not.

	NSMutableURLRequest* const urlRequest = [self multipartFormRequestWithObject:object method:method path:path parameters:parameters constructingBodyWithBlock:formBlock];

	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:urlRequest managedObjectContext:managedObjectContext uploadProgressBlock:uploadProgressBlock success:success failure:failure];
}

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																								  path:(nonnull NSString*)path
																							parameters:(nullable NSDictionary*)parameters
																								object:(nullable NSManagedObject*)object
																							uploadData:(nonnull NSData*)uploadData
																								  name:(nonnull NSString*)name
																							  fileName:(nonnull NSString*)fileName
																							  mimeType:(nonnull NSString*)mimeType
																					 cancelOldRequests:(BOOL)cancelOldRequests
																				  managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																				   uploadProgressBlock:(nullable rrk_uploadProgressBlock)uploadProgressBlock
																							   success:(nullable rrk_rkOperationAndMappingResultBlock)success
																							   failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	return [self rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:method path:path parameters:parameters object:object formBlock:^(id<AFRKMultipartFormData> formData) {

		[formData appendPartWithFileData:uploadData
									name:name
								fileName:fileName
								mimeType:mimeType];

	} cancelOldRequests:cancelOldRequests managedObjectContext:managedObjectContext uploadProgressBlock:uploadProgressBlock success:success failure:failure];
}

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectPNGImageUploadRequestOperationForMethod:(RKRequestMethod)method
																									   path:(nonnull NSString*)path
																								 parameters:(nullable NSDictionary*)parameters
																								   pngImage:(nonnull UIImage*)pngImage
																									 object:(nullable NSManagedObject*)object
																						  cancelOldRequests:(BOOL)cancelOldRequests
																					   managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																						uploadProgressBlock:(nullable rrk_uploadProgressBlock)uploadProgressBlock
																									success:(nullable rrk_rkOperationAndMappingResultBlock)success
																									failure:(nullable rrk_rkOperationAndErrorBlock)failure
{
	return [self rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:method path:path parameters:parameters object:object formBlock:^(id<AFRKMultipartFormData> formData) {

		[formData appendPartWithFileData:UIImagePNGRepresentation(pngImage)
									name:@"filename"
								fileName:@"photo.png"
								mimeType:[self.class mimeTypeForImageType:RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_PNG]];

	} cancelOldRequests:cancelOldRequests managedObjectContext:managedObjectContext uploadProgressBlock:uploadProgressBlock success:success failure:failure];
}

#pragma mark - Image Type
+(nullable NSString*)mimeTypeForImageType:(RRKCreateRequestsFromRoutes_RKObjectManager_ImageType)imageType
{
	switch (imageType)
	{
		case RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_PNG:
			return @"image/png";
			break;

		case RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_JPEG:
			return @"image/jpeg";
			break;
	}

	NSAssert(false, @"unhandled");
	return nil;
}

#pragma mark - Add Route and cancel
-(void)rrk_addRouteIfNotAlreadyAdded:(nonnull RKRoute*)route cancelOldRequests:(BOOL)cancelOldRequests
{
	kRUConditionalReturn(route == nil, YES);

	[self.router.routeSet rrk_addRouteIfNotAlreadyAdded:route];

	if (cancelOldRequests)
	{
		[self cancelAllObjectRequestOperationsWithMethod:route.method matchingPathPattern:route.pathPattern];
	}
}

@end
