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

typedef void(^rrk_rkOperationAndMappingResultBlock) (RKObjectRequestOperation *operation, RKMappingResult *mappingResult);
typedef void(^rrk_rkOperationAndErrorBlock) (RKObjectRequestOperation *operation, NSError *error);
typedef void(^rrk_afOperationAndResponseObjectBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void(^rrk_afOperationAndErrorBlock) (AFHTTPRequestOperation *operation, NSError *error);
typedef void(^rrk_uploadProgressBlock) (NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);





/*
 These methods unfortunately won't get restkit's routing metadata
 */
@interface RKObjectManager (RRKCreateRequestsFromRoutes)

//AFNetworking operation
-(AFHTTPRequestOperation*)rrk_enqueueAFNetworkingRequestOperationForRoute:(RKRoute*)route
																   object:(id)object
															   parameters:(NSDictionary*)parameters
														cancelOldRequests:(BOOL)cancelOldRequests
																  success:(rrk_afOperationAndResponseObjectBlock)success
																  failure:(rrk_afOperationAndErrorBlock)failure;

//Restkit operation
-(RKObjectRequestOperation*)rrk_enqueueRestkitRequestOperationForRoute:(RKRoute*)route
																object:(id)object
															parameters:(NSDictionary*)parameters
													 cancelOldRequests:(BOOL)cancelOldRequests
															   success:(rrk_rkOperationAndMappingResultBlock)success
															   failure:(rrk_rkOperationAndErrorBlock)failure;

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectRequestOperationForRoute:(RKRoute*)route
																			 object:(NSManagedObject*)object
																		 parameters:(NSDictionary*)parameters
																  cancelOldRequests:(BOOL)cancelOldRequests
															   managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																			success:(rrk_rkOperationAndMappingResultBlock)success
																			failure:(rrk_rkOperationAndErrorBlock)failure;

//Multipart Form
-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																						 path:(NSString *)path
																				   parameters:(NSDictionary *)parameters
																					   object:(NSManagedObject*)object
																					formBlock:(void (^)(id <AFMultipartFormData> formData))formBlock
																			cancelOldRequests:(BOOL)cancelOldRequests
																		 managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																		  uploadProgressBlock:(rrk_uploadProgressBlock)uploadProgressBlock
																					  success:(rrk_rkOperationAndMappingResultBlock)success
																					  failure:(rrk_rkOperationAndErrorBlock)failure;

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
																					  failure:(rrk_rkOperationAndErrorBlock)failure;

-(RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectPNGImageUploadRequestOperationForMethod:(RKRequestMethod)method
																							  path:(NSString *)path
																						parameters:(NSDictionary *)parameters
																						  pngImage:(UIImage*)pngImage
																							object:(NSManagedObject*)object
																				 cancelOldRequests:(BOOL)cancelOldRequests
																			  managedObjectContext:(NSManagedObjectContext *)managedObjectContext
																			   uploadProgressBlock:(rrk_uploadProgressBlock)uploadProgressBlock
																						   success:(rrk_rkOperationAndMappingResultBlock)success
																						   failure:(rrk_rkOperationAndErrorBlock)failure;

-(void)rrk_addRouteIfNotAlreadyAdded:(RKRoute*)route cancelOldRequests:(BOOL)cancelOldRequests;

+(NSString*)mimeTypeForImageType:(RRKCreateRequestsFromRoutes_RKObjectManager_ImageType)imageType;

@end
