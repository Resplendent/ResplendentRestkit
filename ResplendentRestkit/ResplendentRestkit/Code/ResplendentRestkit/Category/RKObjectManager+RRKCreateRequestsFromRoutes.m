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

/*
 if managedObjectContext param is nil, will return rkk_enqueueRestkitRequestOperationForRoute, otherwise rkk_enqueueRestkitManagedObjectRequestOperationForRoute
 */
-(RKObjectRequestOperation*)rkk_enqueueRestkitPossibleManagedObjectRequestOperationForRoute:(RKRoute*)route
																				 parameters:(NSDictionary*)parameters
																	   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																					success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																					failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end





@implementation RKObjectManager (_RRKCreateRequestsFromRoutes)

-(RKObjectRequestOperation*)rkk_enqueueRestkitPossibleManagedObjectRequestOperationForRoute:(RKRoute*)route
																				 parameters:(NSDictionary*)parameters
																	   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																					success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																					failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
	kRUConditionalReturn_ReturnValueNil(route == nil, YES);
	
	[self.router.routeSet rrk_addRouteIfNotAlreadyAdded:route];
	
	[self cancelAllObjectRequestOperationsWithMethod:route.method matchingPathPattern:route.pathPattern];
	
	NSMutableURLRequest* urlRequest = [self requestWithPathForRouteNamed:route.name object:nil parameters:parameters];
	kRUConditionalReturn_ReturnValueNil(urlRequest == nil, YES);
	
	RKObjectRequestOperation* requestOperation = (managedObjectContext ?
												  [self managedObjectRequestOperationWithRequest:urlRequest managedObjectContext:managedObjectContext success:success failure:failure] :
												  [self objectRequestOperationWithRequest:urlRequest success:success failure:failure]);
	
	[self enqueueObjectRequestOperation:requestOperation];
	
	return requestOperation;
}

@end





@implementation RKObjectManager (RRKCreateRequestsFromRoutes)

-(AFHTTPRequestOperation*)rkk_enqueueAFNetworkingRequestOperationForRoute:(RKRoute*)route
																		parameters:(NSDictionary*)parameters
																		   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
																		   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	kRUConditionalReturn_ReturnValueNil(route == nil, YES);

	[self.router.routeSet rrk_addRouteIfNotAlreadyAdded:route];
	
	NSMutableURLRequest* urlRequest = [self requestWithPathForRouteNamed:route.name object:nil parameters:parameters];
	kRUConditionalReturn_ReturnValueNil(urlRequest == nil, YES);
	
	AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:urlRequest];
	kRUConditionalReturn_ReturnValueNil(requestOperation == nil, YES);
	
	[self.HTTPClient cancelAllHTTPOperationsWithMethod:requestOperation.request.HTTPMethod path:requestOperation.request.URL.path];
	
	[requestOperation setCompletionBlockWithSuccess:success failure:failure];
	
	[self.HTTPClient enqueueHTTPRequestOperation:requestOperation];
	
	return requestOperation;
}

-(RKObjectRequestOperation*)rkk_enqueueRestkitRequestOperationForRoute:(RKRoute *)route
															parameters:(NSDictionary *)parameters
																		success:(void (^)(RKObjectRequestOperation *, RKMappingResult *))success
																		failure:(void (^)(RKObjectRequestOperation *, NSError *))failure
{
	return [self rkk_enqueueRestkitManagedObjectRequestOperationForRoute:route parameters:parameters managedObjectContext:nil success:success failure:failure];
}

-(RKObjectRequestOperation*)rkk_enqueueRestkitManagedObjectRequestOperationForRoute:(RKRoute*)route
																		 parameters:(NSDictionary*)parameters
															   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																			success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																			failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
	return [self rkk_enqueueRestkitManagedObjectRequestOperationForRoute:route parameters:parameters managedObjectContext:managedObjectContext success:success failure:failure];
}

@end
