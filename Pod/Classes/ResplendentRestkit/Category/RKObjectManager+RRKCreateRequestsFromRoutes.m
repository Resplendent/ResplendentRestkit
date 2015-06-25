//
//  RKObjectManager+RRKCreateRequestsFromRoutes.m
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKObjectManager+RRKCreateRequestsFromRoutes.h"
#import "RKRouteSet+RRKAddRouteIfNotAlreadyAdded.h"
#import "RUConditionalReturn.h"
#import "RKObjectManager+RRKRequests.h"





#define kRKObjectManager__enqueueRestkitAppropriateObjectRequestOperation_UseNativeMethodAndOperationsHackIfGetOperationsAndRelationshipRoute (1)	//Necessary for routing





@interface RKObjectManager (_RRKCreateRequestsFromRoutes)

-(NSMutableURLRequest*)rrk_createRestkitAppropriateObjectRequestOperationForRoute:(RKRoute*)route
																		   object:(id)object
																	   parameters:(NSDictionary*)parameters
																		  success:(rrk_rkOperationAndMappingResultBlock)success
																		  failure:(rrk_rkOperationAndErrorBlock)failure;

/*
 if managedObjectContext param is nil, will return rrk_enqueueRestkitRequestOperationForRoute, otherwise rrk_enqueueRestkitManagedObjectRequestOperationForRoute
 */
-(RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:(RKRoute*)route
																				 object:(id)object
																			 parameters:(NSDictionary*)parameters
																	  cancelOldRequests:(BOOL)cancelOldRequests
																   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																				success:(rrk_rkOperationAndMappingResultBlock)success
																				failure:(rrk_rkOperationAndErrorBlock)failure;

-(RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:(NSURLRequest*)urlRequest
																		managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																		 uploadProgressBlock:(rrk_uploadProgressBlock)uploadProgressBlock
																					 success:(rrk_rkOperationAndMappingResultBlock)success
																					 failure:(rrk_rkOperationAndErrorBlock)failure;

@end





@implementation RKObjectManager (_RRKCreateRequestsFromRoutes)

-(NSMutableURLRequest*)rrk_createRestkitAppropriateObjectRequestOperationForRoute:(RKRoute*)route
																		   object:(id)object
																	   parameters:(NSDictionary*)parameters
																		  success:(rrk_rkOperationAndMappingResultBlock)success
																		  failure:(rrk_rkOperationAndErrorBlock)failure
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

-(RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:(RKRoute*)route
																				 object:(id)object
																			 parameters:(NSDictionary*)parameters
																	  cancelOldRequests:(BOOL)cancelOldRequests
																   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																				success:(rrk_rkOperationAndMappingResultBlock)success
																				failure:(rrk_rkOperationAndErrorBlock)failure
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
		RKObjectRequestOperation* objectRequestOperation = [self appropriateObjectRequestOperationWithObject:object method:route.method path:nil parameters:parameters];
		kRUConditionalReturn_ReturnValueNil(objectRequestOperation == nil, YES);

		[objectRequestOperation setCompletionBlockWithSuccess:success failure:failure];

		[self enqueueObjectRequestOperation:objectRequestOperation];

		return objectRequestOperation;
	}
	else
	{
		NSMutableURLRequest* urlRequest = [self rrk_createRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters success:success failure:failure];
		
		return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:urlRequest managedObjectContext:managedObjectContext uploadProgressBlock:nil success:success failure:failure];
	}
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:(NSURLRequest*)urlRequest
																		managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																		 uploadProgressBlock:(rrk_uploadProgressBlock)uploadProgressBlock
																					 success:(rrk_rkOperationAndMappingResultBlock)success
																					 failure:(rrk_rkOperationAndErrorBlock)failure
{
	kRUConditionalReturn_ReturnValueNil(urlRequest == nil, YES);

	RKObjectRequestOperation* requestOperation = (managedObjectContext ?
												  [self managedObjectRequestOperationWithRequest:urlRequest managedObjectContext:managedObjectContext success:success failure:failure] :
												  [self objectRequestOperationWithRequest:urlRequest success:success failure:failure]);

	[requestOperation.HTTPRequestOperation setUploadProgressBlock:uploadProgressBlock];
	
	[self enqueueObjectRequestOperation:requestOperation];
	
	return requestOperation;
}

@end





@implementation RKObjectManager (RRKCreateRequestsFromRoutes)

#pragma mark - AFNetworking Requests
-(AFHTTPRequestOperation*)rrk_enqueueAFNetworkingRequestOperationForRoute:(RKRoute*)route
																   object:(id)object
															   parameters:(NSDictionary*)parameters
														cancelOldRequests:(BOOL)cancelOldRequests
																  success:(rrk_afOperationAndResponseObjectBlock)success
																  failure:(rrk_afOperationAndErrorBlock)failure
{
	kRUConditionalReturn_ReturnValueNil(route == nil, YES);

	[self.router.routeSet rrk_addRouteIfNotAlreadyAdded:route];
	
	NSMutableURLRequest* urlRequest = [self requestWithPathForRouteNamed:route.name object:object parameters:parameters];
	kRUConditionalReturn_ReturnValueNil(urlRequest == nil, YES);
	
	AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:urlRequest];
	kRUConditionalReturn_ReturnValueNil(requestOperation == nil, YES);

	if (cancelOldRequests)
	{
		[self.HTTPClient cancelAllHTTPOperationsWithMethod:requestOperation.request.HTTPMethod path:requestOperation.request.URL.path];
	}

	[requestOperation setCompletionBlockWithSuccess:success failure:failure];
	
	[self.HTTPClient enqueueHTTPRequestOperation:requestOperation];
	
	return requestOperation;
}

#pragma mark - Restkit requests
-(RKObjectRequestOperation*)rrk_enqueueRestkitRequestOperationForRoute:(RKRoute*)route
																object:(id)object
															parameters:(NSDictionary*)parameters
													 cancelOldRequests:(BOOL)cancelOldRequests
															   success:(rrk_rkOperationAndMappingResultBlock)success
															   failure:(rrk_rkOperationAndErrorBlock)failure
{
	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters cancelOldRequests:cancelOldRequests managedObjectContext:nil success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectRequestOperationForRoute:(RKRoute*)route
																			 object:(NSManagedObject*)object
																		 parameters:(NSDictionary*)parameters
																  cancelOldRequests:(BOOL)cancelOldRequests
															   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																			success:(rrk_rkOperationAndMappingResultBlock)success
																			failure:(rrk_rkOperationAndErrorBlock)failure
{
	kRUConditionalReturn_ReturnValueNil(managedObjectContext == nil, YES);

	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters cancelOldRequests:cancelOldRequests  managedObjectContext:managedObjectContext success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																						 path:(NSString *)path
																				   parameters:(NSDictionary *)parameters
																					   object:(NSManagedObject*)object
																				   uploadData:(NSData*)uploadData
																						 name:(NSString*)name
																					 fileName:(NSString*)fileName
																					 mimeType:(NSString*)mimeType
																			cancelOldRequests:(BOOL)cancelOldRequests
																		 managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																		  uploadProgressBlock:(rrk_uploadProgressBlock)uploadProgressBlock
																					  success:(rrk_rkOperationAndMappingResultBlock)success
																					  failure:(rrk_rkOperationAndErrorBlock)failure
{
	return [self rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:method path:path parameters:parameters object:object formBlock:^(id<AFMultipartFormData> formData) {
		
		[formData appendPartWithFileData:uploadData
									name:name
								fileName:fileName
								mimeType:mimeType];
		
//		[formData appendPartWithFileData:uploadData
//									name:@"expense[photo_file]"
//								fileName:@"photo.jpg"
//								mimeType:@"image/jpeg"];

	} cancelOldRequests:cancelOldRequests managedObjectContext:managedObjectContext uploadProgressBlock:uploadProgressBlock success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																						 path:(NSString *)path
																				   parameters:(NSDictionary *)parameters
																					   object:(NSManagedObject*)object
																					formBlock:(void (^)(id <AFMultipartFormData> formData))formBlock
																			cancelOldRequests:(BOOL)cancelOldRequests
																		 managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																		  uploadProgressBlock:(rrk_uploadProgressBlock)uploadProgressBlock
																					  success:(rrk_rkOperationAndMappingResultBlock)success
																					  failure:(rrk_rkOperationAndErrorBlock)failure
{
	NSMutableURLRequest* urlRequest = [self multipartFormRequestWithObject:object method:method path:path parameters:parameters constructingBodyWithBlock:formBlock];

	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:urlRequest managedObjectContext:managedObjectContext uploadProgressBlock:uploadProgressBlock success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectPNGImageUploadRequestOperationForMethod:(RKRequestMethod)method
																							  path:(NSString *)path
																						parameters:(NSDictionary *)parameters
																						  pngImage:(UIImage*)pngImage
																							object:(NSManagedObject*)object
																				 cancelOldRequests:(BOOL)cancelOldRequests
																			  managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																			   uploadProgressBlock:(rrk_uploadProgressBlock)uploadProgressBlock
																						   success:(rrk_rkOperationAndMappingResultBlock)success
																						   failure:(rrk_rkOperationAndErrorBlock)failure
{
	return [self rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:method path:path parameters:parameters object:object formBlock:^(id<AFMultipartFormData> formData) {

		[formData appendPartWithFileData:UIImagePNGRepresentation(pngImage)
									name:@"filename"
								fileName:@"photo.png"
								mimeType:[self.class mimeTypeForImageType:RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_PNG]];

	} cancelOldRequests:cancelOldRequests managedObjectContext:managedObjectContext uploadProgressBlock:uploadProgressBlock success:success failure:failure];
}

#pragma mark - Image Type
+(NSString*)mimeTypeForImageType:(RRKCreateRequestsFromRoutes_RKObjectManager_ImageType)imageType
{
	switch (imageType)
	{
		case RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_PNG:
			return @"image/png";
		case RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_JPEG:
			return @"image/jpeg";
	}

	NSAssert(false, @"unhandled");
	return nil;
}

#pragma mark - Add Route and cancel
-(void)rrk_addRouteIfNotAlreadyAdded:(RKRoute*)route cancelOldRequests:(BOOL)cancelOldRequests
{
	kRUConditionalReturn(route == nil, YES);
	
	[self.router.routeSet rrk_addRouteIfNotAlreadyAdded:route];
	
	if (cancelOldRequests)
	{
		[self cancelAllObjectRequestOperationsWithMethod:route.method matchingPathPattern:route.pathPattern];
	}
}

@end
