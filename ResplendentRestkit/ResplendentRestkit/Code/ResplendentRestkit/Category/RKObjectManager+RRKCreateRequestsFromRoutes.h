//
//  RKObjectManager+RRKCreateRequestsFromRoutes.h
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKObjectManager.h"





@interface RKObjectManager (RRKCreateRequestsFromRoutes)

//AFNetworking operation
-(AFHTTPRequestOperation*)rkk_enqueueAFNetworkingRequestOperationForRoute:(RKRoute*)route
																		parameters:(NSDictionary*)parameters
																  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
																  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Restkit operation
-(RKObjectRequestOperation*)rkk_enqueueRestkitRequestOperationForRoute:(RKRoute*)route
															parameters:(NSDictionary*)parameters
																		success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																		failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

-(RKObjectRequestOperation*)rkk_enqueueRestkitManagedObjectRequestOperationForRoute:(RKRoute*)route
																		 parameters:(NSDictionary*)parameters
															   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																			success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																			failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
