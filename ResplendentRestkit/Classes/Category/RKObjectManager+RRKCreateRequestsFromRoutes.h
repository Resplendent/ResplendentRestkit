//
//  RKObjectManager+RRKCreateRequestsFromRoutes.h
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RRKBlocks.h"

@import RestKit;

@import CoreData;





@class NSObjectManager;






typedef NS_ENUM(NSInteger, RRKCreateRequestsFromRoutes_RKObjectManager_ImageType) {
	RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_JPEG,
	RRKCreateRequestsFromRoutes_RKObjectManager_ImageType_PNG
};





/*
 These methods unfortunately won't get restkit's routing metadata
 */
@interface RKObjectManager (RRKCreateRequestsFromRoutes)

#pragma mark - Restkit requests
-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitRequestOperationForRoute:(nonnull RKRoute*)route
																		 object:(nullable id)object
																	 parameters:(nullable NSDictionary*)parameters
															  cancelOldRequests:(BOOL)cancelOldRequests
																		success:(nullable rrk_rkOperationAndMappingResultBlock)success
																		failure:(nullable rrk_rkOperationAndErrorBlock)failure;

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectRequestOperationForRoute:(nonnull RKRoute*)route
																					  object:(nullable NSManagedObject*)object
																				  parameters:(nullable NSDictionary*)parameters
																		   cancelOldRequests:(BOOL)cancelOldRequests
																		managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																					 success:(nullable rrk_rkOperationAndMappingResultBlock)success
																					 failure:(nullable rrk_rkOperationAndErrorBlock)failure;

//Multipart Form
-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectMultiPartRequestOperationForMethod:(RKRequestMethod)method
																								  path:(nonnull NSString*)path
																							parameters:(nullable NSDictionary*)parameters
																								object:(nullable NSManagedObject*)object
																							 formBlock:(nullable rrk_AFRKMultipartFormData_block)formBlock
																					 cancelOldRequests:(BOOL)cancelOldRequests
																				  managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																				   uploadProgressBlock:(nullable rrk_uploadProgressBlock)uploadProgressBlock
																							   success:(nullable rrk_rkOperationAndMappingResultBlock)success
																							   failure:(nullable rrk_rkOperationAndErrorBlock)failure;

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
																							   failure:(nullable rrk_rkOperationAndErrorBlock)failure;

-(nullable RKObjectRequestOperation*)rrk_enqueueRestkitManagedObjectPNGImageUploadRequestOperationForMethod:(RKRequestMethod)method
																									   path:(nonnull NSString*)path
																								 parameters:(nullable NSDictionary*)parameters
																								   pngImage:(nonnull UIImage*)pngImage
																									 object:(nullable NSManagedObject*)object
																						  cancelOldRequests:(BOOL)cancelOldRequests
																					   managedObjectContext:(nullable NSManagedObjectContext*)managedObjectContext
																						uploadProgressBlock:(nullable rrk_uploadProgressBlock)uploadProgressBlock
																									success:(nullable rrk_rkOperationAndMappingResultBlock)success
																									failure:(nullable rrk_rkOperationAndErrorBlock)failure;

#pragma mark - Image Type
+(nullable NSString*)mimeTypeForImageType:(RRKCreateRequestsFromRoutes_RKObjectManager_ImageType)imageType;

#pragma mark - Add Route and cancel
-(void)rrk_addRouteIfNotAlreadyAdded:(nonnull RKRoute*)route cancelOldRequests:(BOOL)cancelOldRequests;

@end
