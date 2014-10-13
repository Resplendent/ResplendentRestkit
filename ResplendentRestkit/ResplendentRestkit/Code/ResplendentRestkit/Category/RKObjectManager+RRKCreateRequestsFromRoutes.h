//
//  RKObjectManager+RRKCreateRequestsFromRoutes.h
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKObjectManager.h"





typedef NS_ENUM(NSInteger, RRKCreateRequestsFromRoutes_RKObjectManager_ImageType) {
	RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_JPEG,
	RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_PNG
};





@interface RKObjectManager (RRKCreateRequestsFromRoutes)

//AFNetworking operation
-(AFHTTPRequestOperation*)rrk_enqueueAFNetworkingRequestOperationForRoute:(RKRoute*)route
																   object:(id)object
															   parameters:(NSDictionary*)parameters
														cancelOldRequests:(BOOL)cancelOldRequests
																  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
																  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Restkit operation
-(RKObjectRequestOperation*)rrk_enqueueRestkitRequestOperationForRoute:(RKRoute*)route
																object:(id)object
															parameters:(NSDictionary*)parameters
													 cancelOldRequests:(BOOL)cancelOldRequests
															   success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
															   failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

//-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectRequestOperationForRoute:(RKRoute*)route
//																			 object:(NSManagedObject*)object
//																		 parameters:(NSDictionary*)parameters
//																  cancelOldRequests:(BOOL)cancelOldRequests
//																			success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//																			failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

//Multipart Form
-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																						 path:(NSString *)path
																				   parameters:(NSDictionary *)parameters
																					   object:(NSManagedObject*)object
																					formBlock:(void (^)(id <AFMultipartFormData> formData))formBlock
																			cancelOldRequests:(BOOL)cancelOldRequests
																		 managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																					  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																					  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

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
																					  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectPNGImageUploadRequestOperationForMethod:(RKRequestMethod)method
																							  path:(NSString *)path
																						parameters:(NSDictionary *)parameters
																						  pngImage:(UIImage*)pngImage
																							object:(NSManagedObject*)object
																				 cancelOldRequests:(BOOL)cancelOldRequests
																			  managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																						   success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
																						   failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+(NSString*)mimeTypeForImageType:(RRKCreateRequestsFromRoutes_RKObjectManager_ImageType)imageType;

@end
