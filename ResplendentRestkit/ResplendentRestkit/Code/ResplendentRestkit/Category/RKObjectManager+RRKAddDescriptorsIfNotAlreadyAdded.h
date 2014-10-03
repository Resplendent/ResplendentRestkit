//
//  RKObjectManager+RRKAddDescriptorsIfNotAlreadyAdded.h
//  ResplendentRestkit
//
//  Created by Benjamin Maer on 10/3/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RKObjectManager.h"





@interface RKObjectManager (RRKAddDescriptorsIfNotAlreadyAdded)

-(void)rrk_addResponseDescriptorIfDoesNotAlreadyExist:(RKResponseDescriptor*)responseDescriptor;
-(void)rrk_addRequestDescriptorIfDoesNotAlreadyExist:(RKRequestDescriptor*)requestDescriptor;

@end
