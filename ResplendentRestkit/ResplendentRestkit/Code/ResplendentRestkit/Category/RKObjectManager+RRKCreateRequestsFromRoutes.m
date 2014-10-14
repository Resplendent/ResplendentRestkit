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





@interface RKObjectManager (_RRKCreateRequestsFromRoutes)

-(NSMutableURLRequest*)rrk_createRestkitAppropriateObjectRequestOperationForRoute:(RKRoute*)route
																		   object:(id)object
																	   parameters:(NSDictionary*)parameters
																		  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																		  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

/*
 if managedObjectContext param is nil, will return rrk_enqueueRestkitRequestOperationForRoute, otherwise rrk_enqueueRestkitManagedObjectRequestOperationForRoute
 */
-(RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:(RKRoute*)route
																				 object:(id)object
																			 parameters:(NSDictionary*)parameters
																	  cancelOldRequests:(BOOL)cancelOldRequests
																   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																				success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																				failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

-(RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:(NSURLRequest*)urlRequest
																		managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																					 success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																					 failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end





@implementation RKObjectManager (_RRKCreateRequestsFromRoutes)

-(NSMutableURLRequest*)rrk_createRestkitAppropriateObjectRequestOperationForRoute:(RKRoute*)route
																		   object:(id)object
																	   parameters:(NSDictionary*)parameters
																		  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																		  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
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
																				success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																				failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
	kRUConditionalReturn_ReturnValueNil(route == nil, YES);

	[self rrk_addRouteIfNotAlreadyAdded:route cancelOldRequests:cancelOldRequests];
	
	NSMutableURLRequest* urlRequest = [self rrk_createRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters success:success failure:failure];

	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:urlRequest managedObjectContext:managedObjectContext success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:(NSURLRequest*)urlRequest
																		managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																					 success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																					 failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
	kRUConditionalReturn_ReturnValueNil(urlRequest == nil, YES);

	RKObjectRequestOperation* requestOperation = (managedObjectContext ?
												  [self managedObjectRequestOperationWithRequest:urlRequest managedObjectContext:managedObjectContext success:success failure:failure] :
												  [self objectRequestOperationWithRequest:urlRequest success:success failure:failure]);
	
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
																  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
																  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
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
															   success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
															   failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForRoute:route object:object parameters:parameters cancelOldRequests:cancelOldRequests managedObjectContext:nil success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectRequestOperationForRoute:(RKRoute*)route
																			 object:(NSManagedObject*)object
																		 parameters:(NSDictionary*)parameters
																  cancelOldRequests:(BOOL)cancelOldRequests
															   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																			success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																			failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
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
																					  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																					  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
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

	} cancelOldRequests:cancelOldRequests managedObjectContext:managedObjectContext success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																						 path:(NSString *)path
																				   parameters:(NSDictionary *)parameters
																					   object:(NSManagedObject*)object
																					formBlock:(void (^)(id <AFMultipartFormData> formData))formBlock
																			cancelOldRequests:(BOOL)cancelOldRequests
																		 managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																					  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																					  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
	NSMutableURLRequest* urlRequest = [self multipartFormRequestWithObject:object method:method path:path parameters:parameters constructingBodyWithBlock:formBlock];

	return [self rrk_enqueueRestkitAppropriateObjectRequestOperationForUrlRequest:urlRequest managedObjectContext:managedObjectContext success:success failure:failure];
}

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectPNGImageUploadRequestOperationForMethod:(RKRequestMethod)method
																							  path:(NSString *)path
																						parameters:(NSDictionary *)parameters
																						  pngImage:(UIImage*)pngImage
																							object:(NSManagedObject*)object
																				 cancelOldRequests:(BOOL)cancelOldRequests
																			  managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																						   success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																						   failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
	return [self rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:method path:path parameters:parameters object:object formBlock:^(id<AFMultipartFormData> formData) {

		[formData appendPartWithFileData:UIImagePNGRepresentation(pngImage)
									name:@"filename"
								fileName:@"photo.png"
								mimeType:@"image/png"];

	} cancelOldRequests:cancelOldRequests managedObjectContext:managedObjectContext success:success failure:failure];
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
