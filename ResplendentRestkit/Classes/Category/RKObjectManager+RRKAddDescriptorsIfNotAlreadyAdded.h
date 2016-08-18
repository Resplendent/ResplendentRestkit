//
//  RKObjectManager+RRKAddDescriptorsIfNotAlreadyAdded.h
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

@import RestKit;





@interface RKObjectManager (RRKAddDescriptorsIfNotAlreadyAdded)

-(void)rrk_addResponseDescriptorIfDoesNotAlreadyExist:(RKResponseDescriptor*)responseDescriptor;
-(void)rrk_addRequestDescriptorIfDoesNotAlreadyExist:(RKRequestDescriptor*)requestDescriptor;

-(void)rrk_addResponseDescriptorsIfDoesNotAlreadyExistWithKeyPathToMappingDictionary:(NSDictionary *)keyPathToMappingDictionary
																			  method:(RKRequestMethod)method
																		 pathPattern:(NSString *)pathPattern
																		 statusCodes:(NSIndexSet *)statusCodes;

@end
